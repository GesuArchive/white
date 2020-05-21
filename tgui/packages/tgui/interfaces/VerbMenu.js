import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, Tabs } from '../components';
import { Window } from '../layouts';

export const VerbMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const keys = Object.keys(data.verbs);
  const [tab, setTab] = useLocalState(context, 'tab', 0);
  return (
    <Window resizable>
      <Window.Content scrollable>
        {!(keys.length > 1) || (
          <Tabs>
            {keys.map((val, key) => {
              return (
                <Tabs.Tab
                  key={key}
                  // icon="list"
                  lineHeight="25px"
                  selected={tab === key}
                  onClick={() => setTab(key)}>
                  {val}
                </Tabs.Tab>);
            })}
          </Tabs>
        )}
        <LabeledList>
          {data.verbs[keys[tab]].map((val, key) => {
            return (
              <LabeledList.Item label={val[0]} key={key}>
                <Button content={val[1]} onClick={() =>
                  act(val[1])} />
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Window.Content>
    </Window>
  );
};
