import { useBackend } from '../backend';
import { BlockQuote, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const Intellicard = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    name,
    isDead,
    isBraindead,
    health,
    wireless,
    radio,
    wiping,
    laws = [],
  } = data;
  const offline = isDead || isBraindead;
  return (
    <Window
      width={500}
      height={500}>
      <Window.Content scrollable>
        <Section
          title={name || "Пустая карта"}
          buttons={!!name && (
            <Button
              icon="trash"
              content={wiping ? 'СТОП' : 'Стереть'}
              disabled={isDead}
              onClick={() => act('wipe')} />
          )}>
          {!!name && (
            <LabeledList>
              <LabeledList.Item
                label="Состояние"
                color={offline ? 'bad' : 'good'}>
                {offline ? 'Оффлайн' : 'Операбельно'}
              </LabeledList.Item>
              <LabeledList.Item label="Целостность прошивки">
                <ProgressBar
                  value={health}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    good: [70, Infinity],
                    average: [50, 70],
                    bad: [-Infinity, 50],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Настройки">
                <Button
                  icon="signal"
                  content="Беспроводная активность"
                  selected={wireless}
                  onClick={() => act('wireless')} />
                <Button
                  icon="microphone"
                  content="Подпростраственное радио"
                  selected={radio}
                  onClick={() => act('radio')} />
              </LabeledList.Item>
              <LabeledList.Item label="Законы">
                {laws.map(law => (
                  <BlockQuote key={law}>
                    {law}
                  </BlockQuote>
                ))}
              </LabeledList.Item>
            </LabeledList>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
