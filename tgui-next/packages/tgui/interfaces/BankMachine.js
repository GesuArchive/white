import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';

export const BankMachine = props => {
  const { act, data } = useBackend(props);
  const {
    current_balance,
    siphoning,
    station_name,
  } = data;
  return (
    <Fragment>
      <Section title={'Банк: ' + station_name}>
        <LabeledList>
          <LabeledList.Item label="Текущий баланс"
            buttons={(
              <Button
                icon={siphoning ? 'times' : 'sync'}
                content={siphoning ? 'Остановить' : 'Качать бабки'}
                selected={siphoning}
                onClick={() => act(siphoning ? 'halt' : 'siphon')} />
            )}>
            {current_balance + ' cr'}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <NoticeBox textAlign="center">
        Только авторизованный персонал
      </NoticeBox>
    </Fragment>
  );
};
