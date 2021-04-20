import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const StackingConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    machine,
  } = data;
  return (
    <Window
      width={320}
      height={340}>
      <Window.Content scrollable>
        {!machine ? (
          <NoticeBox>
            Не обнаружен пресс.
          </NoticeBox>
        ) : (
          <StackingConsoleContent />
        )}
      </Window.Content>
    </Window>
  );
};

export const StackingConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    stacking_amount,
    contents = [],
  } = data;
  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Стопки">
            {stacking_amount || "Неизвестно"}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Материалы">
        {!contents.length ? (
          <NoticeBox>
            Внутри ничего нет.
          </NoticeBox>
        ) : (
          <LabeledList>
            {contents.map(sheet => (
              <LabeledList.Item
                key={sheet.type}
                label={sheet.name}
                buttons={(
                  <Button
                    icon="eject"
                    content="Изъять"
                    onClick={() => act('release', {
                      type: sheet.type,
                    })} />
                )}>
                {sheet.amount || "Неизвестно"}
              </LabeledList.Item>
            ))}
          </LabeledList>
        )}
      </Section>
    </>
  );
};
