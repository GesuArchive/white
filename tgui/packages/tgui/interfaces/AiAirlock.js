import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const dangerMap = {
  2: {
    color: 'good',
    localStatusText: 'Выключено',
  },
  1: {
    color: 'average',
    localStatusText: 'Опасно',
  },
  0: {
    color: 'bad',
    localStatusText: 'Оптимально',
  },
};

export const AiAirlock = (props, context) => {
  const { act, data } = useBackend(context);
  const ourWires = data.wires;
  const ourPower = data.power;
  const statusMain = dangerMap[ourPower.main] || dangerMap[0];
  const statusBackup = dangerMap[ourPower.backup] || dangerMap[0];
  const statusElectrify = dangerMap[data.shock] || dangerMap[0];
  return (
    <Window
      width={500}
      height={425}>
      <Window.Content>
        <Section title="Состояние питания">
          <LabeledList>
            <LabeledList.Item
              label="Основное"
              color={statusMain.color}
              buttons={(
                <Button
                  icon="lightbulb-o"
                  disabled={!ourPower.main}
                  content="Нарушить"
                  onClick={() => act('disrupt-main')} />
              )}>
              {ourPower.main ? 'В сети' : 'Отключено'}
              {' '}
              {(!ourWires.main_1 || !ourWires.main_2)
                && '[Провода обрезаны!]'
                || (ourPower.main_timeleft > 0
                  && `[${ourPower.main_timeleft}с]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Запасное"
              color={statusBackup.color}
              buttons={(
                <Button
                  icon="lightbulb-o"
                  disabled={!ourPower.backup}
                  content="Нарушить"
                  onClick={() => act('disrupt-backup')} />
              )}>
              {ourPower.backup ? 'В сети' : 'Отключено'}
              {' '}
              {(!ourWires.backup_1 || !ourWires.backup_2)
                && '[Провода обрезаны!]'
                || (ourPower.backup_timeleft > 0
                  && `[${ourPower.backup_timeleft}с]`)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Шокер"
              color={statusElectrify.color}
              buttons={(
                <>
                  <Button
                    icon="wrench"
                    disabled={!(ourWires.shock && data.shock === 0)}
                    content="Восстановить"
                    onClick={() => act('shock-restore')} />
                  <Button
                    icon="bolt"
                    disabled={!ourWires.shock}
                    content="Временно"
                    onClick={() => act('shock-temp')} />
                  <Button
                    icon="bolt"
                    disabled={!ourWires.shock}
                    content="Всегда"
                    onClick={() => act('shock-perm')} />
                </>
              )}>
              {data.shock === 2 ? 'Безопасно' : 'Напряжение'}
              {' '}
              {!ourWires.shock
                && '[Провода обрезаны!]'
                || (data.shock_timeleft > 0
                  && `[${data.shock_timeleft}s]`)
                || (data.shock_timeleft === -1
                  && '[Всегда]')}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Управление шлюзом и доступ">
          <LabeledList>
            <LabeledList.Item
              label="Сканирование ID"
              color="bad"
              buttons={(
                <Button
                  icon={data.id_scanner ? 'power-off' : 'times'}
                  content={data.id_scanner ? 'Включено' : 'Отключено'}
                  selected={data.id_scanner}
                  disabled={!ourWires.id_scanner}
                  onClick={() => act('idscan-toggle')} />
              )}>
              {!ourWires.id_scanner && '[Провода обрезаны!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Аварийный доступ"
              buttons={(
                <Button
                  icon={data.emergency ? 'power-off' : 'times'}
                  content={data.emergency ? 'Включено' : 'Отключено'}
                  selected={data.emergency}
                  onClick={() => act('emergency-toggle')} />
              )} />
            <LabeledList.Divider />
            <LabeledList.Item
              label="Болты шлюза"
              color="bad"
              buttons={(
                <Button
                  icon={data.locked ? 'lock' : 'unlock'}
                  content={data.locked ? 'Опущены' : 'Подняты'}
                  selected={data.locked}
                  disabled={!ourWires.bolts}
                  onClick={() => act('bolt-toggle')} />
              )}>
              {!ourWires.bolts && '[Провода обрезаны!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Индикация состояния болтов"
              color="bad"
              buttons={(
                <Button
                  icon={data.lights ? 'power-off' : 'times'}
                  content={data.lights ? 'Включено' : 'Отключено'}
                  selected={data.lights}
                  disabled={!ourWires.lights}
                  onClick={() => act('light-toggle')} />
              )}>
              {!ourWires.lights && '[Провода обрезаны!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Сенсоры принудительного закрытия"
              color="bad"
              buttons={(
                <Button
                  icon={data.safe ? 'power-off' : 'times'}
                  content={data.safe ? 'Включены' : 'Отключены'}
                  selected={data.safe}
                  disabled={!ourWires.safe}
                  onClick={() => act('safe-toggle')} />
              )}>
              {!ourWires.safe && '[Провода обрезаны!]'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Таймер шлюза"
              color="bad"
              buttons={(
                <Button
                  icon={data.speed ? 'power-off' : 'times'}
                  content={data.speed ? 'Включено' : 'Отключено'}
                  selected={data.speed}
                  disabled={!ourWires.timing}
                  onClick={() => act('speed-toggle')} />
              )}>
              {!ourWires.timing && '[Провода обрезаны!]'}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Контроль шлюза"
              color="bad"
              buttons={(
                <Button
                  icon={data.opened ? 'sign-out-alt' : 'sign-in-alt'}
                  content={data.opened ? 'Открыт' : 'Закрыт'}
                  selected={data.opened}
                  disabled={(data.locked || data.welded)}
                  onClick={() => act('open-close')} />
              )}>
              {!!(data.locked || data.welded) && (
                <span>
                  [{data.locked ? 'Болты опущены' : ''}
                  {(data.locked && data.welded) ? ' и ' : ''}
                  {data.welded ? 'шлюз заварен' : ''}!]
                </span>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
