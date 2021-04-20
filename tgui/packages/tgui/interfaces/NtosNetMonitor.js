import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, NumberInput, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosNetMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    ntnetrelays,
    ntnetstatus,
    config_softwaredownload,
    config_peertopeer,
    config_communication,
    config_systemcontrol,
    idsalarm,
    idsstatus,
    ntnetmaxlogs,
    maxlogs,
    minlogs,
    ntnetlogs = [],
  } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <NoticeBox>
          ВНИМАНИЕ: Отключение беспроводной передачи данных через
          беспроводное устройство может затруднить её обратное включение!
        </NoticeBox>
        <Section
          title="Беспроводная сеть"
          buttons={(
            <Button.Confirm
              icon={ntnetstatus ? 'power-off' : 'times'}
              content={ntnetstatus ? 'ВКЛЮЧЕНА' : 'ОТКЛЮЧЕНА'}
              selected={ntnetstatus}
              onClick={() => act('toggleWireless')} />
          )}>
          {ntnetrelays ? (
            <LabeledList>
              <LabeledList.Item label="Активные реле NTNet">
                {ntnetrelays}
              </LabeledList.Item>
            </LabeledList>
          ) : "Не обнаружено"}
        </Section>
        <Section title="Настройка файрвола">
          <LabeledList>
            <LabeledList.Item
              label="Репозитории"
              buttons={(
                <Button
                  icon={config_softwaredownload ? 'power-off' : 'times'}
                  content={config_softwaredownload ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
                  selected={config_softwaredownload}
                  onClick={() => act('toggle_function', { id: "1" })} />
              )} />
            <LabeledList.Item
              label="P2P трафик"
              buttons={(
                <Button
                  icon={config_peertopeer ? 'power-off' : 'times'}
                  content={config_peertopeer ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
                  selected={config_peertopeer}
                  onClick={() => act('toggle_function', { id: "2" })} />
              )} />
            <LabeledList.Item
              label="Системы связи"
              buttons={(
                <Button
                  icon={config_communication ? 'power-off' : 'times'}
                  content={config_communication ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
                  selected={config_communication}
                  onClick={() => act('toggle_function', { id: "3" })} />
              )} />
            <LabeledList.Item
              label="Удалённый контроль систем"
              buttons={(
                <Button
                  icon={config_systemcontrol ? 'power-off' : 'times'}
                  content={config_systemcontrol ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
                  selected={config_systemcontrol}
                  onClick={() => act('toggle_function', { id: "4" })} />
              )} />
          </LabeledList>
        </Section>
        <Section title="Безопасность">
          {!!idsalarm && (
            <>
              <NoticeBox>
                ОБНАРУЖЕНО ВТОРЖЕНИЕ В СЕТЬ
              </NoticeBox>
              <Box italics>
                В сети обнаружена аномальная активность. Проверьте системные
                журналы для получения дополнительной информации
              </Box>
            </>
          )}
          <LabeledList>
            <LabeledList.Item
              label="Слежение"
              buttons={(
                <>
                  <Button
                    icon={idsstatus ? 'power-off' : 'times'}
                    content={idsstatus ? 'ВКЛЮЧЕНО' : 'ОТКЛЮЧЕНО'}
                    selected={idsstatus}
                    onClick={() => act('toggleIDS')} />
                  <Button
                    icon="sync"
                    content="Сбросить состояние"
                    color="bad"
                    onClick={() => act('resetIDS')} />
                </>
              )} />
            <LabeledList.Item
              label="Максимальное число строк"
              buttons={(
                <NumberInput
                  value={ntnetmaxlogs}
                  minValue={minlogs}
                  maxValue={maxlogs}
                  width="39px"
                  onChange={(e, value) => act('updatemaxlogs', {
                    new_number: value,
                  })}
                />
              )} />
          </LabeledList>
          <Section
            title="Системный журнал"
            level={2}
            buttons={(
              <Button.Confirm
                icon="trash"
                content="Очистить"
                onClick={() => act('purgelogs')} />
            )}>
            {ntnetlogs.map(log => (
              <Box key={log.entry} className="candystripe">
                {log.entry}
              </Box>
            ))}
          </Section>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
