import { useBackend, useSharedState } from '../backend';
import { Button, Flex, LabeledList, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const TachyonArray = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    records = [],
    is_research,
  } = data;
  return (
    <Window
      width={550}
      height={250}>
      <Window.Content scrollable>
        <Flex direction="column" height="100%">
          <Flex.Item grow={1} className="TachyonArray__Content">
            {!records.length ? (
              <NoticeBox>
                Нет записей
              </NoticeBox>
            ) : (
              <TachyonArrayContent />
            )}
          </Flex.Item>
          {!!is_research && (
            <Flex.Item className="TachyonArray__ResearchFooter">
              <Button
                onClick={() => act("open_experiments")}
                icon="tasks">
                Показать эксперименты
              </Button>
            </Flex.Item>
          )}
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const TachyonArrayContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    records = [],
  } = data;
  const [
    activeRecordName,
    setActiveRecordName,
  ] = useSharedState(context, 'record', records[0]?.name);
  const activeRecord = records.find(record => {
    return record.name === activeRecordName;
  });
  return (
    <Section height="100%">
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {records.map(record => (
              <Tabs.Tab
                icon="file"
                key={record.name}
                selected={record.name === activeRecordName}
                onClick={() => setActiveRecordName(record.name)}>
                {record.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        {activeRecord ? (
          <Flex.Item className="TachyonArray__ActiveRecord">
            <Section
              level="2"
              title={activeRecord.name}
              buttons={(
                <>
                  <Button.Confirm
                    icon="trash"
                    content="Удалить"
                    color="bad"
                    onClick={() => act('delete_record', {
                      'ref': activeRecord.ref,
                    })} />
                  <Button
                    icon="print"
                    content="Печать"
                    onClick={() => act('print_record', {
                      'ref': activeRecord.ref,
                    })} />
                </>
              )}>
              <LabeledList>
                <LabeledList.Item label="Время">
                  {activeRecord.timestamp}
                </LabeledList.Item>
                <LabeledList.Item label="Координаты">
                  {activeRecord.coordinates}
                </LabeledList.Item>
                <LabeledList.Item label="Смещение">
                  {activeRecord.displacement} seconds
                </LabeledList.Item>
                <LabeledList.Item label="Эпицентр">
                  {activeRecord.factual_epicenter_radius}
                  {activeRecord.theory_epicenter_radius
                  && " (Теоретический: "
                  + activeRecord.theory_epicenter_radius + ")"}
                </LabeledList.Item>
                <LabeledList.Item label="Внешний радиус">
                  {activeRecord.factual_outer_radius}
                  {activeRecord.theory_outer_radius
                  && " (Теоретический: "
                  + activeRecord.theory_outer_radius + ")"}
                </LabeledList.Item>
                <LabeledList.Item label="Взрывная волна">
                  {activeRecord.factual_shockwave_radius}
                  {activeRecord.theory_shockwave_radius
                  && " (Теоретическая: "
                  + activeRecord.theory_shockwave_radius + ")"}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
        ) : (
          <Flex.Item grow={1} basis={0}>
            <NoticeBox>
              Не выбрана запись
            </NoticeBox>
          </Flex.Item>
        )}
      </Flex>
    </Section>
  );
};
