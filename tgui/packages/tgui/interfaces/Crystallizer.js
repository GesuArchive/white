import { useBackend } from '../backend';
import { AnimatedNumber, Button, Flex, Input, LabeledList, ProgressBar, Section, Table, NumberInput, Box } from '../components';
import { getGasColor, getGasLabel } from '../constants';
import { toFixed } from 'common/math';
import { Window } from '../layouts';

const logScale = value => Math.log2(16 + Math.max(0, value)) - 4;

export const Crystallizer = (props, context) => {
  const { act, data } = useBackend(context);
  const selectedRecipes = data.selected_recipes || [];
  const gasTypes = data.internal_gas_data || [];
  const {
    requirements,
    internal_temperature,
    progress_bar,
    gas_input,
    selected,
  } = data;
  return (
    <Window
      width={500}
      height={600}>
      <Window.Content scrollable>
        <Section title="Управление">
          <LabeledList>
            <LabeledList.Item label="Питание">
              <Button
                icon={data.on ? 'power-off' : 'times'}
                content={data.on ? 'Вкл' : 'Выкл'}
                selected={data.on}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Рецепт">
              {selectedRecipes.map(recipe => (
                <Button
                  key={recipe.id}
                  selected={recipe.id === selected}
                  content={recipe.name}
                  onClick={() => act('recipe', {
                    mode: recipe.id,
                  })} />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Входной газ">
              <NumberInput
                animated
                value={parseFloat(data.gas_input)}
                width="63px"
                unit="моль/с"
                minValue={0}
                maxValue={500}
                onDrag={(e, value) => act('gas_input', {
                  gas_input: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Требования и прогресс">
          <LabeledList>
            <LabeledList.Item label="Прогресс">
              <ProgressBar
                value={progress_bar / 100}
                ranges={{
                  good: [0.67, 1],
                  average: [0.34, 0.66],
                  bad: [0, 0.33],
                }} />
            </LabeledList.Item>
            <LabeledList.Item label="Рецепт">
              <Box m={1} style={{
                'white-space': 'pre-wrap',
              }}>
                {requirements}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Температура">
              <ProgressBar
                value={logScale(internal_temperature)}
                minValue={0}
                maxValue={logScale(10000)}
                ranges={{
                  teal: [-Infinity, logScale(80)],
                  good: [logScale(80), logScale(600)],
                  average: [logScale(600), logScale(5000)],
                  bad: [logScale(5000), Infinity],
                }}>
                {toFixed(internal_temperature) + ' K'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Газы">
          <LabeledList>
            {gasTypes.map(gas => (
              <LabeledList.Item
                key={gas.name}
                label={getGasLabel(gas.name)}>
                <ProgressBar
                  color={getGasColor(gas.name)}
                  value={gas.amount}
                  minValue={0}
                  maxValue={1000}>
                  {toFixed(gas.amount, 2) + ' моль'}
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
