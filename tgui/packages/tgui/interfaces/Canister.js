import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Flex, Knob, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const Canister = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    portConnected,
    tankPressure,
    releasePressure,
    defaultReleasePressure,
    minReleasePressure,
    maxReleasePressure,
    valveOpen,
    isPrototype,
    hasHoldingTank,
    holdingTank,
    restricted,
  } = data;
  return (
    <Window>
      <Window.Content>
        <NoticeBox>
          Регулятор {data.hasHoldingTank ? '' : 'не'} подключен
          к баку.
        </NoticeBox>
        <Section
          title="Бак"
          buttons={(
            <Button
              icon="pencil-alt"
              content="Переименовать"
              onClick={() => act('relabel')} />
          )}>
          <Flex mx={-1}>
            <Flex.Item
              mx={1}
              align="center"
              textAlign="center">
              <Knob
                size={2}
                color={!!valveOpen && 'yellow'}
                value={releasePressure}
                unit="kPa"
                minValue={minReleasePressure}
                maxValue={maxReleasePressure}
                step={5}
                stepPixelSize={1}
                onDrag={(e, value) => act('pressure', {
                  pressure: value,
                })} />
            </Flex.Item>
            <Flex.Item
              mx={1}
              my={-0.5}
              align="center"
              textAlign="center">
              <Box my={0.5} color="label">
                Вентиль
              </Box>
              <Box my={0.5} width="60px">
                <AnimatedNumber value={releasePressure} /> кПа
              </Box>
              <Button
                my={0.5}
                color={valveOpen
                  ? (hasHoldingTank ? 'caution' : 'danger')
                  : null}
                content={valveOpen ? 'Открыт' : 'Закрыт'}
                onClick={() => act('valve')} />
            </Flex.Item>
            <Flex.Item
              mx={1}
              grow={1}
              basis={0}>
              <LabeledList>
                <LabeledList.Item label="Pressure">
                  <AnimatedNumber value={tankPressure} /> кПа
                </LabeledList.Item>
                <LabeledList.Item
                  label="Port"
                  color={portConnected ? 'good' : 'average'}>
                  {portConnected ? 'Подключен' : 'Не подключен'}
                </LabeledList.Item>
                {!!isPrototype && (
                  <LabeledList.Item label="Доступ">
                    <Button
                      icon={restricted ? 'lock' : 'unlock'}
                      color="caution"
                      content={restricted
                        ? 'Инженерный'
                        : 'Общий'}
                      onClick={() => act('restricted')} />
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Flex.Item>
          </Flex>
        </Section>
        <Section
          title="Канистра"
          buttons={!!hasHoldingTank && (
            <Button
              icon="eject"
              color={valveOpen && 'danger'}
              content="Изъять"
              onClick={() => act('eject')} />
          )}>
          {!!hasHoldingTank && (
            <LabeledList>
              <LabeledList.Item label="Метка">
                {holdingTank.name}
              </LabeledList.Item>
              <LabeledList.Item label="Давление">
                <AnimatedNumber value={holdingTank.tankPressure} /> кПа
              </LabeledList.Item>
            </LabeledList>
          )}
          {!hasHoldingTank && (
            <Box color="average">
              Внутри нет канистры
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
