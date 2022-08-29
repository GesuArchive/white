import { sortBy } from '../../common/collections';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

type FaxData = {
  faxes: FaxInfo[];
  fax_id: string;
  fax_name: string;
  has_paper: string;
  syndicate_network: boolean;
  fax_history: FaxHistory[];
};

type FaxInfo = {
  fax_name: string;
  fax_id: string;
  has_paper: boolean;
  syndicate_network: boolean;
};

type FaxHistory = {
  history_type: string;
  history_fax_name: string;
  history_time: string;
};

export const Fax = (props, context) => {
  const { act } = useBackend(context);
  const { data } = useBackend<FaxData>(context);
  const faxes = sortBy((sortFax: FaxInfo) => sortFax.fax_name)(
    data.syndicate_network
      ? data.faxes
      : data.faxes.filter((filterFax: FaxInfo) => !filterFax.syndicate_network)
  );
  return (
    <Window width={340} height={540}>
      <Window.Content scrollable>
        <Section title="Факс">
          <LabeledList.Item label="Имя сети">
            {data.fax_name}
          </LabeledList.Item>
          <LabeledList.Item label="ID сети">{data.fax_id}</LabeledList.Item>
        </Section>
        <Section
          title="Бумага"
          buttons={
            <Button
              onClick={() => act('remove')}
              disabled={data.has_paper ? false : true}>
              Изъять
            </Button>
          }>
          <LabeledList.Item label="Бумага">
            {data.has_paper ? (
              <Box color="green">Бумага в лотке</Box>
            ) : (
              <Box color="red">Нет бумаги</Box>
            )}
          </LabeledList.Item>
        </Section>
        <Section title="Отправить">
          <Box mt={0.4}>
            {faxes.map((fax: FaxInfo) => (
              <Button
                key={fax.fax_id}
                title={fax.fax_name}
                disabled={!data.has_paper}
                color={fax.syndicate_network ? 'red' : 'blue'}
                onClick={() =>
                  act('send', {
                    id: fax.fax_id,
                  })
                }>
                {fax.fax_name}
              </Button>
            ))}
          </Box>
        </Section>
        <Section
          title="История"
          buttons={
            <Button
              onClick={() => act('history_clear')}
              disabled={data.fax_history ? false : true}>
              Очистить
            </Button>
          }>
          <Table>
            <Table.Cell>
              {data.fax_history !== null
                ? data.fax_history.map((history: FaxHistory) => (
                  <Table.Row key={history.history_type}>
                    {
                      <Box
                        color={
                          history.history_type === 'Отправка' ? 'Green' : 'Red'
                        }>
                        {history.history_type}
                      </Box>
                    }
                    {history.history_fax_name} - {history.history_time}
                  </Table.Row>
                ))
                : null}
            </Table.Cell>
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
