import { multiline } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, Grid, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

export const ComputerFabricator = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      title="Раздатчик персональных устройств"
      width={500}
      height={400}>
      <Window.Content>
        <Section italic fontSize="20px">
          Ваш идеальный девайс уже тут...
        </Section>
        {data.state !== 0 && (
          <Button
            fluid
            mb={1}
            icon="circle"
            content="Сброс"
            onClick={() => act('clean_order')} />
        )}
        {data.state === 0 && (
          <CfStep1 />
        )}
        {data.state === 1 && (
          <CfStep2 />
        )}
        {data.state === 2 && (
          <CfStep3 />
        )}
        {data.state === 3 && (
          <CfStep4 />
        )}
      </Window.Content>
    </Window>
  );
};

// This had a pretty gross backend so this was unfortunately one of the
// best ways of doing it.
const CfStep1 = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      title="Шаг 1"
      minHeight="306px">
      <Box
        mt={5}
        bold
        textAlign="center"
        fontSize="40px">
        Выберите тип устройства
      </Box>
      <Box mt={3}>
        <Grid width="100%">
          <Grid.Column>
            <Button
              fluid
              icon="laptop"
              content="Ноутбук"
              textAlign="center"
              fontSize="30px"
              lineHeight={2}
              onClick={() => act('pick_device', {
                pick: '1',
              })} />
          </Grid.Column>
          <Grid.Column>
            <Button
              fluid
              icon="tablet-alt"
              content="Планшет"
              textAlign="center"
              fontSize="30px"
              lineHeight={2}
              onClick={() => act('pick_device', {
                pick: '2',
              })} />
          </Grid.Column>
        </Grid>
      </Box>
    </Section>
  );
};

