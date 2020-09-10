import { toTitleCase } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

export const LaborClaimConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    can_go_home,
    id_points,
    ores,
    status_info,
    unclaimed_points,
  } = data;
  return (
    <Window
      width={315}
      height={440}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Состояние">
              {status_info}
            </LabeledList.Item>
            <LabeledList.Item label="Управление шаттлом">
              <Button
                content="Выслать шаттл"
                disabled={!can_go_home}
                onClick={() => act('move_shuttle')} />
            </LabeledList.Item>
            <LabeledList.Item label="Очки">
              {id_points}
            </LabeledList.Item>
            <LabeledList.Item
              label="Свободные очки"
              buttons={(
                <Button
                  content="Забрать"
                  disabled={!unclaimed_points}
                  onClick={() => act('claim_points')} />
              )}>
              {unclaimed_points}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Ценность материалов">
          <Table>
            <Table.Row header>
              <Table.Cell>
                Материал
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                Цена
              </Table.Cell>
            </Table.Row>
            {ores.map(ore => (
              <Table.Row key={ore.ore}>
                <Table.Cell>
                  {toTitleCase(ore.ore)}
                </Table.Cell>
                <Table.Cell collapsing textAlign="right">
                  <Box color="label" inline>
                    {ore.value}
                  </Box>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
