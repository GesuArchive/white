import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, Tabs } from '../components';
import { Window } from '../layouts';

export const GameMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const keys = Object.keys(data);
  const [tab, setTab] = useLocalState(context, 'tab', 0);
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Tabs>
          {keys.map((val, key) => {
            return (
              <Tabs.Tab
                key={key}
                // icon="list"
                lineHeight="23px"
                selected={tab === key}
                onClick={() => setTab(key)}>
                {val}
              </Tabs.Tab>);
          })}
        </Tabs>
        <LabeledList>
          {data[keys[tab]].map((val, key) => {
            return (
              <LabeledList.Item label={val[0]} key={key}>
                <Button content={val[1].split("/").pop()} onClick={() =>
                  act(val[1].split("/").pop())} />
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Window.Content>
    </Window>
  );
};
