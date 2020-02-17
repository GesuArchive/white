import { useBackend } from '../backend';
import { Fragment } from 'inferno';
import { Box, Section, LabeledList, Button, AnimatedNumber, NumberInput } from '../components';
import { getGasLabel } from '../constants';

export const PortableBasicInfo = props => {
  const { act, data } = useBackend(props);

  const {
    connected,
    holding,
    on,
    pressure,
  } = data;

  return (
    <Fragment>
      <Section
        title="Состояние"
        buttons={(
          <Button
            icon={on ? 'power-off' : 'times'}
            content={on ? 'Вкл' : 'Выкл'}
            selected={on}
            onClick={() => act('power')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Давление">
            <AnimatedNumber value={pressure} />
            {' кПа'}
          </LabeledList.Item>
          <LabeledList.Item
            label="Порт"
            color={connected ? 'good' : 'average'}>
            {connected ? 'Подключено' : 'Не подключено'}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Канистра"
        minHeight="82px"
        buttons={(
          <Button
            icon="eject"
            content="Изъять"
            disabled={!holding}
            onClick={() => act('eject')} />
        )}>
        {holding ? (
          <LabeledList>
            <LabeledList.Item label="Метка">
              {holding.name}
            </LabeledList.Item>
            <LabeledList.Item label="Давление">
              <AnimatedNumber
                value={holding.pressure} />
              {' кПа'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="average">
            Не обнаружено канистры
          </Box>
        )}
      </Section>
    </Fragment>
  );
};

export const PortablePump = props => {
  const { act, data } = useBackend(props);

  const {
    direction,
    holding,
    target_pressure,
    default_pressure,
    min_pressure,
    max_pressure,
  } = data;

  return (
    <Fragment>
      <PortableBasicInfo state={props.state} />
      <Section
        title="Помпа"
        buttons={(
          <Button
            icon={direction ? 'sign-in-alt' : 'sign-out-alt'}
            content={direction ? 'Вход' : 'Выход'}
            selected={direction}
            onClick={() => act('direction')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Выход">
            <NumberInput
              value={target_pressure}
              unit="кПа"
              width="75px"
              minValue={min_pressure}
              maxValue={max_pressure}
              step={10}
              onChange={(e, value) => act('pressure', {
                pressure: value,
              })} />
          </LabeledList.Item>
          <LabeledList.Item label="Шаблон">
            <Button
              icon="minus"
              disabled={target_pressure === min_pressure}
              onClick={() => act('pressure', {
                pressure: 'min',
              })} />
            <Button
              icon="sync"
              disabled={target_pressure === default_pressure}
              onClick={() => act('pressure', {
                pressure: 'reset',
              })} />
            <Button
              icon="plus"
              disabled={target_pressure === max_pressure}
              onClick={() => act('pressure', {
                pressure: 'max',
              })} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};

export const PortableScrubber = props => {
  const { act, data } = useBackend(props);

  const filter_types = data.filter_types || [];

  return (
    <Fragment>
      <PortableBasicInfo state={props.state} />
      <Section title="Фильтры">
        {filter_types.map(filter => (
          <Button
            key={filter.id}
            icon={filter.enabled ? 'check-square-o' : 'square-o'}
            content={getGasLabel(filter.gas_id, filter.gas_name)}
            selected={filter.enabled}
            onClick={() => act('toggle_filter', {
              val: filter.gas_id,
            })} />
        ))}
      </Section>
    </Fragment>
  );
};
