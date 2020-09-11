import { useBackend } from '../backend';
import { Box, Button, ProgressBar, Section, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const NtnetRelay = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    enabled,
    dos_capacity,
    dos_overload,
    dos_crashed,
  } = data;
  return (
    <Window
      title="Квантовое реле NtNet"
      width={400}
      height={300}>
      <Window.Content>
        <Section
          title="Сетевой буффер"
          buttons={(
            <Button
              icon="power-off"
              selected={enabled}
              content={enabled ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
              onClick={() => act('toggle')}
            />
          )}>
          {!dos_crashed ? (
            <ProgressBar
              value={dos_overload}
              minValue={0}
              maxValue={dos_capacity}>
              <AnimatedNumber value={dos_overload} /> GQ
              {' / '}
              {dos_capacity} GQ
            </ProgressBar>
          ) : (
            <Box fontFamily="monospace">
              <Box fontSize="20px">
                ПЕРЕПОЛНЕНИЕ СЕТЕВОГО БУФЕРА
              </Box>
              <Box fontSize="16px">
                РЕЖИМ ВОССТАНОВЛЕНИЯ ПЕРЕГРУЗКИ
              </Box>
              <Box>
                Эта система временно отключена из-за переполнения
                буферов трафика. Пока буферизованный трафик не будет обработан,
                все дальнейшие запросы будут отброшены. Частые случаи этой
                ошибки может указывать на недостаточную мощность оборудования
                вашей сети. Пожалуйста, свяжитесь с вашим сетевым планировщиком
                для получения инструкций о том, как решить эту проблему.
              </Box>
              <Box fontSize="20px" color="bad">
                ПРЕРЫВАНИЕ АДМИНИСТРАТОРА
              </Box>
              <Box fontSize="16px" color="bad">
                ВНИМАНИЕ - МОЖЕТ ПРИВЕСТИ К ПОТЕРИ ДАННЫХ
              </Box>
              <Button
                icon="signal"
                content="ОЧИСТИТЬ БУФФЕР"
                mt={1}
                color="bad"
                onClick={() => act('restart')} />
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
