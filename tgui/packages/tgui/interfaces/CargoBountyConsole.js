import { useBackend, useLocalState } from '../backend';
import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { AnimatedNumber, Box, Button, Section, Table } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const CargoBountyConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const bountydata = flow([
    map((bonty, i) => ({
      ...bonty,
      // Generate a unique id
      id: bonty.name + i,
    })),
    sortByField === 'name' && sortBy(bonty => bonty.name),
    sortByField === 'reward_string' && sortBy(bonty => bonty.reward_string),
  ])(data.bountydata);
  const [
    sortByField,
    setSortByField,
  ] = useLocalState(context, 'sortByField', null);
  return (
    <Window
      width={750}
      height={600}>
      <Window.Content scrollable>
        <Section
          title={<BountyHeader />}
          buttons={(
            <Button
              icon="print"
              content="Распечатать список заказов"
              onClick={() => act('Print')} />
          )}>
          <Box mb={1}>
            <Box inline mr={2} color="label">
              Сортировка:
            </Box>
            <Button.Checkbox
              checked={sortByField === 'name'}
              content="Имя"
              onClick={() => setSortByField(
                sortByField !== 'name' && 'name'
              )} />
            <Button.Checkbox
              checked={sortByField === 'reward_string'}
              content="Награда"
              onClick={() => setSortByField(
                sortByField !== 'reward_string' && 'reward_string'
              )} />
          </Box>
          <Table border>
            <Table.Row
              header
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
              <tr
                key={bounty.id}
                backgroundColor={bounty.priority === 1
                  ? 'rgba(252, 152, 3, 0.25)'
                  : ''}
                className="Table__row  candystripe">
                <td
                  className="Table__cell text-left"
                  bold p={1}>
                  {bounty.name}
                </td>
                <td
                  italic
                  className="Table__cell text-center"
                  p={1}>
                  {bounty.description}
                </td>
                <td
                  bold
                  p={1}
                  className="Table__cell text-center text-nowrap">
                  {bounty.priority === 1
                    ? <Box>Высокий приоритет</Box>
                    : ""}
                  {bounty.completion_string}
                </td>
                <td
                  bold
                  p={1}
                  className="Table__cell text-center text-nowrap">
                  {bounty.reward_string}
                </td>
                <td
                  bold
                  className="Table__cell text-center text-nowrap"
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
                </td>
              </tr>
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
