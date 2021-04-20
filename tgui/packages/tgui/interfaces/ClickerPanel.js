import { useBackend } from '../backend';
import { Box, Table, Button, Section } from '../components';
import { Window } from '../layouts';

export const ClickerPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    clickers = [],
  } = data;
  return (
    <Window
      width={300}
      height={600}>
      <Window.Content>
        <Table>
          <Table.Row header>
            <Table.Cell>
              CKey
            </Table.Cell>
            <Table.Cell>
              CPS
            </Table.Cell>
            <Table.Cell>
              CPM
            </Table.Cell>
          </Table.Row>
          {clickers.map(negr => (
            <tr key={negr.id} className="Table__row candystripe">
              <td className="Table__cell text-center text-nowrap">
                {negr.id}
              </td>
              <td className="Table__cell text-center text-nowrap">
                {negr.cps}
              </td>
              <td className="Table__cell text-center text-nowrap">
                {negr.cpm}
              </td>
            </tr>
          ))}
        </Table>
      </Window.Content>
    </Window>
  );
};
