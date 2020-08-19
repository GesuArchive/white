import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Section, Table } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const CargoBountyConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    bountydata = [],
  } = data;
  return (
    <Window
      width={750}
      height={600}
      resizable>
      <Window.Content scrollable>
        <Section
          title={<BountyHeader />}
          buttons={(
            <Button
              icon="print"
              content="Распечатать список заказов"
              onClick={() => act('Print')} />
          )}>
          <Table border>
            <Table.Row
              bold
              italic
              color="label"
              fontSize={1.25}>
              <Table.Cell p={1} textAlign="center">
                Объект
              </Table.Cell>
              <Table.Cell p={1} textAlign="center">
                Описание
              </Table.Cell>
              <Table.Cell p={1} textAlign="center">
                Прогресс
              </Table.Cell>
              <Table.Cell p={1} textAlign="center">
                Цена
              </Table.Cell>
              <Table.Cell p={1} textAlign="center">
                Выполнение
              </Table.Cell>
            </Table.Row>
            {bountydata.map(bounty => (
              <Table.Row
                key={bounty.name}
                backgroundColor={bounty.priority === 1
                  ? 'rgba(252, 152, 3, 0.25)'
                  : ''}>
                <Table.Cell bold p={1}>
                  {bounty.name}
                </Table.Cell>
                <Table.Cell
                  italic
                  textAlign="center"
                  p={1}>
                  {bounty.description}
                </Table.Cell>
                <Table.Cell
                  bold
                  p={1}
                  textAlign="center">
                  {bounty.priority === 1
                    ? <Box>Высокий приоритет</Box>
                    : ""}
                  {bounty.completion_string}
                </Table.Cell>
                <Table.Cell
                  bold
                  p={1}
                  textAlign="center">
                  {bounty.reward_string}
                </Table.Cell>
                <Table.Cell
                  bold
                  p={1}>
                  <Button
                    fluid
                    textAlign="center"
                    icon={bounty.claimed === 1
                      ? "check"
                      : ""}
                    content={bounty.claimed === 1
                      ? "Выполнено"
                      : "Выполнить"}
                    disabled={bounty.claimed === 1}
                    color={bounty.can_claim === 1
                      ? 'green'
                      : 'red'}
                    onClick={() => act('ClaimBounty', {
                      bounty: bounty.bounty_ref,
                    })} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};

const BountyHeader = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    stored_cash,
  } = data;
  return (
    <Box inline bold>
      <AnimatedNumber
        value={stored_cash}
        format={value => formatMoney(value)} />
      {' кредитов'}
    </Box>
  );
};
