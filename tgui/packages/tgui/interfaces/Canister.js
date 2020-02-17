import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';

export const Canister = props => {
  const { act, data } = useBackend(props);
  return (
    <Fragment>
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
        <LabeledList>
          <LabeledList.Item label="Давление">
            <AnimatedNumber value={data.tankPressure} /> кПа
          </LabeledList.Item>
          <LabeledList.Item
            label="Порт"
            color={data.portConnected ? 'good' : 'average'}
            content={data.portConnected ? 'Подключен' : 'Не подключен'} />
          {!!data.isPrototype && (
            <LabeledList.Item label="Доступ">
              <Button
                icon={data.restricted ? 'lock' : 'unlock'}
                color="caution"
                content={data.restricted
                  ? 'Только для Инженеров'
                  : 'Публичный'}
                onClick={() => act('restricted')} />
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>

      <Section title="Кран">
        <LabeledList>
          <LabeledList.Item label="Выходное давление">
            <ProgressBar
              value={data.releasePressure
                / (data.maxReleasePressure - data.minReleasePressure)}>
              <AnimatedNumber value={data.releasePressure} /> kPa
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item label="Регулятор давления">
            <Button
              icon="undo"
              disabled={data.releasePressure === data.defaultReleasePressure}
              content="Сбр"
              onClick={() => act('pressure', {
                pressure: 'reset',
              })} />
            <Button
              icon="minus"
              disabled={data.releasePressure <= data.minReleasePressure}
              content="Мин"
              onClick={() => act('pressure', {
                pressure: 'min',
              })} />
            <Button
              icon="pencil-alt"
              content="Выбрать"
              onClick={() => act('pressure', {
                pressure: 'input',
              })} />
            <Button
              icon="plus"
              disabled={data.releasePressure >= data.maxReleasePressure}
              content="Макс"
              onClick={() => act('pressure', {
                pressure: 'max',
              })} />
          </LabeledList.Item>

          <LabeledList.Item label="Кран">
            <Button
              icon={data.valveOpen ? 'unlock' : 'lock'}
              color={data.valveOpen
                ? (data.hasHoldingTank ? 'caution' : 'danger')
                : null}
              content={data.valveOpen ? 'Открыт' : 'Закрыт'}
              onClick={() => act('valve')} />
          </LabeledList.Item>
        </LabeledList>
      </Section>

      <Section
        title="Канистра"
        buttons={!!data.hasHoldingTank && (
          <Button
            icon="eject"
            color={data.valveOpen && 'danger'}
            content="Изъять"
            onClick={() => act('eject')} />
        )}>
        {!!data.hasHoldingTank && (
          <LabeledList>
            <LabeledList.Item label="Метка">
              {data.holdingTank.name}
            </LabeledList.Item>
            <LabeledList.Item label="Давление">
              <AnimatedNumber value={data.holdingTank.tankPressure} /> кПа
            </LabeledList.Item>
          </LabeledList>
        )}
        {!data.hasHoldingTank && (
          <Box color="average">
            Не обнаружена канистра
          </Box>
        )}
      </Section>
    </Fragment>
  );
};
