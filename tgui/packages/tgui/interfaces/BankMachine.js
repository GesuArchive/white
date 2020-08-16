import { useBackend } from '../backend';
import { AnimatedNumber, Button, LabeledList, NoticeBox, Section } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const BankMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    current_balance,
    siphoning,
    station_name,
  } = data;
  return (
    <Window
      width={350}
      height={155}>
      <Window.Content>
        <NoticeBox danger>
          Только авторизованный персонал
        </NoticeBox>
        <Section title={'Банк: ' + station_name}>
          <LabeledList>
            <LabeledList.Item
              label="Текущий баланс"
              buttons={(
                <Button
                  icon={siphoning ? 'times' : 'sync'}
                  content={siphoning ? 'Остановить' : 'Качать бабки'}
                  selected={siphoning}
                  onClick={() => act(siphoning ? 'halt' : 'siphon')} />
              )}>
              <AnimatedNumber
                value={current_balance}
                format={value => formatMoney(value)} />
              {' cr'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
