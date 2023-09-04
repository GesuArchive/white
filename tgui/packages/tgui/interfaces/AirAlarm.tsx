import { BooleanLike } from 'common/react';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Modal, NumberInput, Section, Table } from '../components';
import { Window } from '../layouts';
import { Scrubber, ScrubberProps, Vent, VentProps } from './common/AtmosControls';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type AirAlarmData = {
  locked: BooleanLike;
  siliconUser: BooleanLike;
  emagged: BooleanLike;
  dangerLevel: 0 | 1 | 2;
  atmosAlarm: BooleanLike; // fix this
  fireAlarm: BooleanLike;
  sensor: BooleanLike;
  allowLinkChange: BooleanLike;
  environment_data: {
    name: string;
    value: string; // preformatted in backend, shorter code that way.
    danger: 0 | 1 | 2;
  }[];
  tlvSettings: {
    id: string;
    name: string;
    unit: string;
    warning_min: number;
    hazard_min: number;
    warning_max: number;
    hazard_max: number;
  }[];
  vents: VentProps[];
  scrubbers: ScrubberProps[];
  selectedModePath: string;
  panicSiphonPath: string;
  filteringPath: string;
  modes: {
    name: string;
    desc: string;
    path: string;
    danger: BooleanLike;
  }[];
  thresholdTypeMap: Record<string, number>;
};

export const AirAlarm = (props, context) => {
  const { act, data } = useBackend<AirAlarmData>(context);
  const locked = data.locked && !data.siliconUser;
  return (
    <Window width={500} height={650}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox />
        <AirAlarmStatus />
        {!locked && <AirAlarmControl />}
      </Window.Content>
    </Window>
  );
};

