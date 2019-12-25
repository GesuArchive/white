import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { getGasLabel } from '../constants';

export const AtmosFilter = props => {
  const { act, data } = useBackend(props);
  const filterTypes = data.filter_types || [];
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Питание">
          <Button
            icon={data.on ? 'power-off' : 'times'}
            content={data.on ? 'Вкл' : 'Выкл'}
            selected={data.on}
            onClick={() => act('power')} />
        </LabeledList.Item>
        <LabeledList.Item label="Скорость передачи">
          <NumberInput
            animated
            value={parseFloat(data.rate)}
            width="63px"
            unit="Л/с"
            minValue={0}
            maxValue={200}
            onDrag={(e, value) => act('rate', {
              rate: value,
            })} />
          <Button
            ml={1}
            icon="plus"
            content="Максимум"
            disabled={data.rate === data.max_rate}
            onClick={() => act('rate', {
              rate: 'max',
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Фильтры">
          {filterTypes.map(filter => (
            <Button
              key={filter.id}
              selected={filter.selected}
              content={getGasLabel(filter.id, filter.name)}
              onClick={() => act('filter', {
                mode: filter.id,
              })} />
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