const CfStep2 = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      title="Шаг 2: Выбор компонентов"
      minHeight="282px"
      buttons={(
        <Box bold color="good">
          {data.totalprice} кр
        </Box>
      )}>
      <Table>
        <Table.Row>
          <Table.Cell
            bold
            position="relative">
            <Tooltip
              content={multiline`
                Даёт возможность вашему устройству работать без подключения
                к сети. Более дорогой аккумулятор работает дольше.
              `}
              position="right">
              Аккумулятор:
            </Tooltip>
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Стандартный"
              selected={data.hw_battery === 1}
              onClick={() => act('hw_battery', {
                battery: '1',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Продвинутый"
              selected={data.hw_battery === 2}
              onClick={() => act('hw_battery', {
                battery: '2',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Мощный"
              selected={data.hw_battery === 3}
              onClick={() => act('hw_battery', {
                battery: '3',
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell
            bold
            position="relative">
            <Tooltip
              content={multiline`
              Хранит файлы на устройсте. Продвинутые диски могут хранить
              больше данных, но потребляют больше энергии.
              `}
              position="right">
              Жесткий диск:
            </Tooltip>
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Стандартный"
              selected={data.hw_disk === 1}
              onClick={() => act('hw_disk', {
                disk: '1',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Продвинутый"
              selected={data.hw_disk === 2}
              onClick={() => act('hw_disk', {
                disk: '2',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Мощный"
              selected={data.hw_disk === 3}
              onClick={() => act('hw_disk', {
                disk: '3',
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            <Tooltip
              content={multiline`
                Позволяет устройству подключаться к беспроводной сети на
                станции. Продвинутые сетевые карты могут работать и в дали от
                станции, включая местные отели и другие гражданские объекты.
              `}
              position="right">
              Сетевая карта:
            </Tooltip>
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Нет"
              selected={data.hw_netcard === 0}
              onClick={() => act('hw_netcard', {
                netcard: '0',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Стандартная"
              selected={data.hw_netcard === 1}
              onClick={() => act('hw_netcard', {
                netcard: '1',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Мощная"
              selected={data.hw_netcard === 2}
              onClick={() => act('hw_netcard', {
                netcard: '2',
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            <Tooltip
              content={multiline`
                Устройство, позволяющее делать бумажную работу,
                такую как сканирование и копирование документов.
                Это устройство сертифицировано EcoFriendlyPlus и
                умеет перерабатывать использованную бумагу.
              `}
              position="right">
              Принтер:
            </Tooltip>
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Нет"
              selected={data.hw_nanoprint === 0}
              onClick={() => act('hw_nanoprint', {
                print: '0',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Стандартный"
              selected={data.hw_nanoprint === 1}
              onClick={() => act('hw_nanoprint', {
                print: '1',
              })} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell bold position="relative">
            <Tooltip
              content={multiline`
                Добавляет дополнительный читатель RFID карт, для
                чтения или записи с них. Учтите, что основной читатель
                карт обязателен для всех устройств, так что его цена уже
                включена в стоимость.
              `}
              position="right">
              Вторичный кард-ридер:
            </Tooltip>
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Нет"
              selected={data.hw_card === 0}
              onClick={() => act('hw_card', {
                card: '0',
              })} />
          </Table.Cell>
          <Table.Cell>
            <Button
              content="Стандартный"
              selected={data.hw_card === 1}
              onClick={() => act('hw_card', {
                card: '1',
              })} />
          </Table.Cell>
        </Table.Row>
        {data.devtype !== 2 && (
          <>
            <Table.Row>
              <Table.Cell bold position="relative">
                <Tooltip
                  content={multiline`
                    Важный компонент в устройстве без которого оно не будет
                    работать. Он позволяет запускать программы с диска.
                    Более дорогие процессоры позволяют запускать намного
                    больше программ в фоне.
                  `}
                  position="right">
                  Процессор:
                </Tooltip>
              </Table.Cell>
              <Table.Cell>
                <Button
                  content="Стандартный"
                  selected={data.hw_cpu === 1}
                  onClick={() => act('hw_cpu', {
                    cpu: '1',
                  })} />
              </Table.Cell>
              <Table.Cell>
                <Button
                  content="Мощный"
                  selected={data.hw_cpu === 2}
                  onClick={() => act('hw_cpu', {
                    cpu: '2',
                  })} />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell bold position="relative">
                <Tooltip
                  content={multiline`
                    Продвинутый способ заряжать ваше устройство не
                    подключая его к сети напрямую. Берёт энергию из
                    ближайших энергощитков. Этот компонент недоступен
                    в планшетах, учтите.
                  `}
                  position="right">
                  Тесла-реле:
                </Tooltip>
              </Table.Cell>
              <Table.Cell>
                <Button
                  content="Нет"
                  selected={data.hw_tesla === 0}
                  onClick={() => act('hw_tesla', {
                    tesla: '0',
                  })} />
              </Table.Cell>
              <Table.Cell>
                <Button
                  content="Стандартный"
                  selected={data.hw_tesla === 1}
                  onClick={() => act('hw_tesla', {
                    tesla: '1',
                  })} />
              </Table.Cell>
            </Table.Row>
          </>
        )}
      </Table>
      <Button
        fluid
        mt={3}
        content="Подтвердить"
        color="good"
        textAlign="center"
        fontSize="18px"
        lineHeight={2}
        onClick={() => act('confirm_order')} />
    </Section>
  );
};

const CfStep3 = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      title="Шаг 3: Оплата"
      minHeight="282px">
      <Box
        italic
        textAlign="center"
        fontSize="20px">
        Ваше устройство готово к сборке...
      </Box>
      <Box
        bold
        mt={2}
        textAlign="center"
        fontSize="16px">
        <Box inline>
          Введите
        </Box>
        {' '}
        <Box inline color="good">
          {data.totalprice} кр
        </Box>
      </Box>
      <Box
        bold
        mt={1}
        textAlign="center"
        fontSize="18px">
        Введено:
      </Box>
      <Box
        bold
        mt={0.5}
        textAlign="center"
        fontSize="18px"
        color={data.credits >= data.totalprice ? "good" : "bad"}>
        {data.credits} cr
      </Box>
      <Button
        fluid
        content="Купить"
        disabled={data.credits < data.totalprice}
        mt={8}
        color="good"
        textAlign="center"
        fontSize="20px"
        lineHeight={2}
        onClick={() => act('purchase')} />
    </Section>
  );
};

const CfStep4 = (props, context) => {
  return (
    <Section
      minHeight="282px">
      <Box
        bold
        textAlign="center"
        fontSize="28px"
        mt={10}>
        Спасибо за покупку!
      </Box>
      <Box
        italic
        mt={1}
        textAlign="center">
        Если возникнут проблемы с устройством, то пожалуйста,
        свяжитесь с вашим местным системным администратором.
      </Box>
    </Section>
  );
};
