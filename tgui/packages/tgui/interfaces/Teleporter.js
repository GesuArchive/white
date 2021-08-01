import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Teleporter = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    calibrated,
    calibrating,
    power_station,
    regime_set,
    teleporter_hub,
    target,
  } = data;
  return (
    <Window
      width={360}
      height={138}>
      <Window.Content>
        <Section>
          {!power_station && (
            <Box color="bad" textAlign="center">
              Не подключена энергостанция.
            </Box>
          ) || (!teleporter_hub && (
            <Box color="bad" textAlign="center">
              Не подключен хаб.
            </Box>
          )) || (
            <LabeledList>
              <LabeledList.Item label="Режим">
                <Button
                  content={regime_set}
                  onClick={() => act('regimeset')} />
              </LabeledList.Item>
              <LabeledList.Item label="Цель">
                <Button
                  icon="edit"
                  content={target}
                  onClick={() => act('settarget')} />
              </LabeledList.Item>
              <LabeledList.Item label="Калибровка"
                buttons={(
                  <Button
                    icon="tools"
                    content="Калибровать"
                    onClick={() => act('calibrate')} />
                )}>
                {calibrating && (
                  <Box color="average">
                    В процессе
                  </Box>
                ) || (calibrated && (
                  <Box color="good">
                    Оптимальная
                  </Box>
                ) || (
                  <Box color="bad">
                    Почти оптимальная
                  </Box>
                ))}
              </LabeledList.Item>
            </LabeledList>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
