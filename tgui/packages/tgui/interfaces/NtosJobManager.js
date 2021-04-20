import { useBackend } from '../backend';
import { Button, Section, Table, NoticeBox, Dimmer, Box } from '../components';
import { NtosWindow } from '../layouts';

export const NtosJobManager = (props, context) => {
  return (
    <NtosWindow
      width={450}
      height={620}>
      <NtosWindow.Content scrollable>
        <NtosJobManagerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosJobManagerContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authed,
    cooldown,
    slots = [],
    prioritized = [],
  } = data;
  if (!authed) {
    return (
      <NoticeBox>
        Текущий доступ не имеет прав для управления работами.
      </NoticeBox>
    );
  }
  return (
    <Section>
      {cooldown > 0 && (
        <Dimmer>
          <Box
            bold
            textAlign="center"
            fontSize="20px">
            Ожидайте: {cooldown}s
          </Box>
        </Dimmer>
      )}
      <Table>
        <Table.Row header>
          <Table.Cell>
            Приоритетно
          </Table.Cell>
          <Table.Cell>
            Места
          </Table.Cell>
        </Table.Row>
        {slots.map(slot => (
          <Table.Row
            key={slot.title}
            className="candystripe">
            <Table.Cell
              bold>
              <Button.Checkbox
                fluid
                content={slot.title}
                disabled={slot.total <= 0}
                checked={slot.total > 0 && prioritized.includes(slot.title)}
                onClick={() => act('PRG_priority', {
                  target: slot.title,
                })} />
            </Table.Cell>
            <Table.Cell collapsing>
              {slot.current} / {slot.total}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                content="Открыть"
                disabled={!slot.status_open}
                onClick={() => act('PRG_open_job', {
                  target: slot.title,
                })} />
              <Button
                content="Закрыть"
                disabled={!slot.status_close}
                onClick={() => act('PRG_close_job', {
                  target: slot.title,
                })} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
