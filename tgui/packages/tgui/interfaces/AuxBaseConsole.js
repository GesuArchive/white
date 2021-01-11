import { useBackend, useSharedState } from '../backend';
import { Button, NoticeBox, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';
import { ShuttleConsoleContent } from './ShuttleConsole';

export const AuxBaseConsole = (props, context) => {
  const { data } = useBackend(context);
  const [tab, setTab] = useSharedState(context, 'tab', 1);
  const {
    type,
    blind_drop,
    turrets = [],
  } = data;
  return (
    <Window
      width={turrets.length ? 620 : 350}
      height={turrets.length ? 310 : 260}>
      <Window.Content scrollable={!!turrets.length}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}>
            {type === "shuttle" ? "Запуск шаттла" : "Управление пуском"}
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Турели ({turrets.length})
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && (
          <ShuttleConsoleContent
            type={type}
            blind_drop={blind_drop} />
        )}
        {tab === 2 && (
          <AuxBaseConsoleContent />
        )}
      </Window.Content>
    </Window>
  );
};

const STATUS_COLOR_KEYS = {
  "ОШИБКА": "bad",
  "Отключена": "bad",
  "ОГОНЬ": "average",
  "Чисто": "good",
};

export const AuxBaseConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    turrets = [],
  } = data;
  return (
    <Section
      title={"Управление турелями"}
      buttons={(
        !!turrets.length && (
          <Button
            icon="power-off"
            content={"Переключить"}
            onClick={() => act('turrets_power')} />
        ))}>
      {!turrets.length ? (
        <NoticeBox>
          Нет турелей
        </NoticeBox>
      ) : (
        <Table cellpadding="3" textAlign="center">
          <Table.Row header>
            <Table.Cell>Единица</Table.Cell>
            <Table.Cell>Прочность</Table.Cell>
            <Table.Cell>Состояние</Table.Cell>
            <Table.Cell>Направление</Table.Cell>
            <Table.Cell>Дистанция</Table.Cell>
            <Table.Cell>Питание</Table.Cell>
          </Table.Row>
          {turrets.map(turret => (
            <Table.Row key={turret.key}>
              <Table.Cell bold>{turret.name}</Table.Cell>
              <Table.Cell>{turret.integrity}%</Table.Cell>
              <Table.Cell
                color={STATUS_COLOR_KEYS[turret.status] || "bad"}>
                {turret.status}
              </Table.Cell>
              <Table.Cell>{turret.direction}</Table.Cell>
              <Table.Cell>{turret.distance}m</Table.Cell>
              <Table.Cell>
                <Button
                  icon="power-off"
                  content="Переключить"
                  onClick={() => act('single_turret_power', {
                    single_turret_power: turret.ref,
                  })} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};
