import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { act } from '../byond';
import { Box, Button, Section, Table } from '../components';

export const OreBox = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const { materials } = data;
  return (
    <Fragment>
      <Section
        title="Руда"
        buttons={(
          <Button
            content="Пусто"
            onClick={() => act(ref, 'removeall')} />
        )}>
        <Table>
          <Table.Row header>
            <Table.Cell>
              Руда
            </Table.Cell>
            <Table.Cell collapsing textAlign="right">
              Количество
            </Table.Cell>
          </Table.Row>
          {materials.map(material => (
            <Table.Row key={material.type}>
              <Table.Cell>
                {toTitleCase(material.name)}
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Box color="label" inline>
                  {material.amount}
                </Box>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
      <Section>
        <Box>
         Все руды будут размещены здесь, когда вы носите шахтёрскую сумочку
         на поясе или в кармане при перетаскивании коробки с рудой.<br />
         Гибтонит не принимается.
        </Box>
      </Section>
    </Fragment>
  );
};
