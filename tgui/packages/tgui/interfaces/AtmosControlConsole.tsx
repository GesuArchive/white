import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, NumberInput, Dropdown, Section, Stack } from '../components';
import { Window } from '../layouts';
import { AtmosHandbookContent, atmosHandbookHooks } from './common/AtmosHandbook';
import { Gasmix, GasmixParser } from './common/GasmixParser';

type Chamber = {
  id: string;
  name: string;
  gasmix?: Gasmix;
  input_info?: { active: boolean; amount: number };
  output_info?: { active: boolean; amount: number };
};

export const AtmosControlConsole = (props, context) => {
  const { act, data } = useBackend<{
    chambers: Chamber[];
    maxInput: number;
    maxOutput: number;
    reconnecting: boolean;
    control: boolean;
  }>(context);
  const chambers = data.chambers || [];
  const [chamberId, setChamberId] = useLocalState(
    context,
    'chamberId',
    chambers[0]?.id
  );
  const selectedChamber =
    chambers.length === 1
      ? chambers[0]
      : chambers.find((chamber) => chamber.id === chamberId);
  const [setActiveGasId, setActiveReactionId] = atmosHandbookHooks(context);
  return (
    <Window width={550} height={350}>
      <Window.Content scrollable>
        {chambers.length > 1 && (
          <Section title="Камера">
            <Dropdown
              width="100%"
              options={chambers.map((chamber) => chamber.name)}
              selected={selectedChamber?.name}
              onSelected={(value) =>
                setChamberId(
                  chambers.find((chamber) => chamber.name === value)?.id ||
                    chambers[0].id
                )
              }
            />
          </Section>
        )}
        <Section
          title={selectedChamber ? selectedChamber.name : 'Состояние камеры'}
          buttons={
            !!data.reconnecting && (
              <Button
                icon="undo"
                content="Переподключиться"
                onClick={() => act('reconnect')}
              />
            )
          }>
          {!!selectedChamber && !!selectedChamber.gasmix ? (
            <GasmixParser
              gasmix={selectedChamber.gasmix}
              gasesOnClick={setActiveGasId}
              reactionOnClick={setActiveReactionId}
            />
          ) : (
            <Box italic> {'Нет сенсоров!'}</Box>
          )}
        </Section>
        {!!selectedChamber && !!data.control && (
          <Section title="Управление камерой">
            <Stack>
              <Stack.Item grow>
                {selectedChamber.input_info ? (
                  <LabeledList>
                    <LabeledList.Item label="Ввод">
                      <Button
                        icon={
                          selectedChamber.input_info.active
                            ? 'power-off'
                            : 'times'
                        }
                        content={
                          selectedChamber.input_info.active
                            ? 'Вкачивание'
                            : 'Выключено'
                        }
                        selected={selectedChamber.input_info.active}
                        onClick={() =>
                          act('toggle_input', {
                            chamber: selectedChamber.id,
                          })
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Скорость ввода">
                      <NumberInput
                        value={Number(selectedChamber.input_info.amount)}
                        unit="Л/с"
                        width="63px"
                        minValue={0}
                        maxValue={data.maxInput}
                        // This takes an exceptionally long time to update
                        // due to being an async signal
                        suppressFlicker={2000}
                        onChange={(e, value) =>
                          act('adjust_input', {
                            chamber: selectedChamber.id,
                            rate: value,
                          })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                ) : (
                  <Box italic> {'Не обнаружено устройство ввода!'}</Box>
                )}
              </Stack.Item>
              <Stack.Item grow>
                {selectedChamber.output_info ? (
                  <LabeledList>
                    <LabeledList.Item label="Вывод">
                      <Button
                        icon={
                          selectedChamber.output_info.active
                            ? 'power-off'
                            : 'times'
                        }
                        content={
                          selectedChamber.output_info.active ? 'Открыто' : 'Закрыто'
                        }
                        selected={selectedChamber.output_info.active}
                        onClick={() =>
                          act('toggle_output', {
                            chamber: selectedChamber.id,
                          })
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Выводное давление">
                      <NumberInput
                        value={Number(selectedChamber.output_info.amount)}
                        unit="кПа"
                        width="75px"
                        minValue={0}
                        maxValue={data.maxOutput}
                        step={10}
                        // This takes an exceptionally long time to update
                        // due to being an async signal
                        suppressFlicker={2000}
                        onChange={(e, value) =>
                          act('adjust_output', {
                            chamber: selectedChamber.id,
                            rate: value,
                          })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                ) : (
                  <Box italic> {'Не обнаружено устройство вывода!'} </Box>
                )}
              </Stack.Item>
            </Stack>
          </Section>
        )}
        <AtmosHandbookContent />
      </Window.Content>
    </Window>
  );
};
