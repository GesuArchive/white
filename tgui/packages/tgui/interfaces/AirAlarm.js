import { toFixed } from 'common/math';
import { decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { getGasLabel } from '../constants';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const AirAlarm = props => {
  const { state } = props;
  const { act, data } = useBackend(props);
  const locked = data.locked && !data.siliconUser;
  return (
    <Fragment>
      <InterfaceLockNoticeBox
        siliconUser={data.siliconUser}
        locked={data.locked}
        onLockStatusChange={() => act('lock')} />
      <AirAlarmStatus state={state} />
      {!locked && (
        <AirAlarmControl state={state} />
      )}
    </Fragment>
  );
};

const AirAlarmStatus = props => {
  const { data } = useBackend(props);
  const entries = (data.environment_data || [])
    .filter(entry => entry.value >= 0.01);
  const dangerMap = {
    0: {
      color: 'good',
      localStatusText: 'Оптимально',
    },
    1: {
      color: 'average',
      localStatusText: 'Нестабильно',
    },
    2: {
      color: 'bad',
      localStatusText: 'Опасно (Требуется Диагностика)',
    },
  };
  const localStatus = dangerMap[data.danger_level] || dangerMap[0];
  return (
    <Section title="Состояние атмосферы">
      <LabeledList>
        {entries.length > 0 && (
          <Fragment>
            {entries.map(entry => {
              const status = dangerMap[entry.danger_level] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={entry.name}
                  color={status.color}>
                  {toFixed(entry.value, 2)}{entry.unit}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item
              label="Местный статус"
              color={localStatus.color}>
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Состояние зоны"
              color={data.atmos_alarm || data.fire_alarm ? 'bad' : 'good'}>
              {data.atmos_alarm && 'Атмосферная тревога'
                || data.fire_alarm && 'Пожарная тревога'
                || 'Номинально'}
            </LabeledList.Item>
          </Fragment>
        ) || (
          <LabeledList.Item
            label="Внимание"
            color="bad">
            Cannot obtain air sample for analysis.
          </LabeledList.Item>
        )}
        {!!data.emagged && (
          <LabeledList.Item
            label="Внимание"
            color="bad">
            Safety measures offline. Device may exhibit abnormal behavior.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const AIR_ALARM_ROUTES = {
  home: {
    title: 'Контроль атмосферы',
    component: () => AirAlarmControlHome,
  },
  vents: {
    title: 'Управление вентиляцией',
    component: () => AirAlarmControlVents,
  },
  scrubbers: {
    title: 'Управление фильтрами',
    component: () => AirAlarmControlScrubbers,
  },
  modes: {
    title: 'Режим работы',
    component: () => AirAlarmControlModes,
  },
  thresholds: {
    title: 'Пороги тревог',
    component: () => AirAlarmControlThresholds,
  },
};

const AirAlarmControl = props => {
  const { state } = props;
  const { act, config } = useBackend(props);
  const route = AIR_ALARM_ROUTES[config.screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={config.screen !== 'home' && (
        <Button
          icon="arrow-left"
          content="Назад"
          onClick={() => act('tgui:view', {
            screen: 'home',
          })} />
      )}>
      <Component state={state} />
    </Section>
  );
};


//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = props => {
  const { act, data } = useBackend(props);
  const {
    mode,
    atmos_alarm,
  } = data;
  return (
    <Fragment>
      <Button
        icon={atmos_alarm
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={atmos_alarm && 'caution'}
        content="Атмосферная тревога"
        onClick={() => act(atmos_alarm ? 'reset' : 'alarm')} />
      <Box mt={1} />
      <Button
        icon={mode === 3
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={mode === 3 && 'danger'}
        content="Паническая откачка"
        onClick={() => act('mode', {
          mode: mode === 3 ? 1 : 3,
        })} />
      <Box mt={2} />
      <Button
        icon="sign-out-alt"
        content="Управление вентиляцией"
        onClick={() => act('tgui:view', {
          screen: 'vents',
        })} />
      <Box mt={1} />
      <Button
        icon="filter"
        content="Управление фильтрами"
        onClick={() => act('tgui:view', {
          screen: 'scrubbers',
        })} />
      <Box mt={1} />
      <Button
        icon="cog"
        content="Режим работы"
        onClick={() => act('tgui:view', {
          screen: 'modes',
        })} />
      <Box mt={1} />
      <Button
        icon="chart-bar"
        content="Пороги тревог"
        onClick={() => act('tgui:view', {
          screen: 'thresholds',
        })} />
    </Fragment>
  );
};


//  Vents
// --------------------------------------------------------

const AirAlarmControlVents = props => {
  const { state } = props;
  const { data } = useBackend(props);
  const { vents } = data;
  if (!vents || vents.length === 0) {
    return 'Нечего показывать';
  }
  return vents.map(vent => (
    <Vent key={vent.id_tag}
      state={state}
      {...vent} />
  ));
};

const Vent = props => {
  const {
    id_tag,
    long_name,
    power,
    checks,
    excheck,
    incheck,
    direction,
    external,
    internal,
    extdefault,
    intdefault,
  } = props;
  const { act } = useBackend(props);
  return (
    <Section
      level={2}
      title={decodeHtmlEntities(long_name)}
      buttons={(
        <Button
          icon={power ? 'power-off' : 'times'}
          selected={power}
          content={power ? 'ВКЛ' : 'ВЫКЛ'}
          onClick={() => act('power', {
            id_tag,
            val: Number(!power),
          })} />
      )}>
      <LabeledList>
        <LabeledList.Item label="Режим">
          {direction === 'release' ? 'Герметизация' : 'Высвобождение'}
        </LabeledList.Item>
        <LabeledList.Item label="Регулятор давления">
          <Button
            icon="sign-in-alt"
            content="Внутренний"
            selected={incheck}
            onClick={() => act('incheck', {
              id_tag,
              val: checks,
            })} />
          <Button
            icon="sign-out-alt"
            content="Внешний"
            selected={excheck}
            onClick={() => act('excheck', {
              id_tag,
              val: checks,
            })} />
        </LabeledList.Item>
        {!!incheck && (
          <LabeledList.Item label="Внутреннее целевое">
            <NumberInput
              value={Math.round(internal)}
              unit="кПа"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) => act('set_internal_pressure', {
                id_tag,
                value,
              })} />
            <Button
              icon="undo"
              disabled={intdefault}
              content="Сбросить"
              onClick={() => act('reset_internal_pressure', {
                id_tag,
              })} />
          </LabeledList.Item>
        )}
        {!!excheck && (
          <LabeledList.Item label="Внешнее целевое">
            <NumberInput
              value={Math.round(external)}
              unit="кПа"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) => act('set_external_pressure', {
                id_tag,
                value,
              })} />
            <Button
              icon="undo"
              disabled={extdefault}
              content="Сбросить"
              onClick={() => act('reset_external_pressure', {
                id_tag,
              })} />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};


//  Scrubbers
// --------------------------------------------------------

const AirAlarmControlScrubbers = props => {
  const { state } = props;
  const { data } = useBackend(props);
  const { scrubbers } = data;
  if (!scrubbers || scrubbers.length === 0) {
    return 'Нечего показывать';
  }
  return scrubbers.map(scrubber => (
    <Scrubber
      key={scrubber.id_tag}
      state={state}
      {...scrubber} />
  ));
};

const Scrubber = props => {
  const {
    long_name,
    power,
    scrubbing,
    id_tag,
    widenet,
    filter_types,
  } = props;
  const { act } = useBackend(props);
  return (
    <Section
      level={2}
      title={decodeHtmlEntities(long_name)}
      buttons={(
        <Button
          icon={power ? 'power-off' : 'times'}
          content={power ? 'ВКЛ' : 'ВЫКЛ'}
          selected={power}
          onClick={() => act('power', {
            id_tag,
            val: Number(!power),
          })} />
      )}>
      <LabeledList>
        <LabeledList.Item label="Режим">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            content={scrubbing ? 'Чистка' : 'Выкачивание'}
            onClick={() => act('scrubbing', {
              id_tag,
              val: Number(!scrubbing),
            })} />
          <Button
            icon={widenet ? 'expand' : 'compress'}
            selected={widenet}
            content={widenet ? 'Расширенный радиус' : 'Обычный радиус'}
            onClick={() => act('widenet', {
              id_tag,
              val: Number(!widenet),
            })} />
        </LabeledList.Item>
        <LabeledList.Item label="Фильтры">
          {scrubbing
            && filter_types.map(filter => (
              <Button key={filter.gas_id}
                icon={filter.enabled ? 'check-square-o' : 'square-o'}
                content={getGasLabel(filter.gas_id, filter.gas_name)}
                title={filter.gas_name}
                selected={filter.enabled}
                onClick={() => act('toggle_filter', {
                  id_tag,
                  val: filter.gas_id,
                })} />
            ))
            || 'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};


//  Modes
// --------------------------------------------------------

const AirAlarmControlModes = props => {
  const { act, data } = useBackend(props);
  const { modes } = data;
  if (!modes || modes.length === 0) {
    return 'Нечего показывать';
  }
  return modes.map(mode => (
    <Fragment key={mode.mode}>
      <Button
        icon={mode.selected ? 'check-square-o' : 'square-o'}
        selected={mode.selected}
        color={mode.selected && mode.danger && 'danger'}
        content={mode.name}
        onClick={() => act('mode', { mode: mode.mode })} />
      <Box mt={1} />
    </Fragment>
  ));
};


//  Thresholds
// --------------------------------------------------------

const AirAlarmControlThresholds = props => {
  const { act, data } = useBackend(props);
  const { thresholds } = data;
  return (
    <table
      className="LabeledList"
      style={{ width: '100%' }}>
      <thead>
        <tr>
          <td />
          <td className="color-bad">мин2</td>
          <td className="color-average">мин1</td>
          <td className="color-average">макс1</td>
          <td className="color-bad">макс2</td>
        </tr>
      </thead>
      <tbody>
        {thresholds.map(threshold => (
          <tr key={threshold.name}>
            <td className="LabeledList__label">{threshold.name}</td>
            {threshold.settings.map(setting => (
              <td key={setting.val}>
                <Button
                  content={toFixed(setting.selected, 2)}
                  onClick={() => act('threshold', {
                    env: setting.env,
                    var: setting.val,
                  })} />
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
};
