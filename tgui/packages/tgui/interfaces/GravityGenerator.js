import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';

export const GravityGenerator = props => {
  const { act, data } = useBackend(props);
  const {
    breaker,
    charge_count,
    charging_state,
    on,
    operational,
  } = data;
  return (
    <Fragment>
      <Section>
        {!operational && (
          <NoticeBox textAlign="center">
            No data available
          </NoticeBox>
        ) || (
          <LabeledList>
            <LabeledList.Item label="Рубильник">
              <Button
                icon={breaker ? 'power-off' : 'times'}
                content={breaker ? 'Вкл' : 'Выкл'}
                selected={breaker}
                disabled={!operational}
                onClick={() => act('gentoggle')} />
            </LabeledList.Item>
            <LabeledList.Item label="Гравитация">
              <ProgressBar
                value={charge_count / 100}
                ranges={{
                  good: [0.7, Infinity],
                  average: [0.3, 0.7],
                  bad: [-Infinity, 0.3],
                }} />
            </LabeledList.Item>
            <LabeledList.Item label="Заряд">
              {charging_state === 0 && (
                on && (
                  <Box color="good">
                    Полностью заряжено
                  </Box>
                ) || (
                  <Box color="bad">
                    Не заряжается
                  </Box>
                ))}
              {charging_state === 1 && (
                <Box color="average">
                  Заряжается
                </Box>
              )}
              {charging_state === 2 && (
                <Box color="average">
                Разряжается
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        )}
      </Section>
      {operational && charging_state !== 0 && (
        <NoticeBox textAlign="center">
          ВНИМАНИЕ - замечена радиация
        </NoticeBox>
      )}
      {operational && charging_state === 0 && (
        <NoticeBox textAlign="center">
          Радиации не обнаружено
        </NoticeBox>
      )}
    </Fragment>
  );
};
