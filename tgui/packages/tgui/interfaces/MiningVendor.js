import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

export const MiningVendor = (props, context) => {
  const { act, data } = useBackend(context);
  let inventory = [
    ...data.product_records,
  ];
  return (
    <Window
      width={425}
      height={600}>
      <Window.Content scrollable>
        <Section title="Пользователь">
          {data.user && (
            <Box>
              Привет, <b>{data.user.name || "Неизвестный"}</b>,
              {' '}
              <b>{data.user.job || "Безработный"}</b>!
              <br />
              Ваш баланс <b>{data.user.points} очков</b>.
            </Box>
          ) || (
            <Box color="light-gray">
              Не обнаружено ID-карты!<br />
              Свяжитесь с местным отделом кадров!
            </Box>
          )}
        </Section>
        <Section title="Снаряжение">
          <Table>
            {inventory.map((product => {
              return (
                <Table.Row key={product.name}>
                  <Table.Cell>
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                      }} />
                    {' '}<b>{product.name}</b>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{
                        'min-width': '95px',
                        'text-align': 'center',
                      }}
                      disabled={!data.user
                        || product.price > data.user.points}
                      content={product.price + ' points'}
                      onClick={() => act('purchase', {
                        'ref': product.ref,
                      })} />
                  </Table.Cell>
                </Table.Row>
              );
            }))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
