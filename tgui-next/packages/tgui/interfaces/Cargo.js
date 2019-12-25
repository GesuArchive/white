import { map } from 'common/collections';
import { Fragment } from 'inferno';
import { act } from '../byond';
import { AnimatedNumber, Box, Button, LabeledList, Section, Tabs } from '../components';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Cargo = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const supplies = data.supplies || {};
  const requests = data.requests || [];
  const cart = data.cart || [];

  const cartTotalAmount = cart
    .reduce((total, entry) => total + entry.cost, 0);

  const cartButtons = !data.requestonly && (
    <Fragment>
      <Box inline mx={1}>
        {cart.length === 0 && 'Корзина пуста'}
        {cart.length === 1 && '1 товар'}
        {cart.length >= 2 && cart.length + ' товаров'}
        {' '}
        {cartTotalAmount > 0 && `(${cartTotalAmount} кредитов)`}
      </Box>
      <Button
        icon="times"
        color="transparent"
        content="Очистить"
        onClick={() => act(ref, 'clear')} />
    </Fragment>
  );

  return (
    <Fragment>
      <Section
        title="Снабжение"
        buttons={(
          <Box inline bold>
            Баланс: <AnimatedNumber value={Math.round(data.points)} /> кредитов
          </Box>
        )}>
        <LabeledList>
          <LabeledList.Item label="Шаттл">
            {data.docked && !data.requestonly && (
              <Button
                content={data.location}
                onClick={() => act(ref, 'send')} />
            ) || data.location}
          </LabeledList.Item>
          <LabeledList.Item label="Сообщение ЦК">
            {data.message}
          </LabeledList.Item>
          {(data.loan && !data.requestonly) ? (
            <LabeledList.Item label="Ссуда">
              {!data.loan_dispatched ? (
                <Button
                  content="Передать шаттл"
                  disabled={!(data.away && data.docked)}
                  onClick={() => act(ref, 'loan')} />
              ) : (
                <Box color="bad">Передано на ЦК</Box>
              )}
            </LabeledList.Item>
          ) : ''}
        </LabeledList>
      </Section>
      <Tabs mt={2}>
        <Tabs.Tab
          key="catalog"
          label="Каталог"
          icon="list"
          lineHeight="23px">
          {() => (
            <Section
              title="Каталог"
              buttons={(
                <Fragment>
                  {cartButtons}
                  <Button
                    ml={1}
                    icon={data.self_paid ? 'check-square-o' : 'square-o'}
                    content="За мой счёт"
                    selected={data.self_paid}
                    onClick={() => act(ref, 'toggleprivate')} />
                </Fragment>
              )}>
              <Catalog state={state} supplies={supplies} />
            </Section>
          )}
        </Tabs.Tab>
        <Tabs.Tab
          key="requests"
          label={`Запросы (${requests.length})`}
          icon="envelope"
          highlight={requests.length > 0}
          lineHeight="23px">
          {() => (
            <Section
              title="Активные запросы"
              buttons={!data.requestonly && (
                <Button
                  icon="times"
                  content="Очистить"
                  color="transparent"
                  onClick={() => act(ref, 'denyall')} />
              )}>
              <Requests state={state} requests={requests} />
            </Section>
          )}
        </Tabs.Tab>
        {!data.requestonly && (
          <Tabs.Tab
            key="cart"
            label={`Корзина (${cart.length})`}
            icon="shopping-cart"
            highlight={cart.length > 0}
            lineHeight="23px">
            {() => (
              <Section
                title="Текущая корзина"
                buttons={cartButtons}>
                <Cart state={state} cart={cart} />
              </Section>
            )}
          </Tabs.Tab>
        )}
      </Tabs>
    </Fragment>
  );
};

const Catalog = props => {
  const { state, supplies } = props;
  const { config, data } = state;
  const { ref } = config;
  const renderTab = key => {
    const supply = supplies[key];
    const packs = supply.packs;
    return (
      <table className="LabeledList">
        {packs.map(pack => (
          <tr
            key={pack.name}
            className="LabeledList__row candystripe">
            <td className="LabeledList__cell LabeledList__label">
              {pack.name}:
            </td>
            <td className="LabeledList__cell">
              {!!pack.small_item && (
                <Fragment>Небольшой</Fragment>
              )}
            </td>
            <td className="LabeledList__cell">
              {!!pack.access && (
                <Fragment>Защищено</Fragment>
              )}
            </td>
            <td className="LabeledList__cell LabeledList__buttons">
              <Button fluid
                content={(data.self_paid
                  ? Math.round(pack.cost * 1.1)
                  : pack.cost) + ' кредитов'}
                onClick={() => act(ref, 'add', {
                  id: pack.id,
                })} />
            </td>
          </tr>
        ))}
      </table>
    );
  };
  return (
    <Tabs vertical>
      {map(supply => {
        const name = supply.name;
        return (
          <Tabs.Tab key={name} label={name}>
            {renderTab}
          </Tabs.Tab>
        );
      })(supplies)}
    </Tabs>
  );
};

