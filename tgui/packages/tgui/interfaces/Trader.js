import { map } from 'common/collections';
import { Fragment } from 'inferno';
import { act } from '../byond';
import { AnimatedNumber, Box, Button, LabeledList, Section, Tabs } from '../components';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Trader = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const supplies = data.supplies || {};
  const cart = data.cart || [];

  const cartTotalAmount = cart
    .reduce((total, entry) => total + entry.cost, 0);

  const cartButtons = !data.requestonly && (
    <Fragment>
      <Box inline mx={1}>
        {cart.length === 0 && 'Корзина пуста'}
        {cart.length === 1 && '1 предмет'}
        {cart.length >= 2 && cart.length + ' предметов'}
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
        title="Торговая зона"
        buttons={(
          <Box inline bold>
            Баланс: <AnimatedNumber value={Math.round(data.points)} /> кредитов
          </Box>
        )}>
        <LabeledList>
          <LabeledList.Item label="Торговля">
            <Button
              content="Купить"
              onClick={() => act(ref, 'buy')} />
            <Button
              content="Продать"
              onClick={() => act(ref, 'sell')} />
          </LabeledList.Item>
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
              buttons={cartButtons}>
              <Catalog state={state} supplies={supplies} />
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
                <Fragment>Малый размер</Fragment>
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
                  ? Math.round(pack.cost * 2)
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
    </Fragment>
  );
};
