import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const AtmosTempPump = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={335}
      height={115}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Питание">
              <Button
                icon={data.on ? 'power-off' : 'times'}
                content={data.on ? 'Вкл' : 'Выкл'}
                selected={data.on}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Скорость перекачки">
              <NumberInput
                animated
                value={parseFloat(data.rate)}
                unit="%"
                width="75px"
                minValue={0}
                maxValue={data.max_heat_transfer_rate}
                step={1}
                onChange={(e, value) => act('rate', {
                  rate: value,
                })} />
              <Button
                ml={1}
                icon="plus"
                content="Макс"
                disabled={data.rate === data.max_heat_transfer_rate}
                onClick={() => act('rate', {
                  rate: 'max',
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