const Requests = props => {
  const { state, requests } = props;
  const { config, data } = state;
  const { ref } = config;
  if (requests.length === 0) {
    return (
      <Box color="good">
        Нет запросов
      </Box>
    );
  }
  // Labeled list reimplementation to squeeze extra columns out of it
  return (
    <table className="LabeledList">
      {requests.map(request => (
        <Fragment key={request.id}>
          <tr className="LabeledList__row candystripe">
            <td className="LabeledList__cell LabeledList__label">
              #{request.id}:
            </td>
            <td className="LabeledList__cell LabeledList__content">
              {request.object}
            </td>
            <td className="LabeledList__cell">
              От <b>{request.orderer}</b>
            </td>
            <td className="LabeledList__cell">
              <i>{request.reason}</i>
            </td>
            <td className="LabeledList__cell LabeledList__buttons">
              {request.cost} кредитов
              {' '}
              {!data.requestonly && (
                <Fragment>
                  <Button
                    icon="check"
                    color="good"
                    onClick={() => act(ref, 'approve', {
                      id: request.id,
                    })} />
                  <Button
                    icon="times"
                    color="bad"
                    onClick={() => act(ref, 'deny', {
                      id: request.id,
                    })} />
                </Fragment>
              )}
            </td>
          </tr>
        </Fragment>
      ))}
    </table>
  );
};

const Cart = props => {
  const { state, cart } = props;
  const { config, data } = state;
  const { ref } = config;
  return (
    <Fragment>
      {cart.length === 0 && 'Корзина пуста'}
      {cart.length > 0 && (
        <LabeledList>
          {cart.map(entry => (
            <LabeledList.Item
              key={entry.id}
              className="candystripe"
              label={'#' + entry.id}
              buttons={(
                <Fragment>
                  <Box inline mx={2}>
                    {!!entry.paid && (<b>[Paid Privately]</b>)}
                    {' '}
                    {entry.cost} кредитов
                  </Box>
                  <Button
                    icon="minus"
                    onClick={() => act(ref, 'remove', {
                      id: entry.id,
                    })} />
                </Fragment>
              )}>
              {entry.object}
            </LabeledList.Item>
          ))}
        </LabeledList>
      )}
      {cart.length > 0 && !data.requestonly && (
        <Box mt={2}>
          {data.away === 1 && data.docked === 1 && (
            <Button
              color="green"
              style={{
                'line-height': '28px',
                'padding': '0 12px',
              }}
              content="Подтвердить заказ"
              onClick={() => act(ref, 'send')} />
          ) || (
            <Box opacity={0.5}>
              Shuttle in {data.location}.
            </Box>
          )}
        </Box>
      )}
    </Fragment>
  );
};

export const CargoExpress = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const supplies = data.supplies || {};
  return (
    <Fragment>
      <InterfaceLockNoticeBox
        siliconUser={data.siliconUser}
        locked={data.locked}
        onLockStatusChange={() => act(ref, 'lock')}
        accessText="a QM-level ID card" />
      {!data.locked &&(
        <Fragment>
          <Section
            title="Снабжение Экспресс"
            buttons={(
              <Box inline bold>
                <AnimatedNumber value={Math.round(data.points)} /> credits
              </Box>
            )}>
            <LabeledList>
              <LabeledList.Item label="Место высадки">
                <Button
                  content="Отдел снабжения"
                  selected={!data.usingBeacon}
                  onClick={() => act(ref, 'LZCargo')} />
                <Button
                  selected={data.usingBeacon}
                  disabled={!data.hasBeacon}
                  onClick={() => act(ref, 'LZBeacon')}>
                  {data.beaconzone} ({data.beaconName})
                </Button>
                <Button
                  content={data.printMsg}
                  disabled={!data.canBuyBeacon}
                  onClick={() => act(ref, 'printBeacon')} />
              </LabeledList.Item>
              <LabeledList.Item label="Заметка">
                {data.message}
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Catalog state={state} supplies={supplies} />
        </Fragment>
      )}
    </Fragment>
  );
};
