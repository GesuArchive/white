import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const TransferValve = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    tank_one,
    tank_two,
    attached_device,
    valve,
  } = data;
  return (
    <Window
      width={310}
      height={300}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Состояние вентиля">
              <Button
                icon={valve ? "unlock" : "lock"}
                content={valve ? "Открыт" : "Закрыт"}
                disabled={!tank_one || !tank_two}
                onClick={() => act('toggle')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Устройство управления"
          buttons={(
            <Button
              content="Настроить"
              icon={"cog"}
              disabled={!attached_device}
              onClick={() => act('device')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Присоединено">
              {attached_device ? (
                <Button
                  icon={"eject"}
                  content={attached_device}
                  disabled={!attached_device}
                  onClick={() => act('remove_device')} />
              ) : (
                <Box color="average">
                  Взорвём в руках, а?
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Первый бак">
          <LabeledList>
            <LabeledList.Item label="Присоединено">
              {tank_one ? (
                <Button
                  icon={"eject"}
                  content={tank_one}
                  disabled={!tank_one}
                  onClick={() => act('tankone')} />
              ) : (
                <Box color="average">
                  Внутри нет бака
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Второй бак">
          <LabeledList>
            <LabeledList.Item label="Присоединено">
              {tank_two ? (
                <Button
                  icon={"eject"}
                  content={tank_two}
                  disabled={!tank_two}
                  onClick={() => act('tanktwo')} />
              ) : (
                <Box color="average">
                  Внутри нет бака
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
