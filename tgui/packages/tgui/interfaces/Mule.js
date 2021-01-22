import { useBackend } from '../backend';
import { Button, Dropdown, Flex, Input, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Mule = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    on,
    cell,
    cellPercent,
    load,
    mode,
    modeStatus,
    haspai,
    autoReturn,
    autoPickup,
    reportDelivery,
    destination,
    home,
    id,
    destinations = [],
  } = data;
  const locked = data.locked && !data.siliconUser;
  return (
    <Window
      width={350}
      height={455}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section
          title="Состояние"
          minHeight="110px"
          buttons={!locked && (
            <Button
              icon={on ? 'power-off' : 'times'}
              content={on ? 'Включен' : 'Выключен'}
              selected={on}
              onClick={() => act('power')} />
          )}>
          <ProgressBar
            value={cell ? (cellPercent / 100) : 0}
            color={cell ? 'good' : 'bad'} />
          <Flex mt={1}>
            <Flex.Item grow={1} basis={0}>
              <LabeledList>
                <LabeledList.Item label="Режим" color={modeStatus}>
                  {mode}
                </LabeledList.Item>
              </LabeledList>
            </Flex.Item>
            <Flex.Item grow={1} basis={0}>
              <LabeledList>
                <LabeledList.Item
                  label="Груз"
                  color={load ? 'good' : 'average'}>
                  {load || 'Отсутствует'}
                </LabeledList.Item>
              </LabeledList>
            </Flex.Item>
          </Flex>
        </Section>
        {!locked && (
          <Section
            title="Управление"
            buttons={(
              <>
                {!!load && (
                  <Button
                    icon="eject"
                    content="Разгрузить"
                    onClick={() => act('unload')} />
                )}
                {!!haspai && (
                  <Button
                    icon="eject"
                    content="Изъять пИИ"
                    onClick={() => act('ejectpai')} />
                )}
              </>
            )}>
            <LabeledList>
              <LabeledList.Item label="ID">
                <Input
                  value={id}
                  onChange={(e, value) => act('setid', { value })} />
              </LabeledList.Item>
              <LabeledList.Item label="Цель">
                <Dropdown
                  over
                  selected={destination || 'Нет'}
                  options={destinations}
                  width="150px"
                  onSelected={value => act('destination', { value })} />
                <Button
                  icon="stop"
                  content="Стоп"
                  onClick={() => act('stop')} />
                <Button
                  icon="play"
                  content="Старт"
                  onClick={() => act('go')} />
              </LabeledList.Item>
              <LabeledList.Item label="Дом">
                <Dropdown
                  over
                  selected={home}
                  options={destinations}
                  width="150px"
                  onSelected={value => act('destination', { value })} />
                <Button
                  icon="home"
                  content="Вернуть домой"
                  onClick={() => act('home')} />
              </LabeledList.Item>
              <LabeledList.Item label="Settings">
                <Button.Checkbox
                  checked={autoReturn}
                  content="Авто-возвращение"
                  onClick={() => act('autored')} />
                <br />
                <Button.Checkbox
                  checked={autoPickup}
                  content="Авто-подбор"
                  onClick={() => act('autopick')} />
                <br />
                <Button.Checkbox
                  checked={reportDelivery}
                  content="Сообщать о доставке"
                  onClick={() => act('report')} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