const AirAlarmStatus = (props, context) => {
  const { data } = useBackend<AirAlarmData>(context);
  const { environment_data } = data;
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
  const localStatus = dangerMap[data.dangerLevel] || dangerMap[0];
  return (
    <Section title="Состояние атмосферы">
      <LabeledList>
        {(environment_data.length > 0 && (
          <>
            {environment_data.map((entry) => {
              const status = dangerMap[entry.danger] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={entry.name}
                  color={status.color}>
                  {entry.value}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item label="Статус" color={localStatus.color}>
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Состояние зоны"
              color={data.atmosAlarm || data.fireAlarm ? 'bad' : 'good'}>
              {(data.atmosAlarm && 'Атмосферная тревога') ||
                (data.fireAlarm && 'Пожарная тревога') ||
                'Оптимально'}
            </LabeledList.Item>
          </>
        )) || (
          <LabeledList.Item label="Опасно" color="bad">
            Нет возможности определить состав атмосферы.
          </LabeledList.Item>
        )}
        {!!data.emagged && (
          <LabeledList.Item label="Опасно" color="bad">
            Протоколы безопасности нарушены. Гарантия обнулена.
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
} as const;

type Screen = keyof typeof AIR_ALARM_ROUTES;

const AirAlarmControl = (props, context) => {
  const [screen, setScreen] = useLocalState<Screen>(context, 'screen', 'home');
  const route = AIR_ALARM_ROUTES[screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={
        screen && (
          <Button
            icon="arrow-left"
            content="Назад"
            onClick={() => setScreen('home')}
          />
        )
      }>
      <Component />
    </Section>
  );
};

//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = (props, context) => {
  const { act, data } = useBackend<AirAlarmData>(context);
  const [screen, setScreen] = useLocalState<Screen>(context, 'screen', 'home');
  const {
    selectedModePath,
    panicSiphonPath,
    filteringPath,
    atmosAlarm,
    sensor,
    allowLinkChange,
  } = data;
  const isPanicSiphoning = selectedModePath === panicSiphonPath;
  return (
    <>
      <Button
        icon={atmosAlarm ? 'exclamation-triangle' : 'exclamation'}
        color={atmosAlarm && 'caution'}
        content="Локальная тревога"
        onClick={() => act(atmosAlarm ? 'reset' : 'alarm')}
      />
      <Box mt={1} />
      <Button
        icon={isPanicSiphoning ? 'exclamation-triangle' : 'exclamation'}
        color={isPanicSiphoning && 'danger'}
        content="Паническая откачка"
        onClick={() =>
          act('mode', {
            mode: isPanicSiphoning ? filteringPath : panicSiphonPath,
          })
        }
      />
      <Box mt={2} />
      <Button
        icon="sign-out-alt"
        content="Управление вентиляцией"
        onClick={() => setScreen('vents')}
      />
      <Box mt={1} />
      <Button
        icon="filter"
        content="Управление фильтрами"
        onClick={() => setScreen('scrubbers')}
      />
      <Box mt={1} />
      <Button
        icon="cog"
        content="Режим работы"
        onClick={() => setScreen('modes')}
      />
      <Box mt={1} />
      <Button
        icon="chart-bar"
        content="Пороги тревог"
        onClick={() => setScreen('thresholds')}
      />
      {!!sensor && !!allowLinkChange && (
        <Box mt={1}>
          <Button.Confirm
            icon="link-slash"
            content="Отключить сенсоры"
            color="danger"
            onClick={() => act('disconnect_sensor')}
          />
        </Box>
      )}
    </>
  );
};

//  Vents
// --------------------------------------------------------

const AirAlarmControlVents = (props, context) => {
  const { data } = useBackend<AirAlarmData>(context);
  const { vents } = data;
  if (!vents || vents.length === 0) {
    return <span>Нечего показывать</span>;
  }
  return (
    <>
      {vents.map((vent) => (
        <Vent key={vent.refID} {...vent} />
      ))}
    </>
  );
};

//  Scrubbers
// --------------------------------------------------------

const AirAlarmControlScrubbers = (props, context) => {
  const { data } = useBackend<AirAlarmData>(context);
  const { scrubbers } = data;
  if (!scrubbers || scrubbers.length === 0) {
    return <span>Нечего показывать</span>;
  }
  return (
    <>
      {scrubbers.map((scrubber) => (
        <Scrubber key={scrubber.refID} {...scrubber} />
      ))}
    </>
  );
};

//  Modes
// --------------------------------------------------------

const AirAlarmControlModes = (props, context) => {
  const { act, data } = useBackend<AirAlarmData>(context);
  const { modes, selectedModePath } = data;
  if (!modes || modes.length === 0) {
    return <span>Нечего показывать</span>;
  }
  return (
    <>
      {modes.map((mode) => (
        <Fragment key={mode.path}>
          <Button
            icon={
              mode.path === selectedModePath ? 'check-square-o' : 'square-o'
            }
            color={
              mode.path === selectedModePath && (mode.danger ? 'red' : 'green')
            }
            content={mode.name + ' - ' + mode.desc}
            onClick={() => act('mode', { mode: mode.path })}
          />
          <Box mt={1} />
        </Fragment>
      ))}
    </>
  );
};

//  Thresholds
// --------------------------------------------------------

type EditingModalProps = {
  id: string;
  name: string;
  type: number;
  typeVar: string;
  typeName: string;
  unit: string;
  oldValue: number;
  finish: () => void;
};

const EditingModal = (props: EditingModalProps, context) => {
  const { act, data } = useBackend<AirAlarmData>(context);
  const { id, name, type, typeVar, typeName, unit, oldValue, finish } = props;
  return (
    <Modal>
      <Section
        title={'Редактор лимитов'}
        buttons={<Button onClick={() => finish()} icon="times" color="red" />}>
        <Box mb={1.5}>
          {`Редактируем ${typeName.toLowerCase()} ${name.toLowerCase()}...`}
        </Box>
        {oldValue === -1 ? (
          <Button
            onClick={() =>
              act('set_threshold', {
                threshold: id,
                threshold_type: type,
                value: 0,
              })
            }>
            {'Включить'}
          </Button>
        ) : (
          <>
            <NumberInput
              onChange={(e, value) =>
                act('set_threshold', {
                  threshold: id,
                  threshold_type: type,
                  value: value,
                })
              }
              unit={unit}
              value={oldValue}
              minValue={0}
              maxValue={100000}
              step={10}
            />
            <Button
              onClick={() =>
                act('set_threshold', {
                  threshold: id,
                  threshold_type: type,
                  value: -1,
                })
              }>
              {'Отключить'}
            </Button>
          </>
        )}
      </Section>
    </Modal>
  );
};

const AirAlarmControlThresholds = (props, context) => {
  const { act, data } = useBackend<AirAlarmData>(context);
  const [activeModal, setActiveModal] = useLocalState<Omit<
    EditingModalProps,
    'oldValue'
  > | null>(context, 'tlvModal', null);
  const { tlvSettings, thresholdTypeMap } = data;
  return (
    <>
      <Table>
        <Table.Row>
          <Table.Cell bold>Лимиты</Table.Cell>
          <Table.Cell bold color="bad">
            Крайне низкое
          </Table.Cell>
          <Table.Cell bold color="average">
            Низкое
          </Table.Cell>
          <Table.Cell bold color="average">
            Высокое
          </Table.Cell>
          <Table.Cell bold color="bad">
            Крайне высокое
          </Table.Cell>
          <Table.Cell bold>Действия</Table.Cell>
        </Table.Row>
        {tlvSettings.map((tlv) => (
          <Table.Row key={tlv.name}>
            <Table.Cell>{tlv.name}</Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['hazard_min'],
                    typeVar: 'hazard_min',
                    typeName: 'Минимально опасно',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }>
                {tlv.hazard_min === -1
                  ? 'Отключено'
                  : tlv.hazard_min + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['warning_min'],
                    typeVar: 'warning_min',
                    typeName: 'Минимально',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }>
                {tlv.warning_min === -1
                  ? 'Отключено'
                  : tlv.warning_min + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['warning_max'],
                    typeVar: 'warning_max',
                    typeName: 'Максимально',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }>
                {tlv.warning_max === -1
                  ? 'Отключено'
                  : tlv.warning_max + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <Button
                fluid
                onClick={() =>
                  setActiveModal({
                    id: tlv.id,
                    name: tlv.name,
                    type: thresholdTypeMap['hazard_max'],
                    typeVar: 'hazard_max',
                    typeName: 'Максимально опасно',
                    unit: tlv.unit,
                    finish: () => setActiveModal(null),
                  })
                }>
                {tlv.hazard_max === -1
                  ? 'Отключено'
                  : tlv.hazard_max + ' ' + tlv.unit}
              </Button>
            </Table.Cell>
            <Table.Cell>
              <>
                <Button
                  color="green"
                  icon="sync"
                  onClick={() =>
                    act('reset_threshold', {
                      threshold: tlv.id,
                      threshold_type: thresholdTypeMap['all'],
                    })
                  }
                />
                <Button
                  color="red"
                  icon="times"
                  onClick={() =>
                    act('set_threshold', {
                      threshold: tlv.id,
                      threshold_type: thresholdTypeMap['all'],
                      value: -1,
                    })
                  }
                />
              </>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
      {activeModal && (
        <EditingModal
          oldValue={
            (tlvSettings.find((tlv) => tlv.id === activeModal.id) || {})[
              activeModal.typeVar
            ]
          }
          {...activeModal}
        />
      )}
    </>
  );
};
