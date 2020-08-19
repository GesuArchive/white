import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const CargoHoldTerminal = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    points,
    pad,
    sending,
    status_report,
  } = data;
  return (
    <Window
      width={600}
      height={230}
      resizable>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Текущий баланс">
              <Box inline bold>
                <AnimatedNumber value={Math.round(points)} /> кредитов
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Платформа снабжения"
          buttons={(
            <Fragment>
              <Button
                icon={"sync"}
                content={"Расчитать стоимость"}
                disabled={!pad}
                onClick={() => act('recalc')} />
              <Button
                icon={sending ? 'times' : 'arrow-up'}
                content={sending ? "СТОП!" : "Отправлять"}
                selected={sending}
                disabled={!pad}
                onClick={() => act(sending ? 'stop' : 'send')} />
            </Fragment>
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Состояние"
              color={pad ? "good" : "bad"}>
              {pad ? "Включено" : "Не найдено"}
            </LabeledList.Item>
            <LabeledList.Item label="Заметка снабжения">
              {status_report}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
