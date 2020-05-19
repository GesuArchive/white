import { toArray } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export const GameMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const keys = Object.keys(data);
  const tab = 0;
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
                selected={tab === key}>
                {val}
              </Tabs.Tab>);
          })}
        </Tabs>
        <LabeledList>
          {data[keys[tab]].map((val, key) => {
            return (
              <LabeledList.Item key={key}>
                <Button content={val[0]} onClick={() => act(val[1])} />
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Window.Content>
    </Window>
  );
};

// data[key].map((item, key) => {
// <Button content={key} onClick={() => act(item)} />; })
