import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';
import { PortableBasicInfo } from './common/PortableAtmos';

export const PortablePump = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    direction,
    connected,
    holding,
    targetPressure,
    defaultPressure,
    minPressure,
    maxPressure,
  } = data;
  const pump_or_port = connected ? 'Порт' : 'Помпа';
  const area_or_tank = holding ? 'Бак' : 'Зона';
  return (
    <Window width={300} height={340}>
      <Window.Content>
        <PortableBasicInfo />
        <Section
          title="Помпа"
          buttons={
            <Button
              content={
                direction
                  ? area_or_tank + ' → ' + pump_or_port
                  : pump_or_port + ' → ' + area_or_tank
              }
              color={!direction && !holding ? 'caution' : null}
              onClick={() => act('direction')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Выход">
              <NumberInput
                value={targetPressure}
                unit="кПа"
                width="75px"
                minValue={minPressure}
                maxValue={maxPressure}
                step={10}
                onChange={(e, value) =>
                  act('pressure', {
                    pressure: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Управление">
              <Button
                icon="minus"
                disabled={targetPressure === minPressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'min',
                  })
                }
              />
              <Button
                icon="sync"
                disabled={targetPressure === defaultPressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'reset',
                  })
                }
              />
              <Button
                icon="plus"
                disabled={targetPressure === maxPressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'max',
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
