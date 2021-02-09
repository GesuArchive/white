import { useBackend, useSharedState } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const Microscope = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useSharedState(context, 'tab', 1);
  const {
    has_dish,
    cell_lines = [],
    viruses = [],
  } = data;
  return (
    <Window>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Образец">
              <Button
                icon="eject"
                content="Изъять"
                disabled={!has_dish}
                onClick={() => act('eject_petridish')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Tabs>
          <Tabs.Tab
            icon="microscope"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}>
            Микро-организмы ({cell_lines.length})
          </Tabs.Tab>
          <Tabs.Tab
            icon="microscope"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Вирусы ({viruses.length})
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && (
          <Organisms cell_lines={cell_lines} />
        )}
        {tab === 2 && (
          <Viruses viruses={viruses} />
        )}
      </Window.Content>
    </Window>
  );
};

const Organisms = (props, context) => {
  const { cell_lines } = props;
  const { act, data } = useBackend(context);
  if (!cell_lines.length) {
    return (
      <NoticeBox>
        Не обнаружено микро-организмов
      </NoticeBox>
    );
  }
  return cell_lines.map(cell_line => {
    return (
      <Section
        key={cell_line.desc}
        title={cell_line.desc}>
        <LabeledList>
          <LabeledList.Item label="Скорость роста">
            {cell_line.growth_rate}
          </LabeledList.Item>
          <LabeledList.Item label="Подозрительность">
            {cell_line.suspectibility}
          </LabeledList.Item>
          <LabeledList.Item label="Требуемые реагенты">
            {cell_line.requireds}
          </LabeledList.Item>
          <LabeledList.Item label="Дополнительные реагенты">
            {cell_line.supplementaries}
          </LabeledList.Item>
          <LabeledList.Item label="Подавляющие реагенты">
            {cell_line.suppressives}
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};

const Viruses = (props, context) => {
  const { viruses } = props;
  const { act } = useBackend(context);
  if (!viruses.length) {
    return (
      <NoticeBox>
        Не обнаружено вирусов
      </NoticeBox>
    );
  }
  return viruses.map(virus => {
    return (
      <Section
        key={virus.desc}
        title={virus.desc} />
    );
  });
};
