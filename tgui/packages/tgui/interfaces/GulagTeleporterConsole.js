import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const GulagTeleporterConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    teleporter,
    teleporter_lock,
    teleporter_state_open,
    teleporter_location,
    beacon,
    beacon_location,
    id,
    id_name,
    can_teleport,
    goal = 0,
    prisoner = {},
  } = data;
  return (
    <Window
      width={410}
      height={305}>
      <Window.Content>
        <Section
          title="Консоль телепортера"
          buttons={(
            <>
              <Button
                content={teleporter_state_open ? 'Открыто' : 'Закрыто'}
                disabled={teleporter_lock}
                selected={teleporter_state_open}
                onClick={() => act('toggle_open')} />
              <Button
                icon={teleporter_lock ? 'lock' : 'unlock'}
                content={teleporter_lock ? 'Заблокировано' : 'Разблокировано'}
                selected={teleporter_lock}
                disabled={teleporter_state_open}
                onClick={() => act('teleporter_lock')} />
            </>
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Локация телепортера"
              color={teleporter ? 'good' : 'bad'}
              buttons={!teleporter && (
                <Button
                  content="Переподключить"
                  onClick={() => act('scan_teleporter')}
                />
              )}>
              {teleporter ? teleporter_location : 'Не подключен'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Локация принимающего маячка"
              color={beacon ? 'good' : 'bad'}
              buttons={!beacon && (
                <Button
                  content="Переподключить"
                  onClick={() => act('scan_beacon')} />
              )}>
              {beacon ? beacon_location : 'Не подключен'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Детали заключённого">
          <LabeledList>
            <LabeledList.Item label="ID заключённого">
              <Button
                fluid
                content={id ? id_name : 'Нет ID'}
                onClick={() => act('handle_id')} />
            </LabeledList.Item>
            <LabeledList.Item label="Нужно накопить">
              <NumberInput
                value={goal}
                width="48px"
                minValue={1}
                maxValue={1000}
                onChange={(e, value) => act('set_goal', { value })} />
            </LabeledList.Item>
            <LabeledList.Item label="Внутри">
              {prisoner.name || 'Пусто'}
            </LabeledList.Item>
            <LabeledList.Item label="Преступный статус">
              {prisoner.crimstat || 'Нет'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Button
          fluid
          content="Начать процедуру отправки"
          disabled={!can_teleport}
          textAlign="center"
          color="bad"
          onClick={() => act('teleport')} />
      </Window.Content>
    </Window>
  );
};
