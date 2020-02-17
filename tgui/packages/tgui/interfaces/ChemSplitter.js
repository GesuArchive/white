import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { LabeledList, NumberInput, Section } from '../components';

export const ChemSplitter = props => {
  const { act, data } = useBackend(props);
  const {
    straight,
    side,
    max_transfer,
  } = data;
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Прямо">
          <NumberInput
            value={straight}
            unit="е"
            width="55px"
            minValue={1}
            maxValue={max_transfer}
            format={value => toFixed(value, 2)}
            step={0.05}
            stepPixelSize={4}
            onChange={(e, value) => act('set_amount', {
              target: 'straight',
              amount: value,
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="По бокам">
          <NumberInput
            value={side}
            unit="е"
            width="55px"
            minValue={1}
            maxValue={max_transfer}
            format={value => toFixed(value, 2)}
            step={0.05}
            stepPixelSize={4}
            onChange={(e, value) => act('set_amount', {
              target: 'side',
              amount: value,
            })} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
