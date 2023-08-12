import { useBackend, useLocalState } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

const TAB2NAME = [
  {
    title: 'ЗОНЫ',
    blurb: 'То, что взрывает все нахуй',
    gauge: 5,
    component: () => ZONES,
  },
  {
    title: 'Доп кнопки',
    blurb: 'Некоторые полезные функции',
    gauge: 95,
    component: () => Extrabuttons,
  },
];

const lineHeightNormal = 2.79;
const lineHeightDebug = 6;


const ZONES = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Flex direction="column" mb={-0.5} mx={-0.5} textAlign="center">
      <Flex
        mb={1}
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить инженерный"
            onClick={() => act('engineering')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить медицинский"
            onClick={() => act('medical')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить мостик"
            onClick={() => act('bridge')}
          />
        </Flex.Item>
      </Flex>
      <Flex
        mb={1}
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить карго"
            onClick={() => act('cargo')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить бриг"
            onClick={() => act('brig')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить РнД"
            onClick={() => act('rnd')}
          />
        </Flex.Item>
      </Flex>
      <Flex
        mb={1}
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить спутник"
            onClick={() => act('sputnikV')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить дормы"
            onClick={() => act('dorm')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Отключить библиотеку+церковь"
            onClick={() => act('holyknigi')}
          />
        </Flex.Item>
      </Flex>
      <Flex
        grow={1}
        mx={-0.5}
        mb={-1.75}
        direction="column"
        height="100%"
        align="stretch"
        justify="center">

        <Flex.Item>
          <Flex justify="space-between">
            <Flex.Item grow={1} ml={0.25}>
              <NoticeBox info>
               <Button
                 color="white"
                  icon="sync-alt"
                  fluid
                  content="Отключить заброшенный мед"
                  onClick={() => act('medical_away')}
                />
              </NoticeBox>
            </Flex.Item>
            <Flex.Item grow={1} ml={0.25}>
              <NoticeBox info>
                <Button
                color="white"
                icon="sync-alt"
                fluid
                content="Отключить заброшенный РнД"
                onClick={() => act('rnd_away')}
                />
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
      <Flex
        grow={1}
        mx={-0.5}
        mb={-1.75}
        direction="column"
        height="100%"
        align="stretch"
        justify="center">
        <Flex.Item>
          <Flex justify="space-between">
            <Flex.Item grow={1} ml={0.25}>
              <NoticeBox info>
                <Button
                color="white"
                icon="sync-alt"
                fluid
                content="Отключить коморку уборщика"
                onClick={() => act('uborshik')}
                />
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Flex>
  );
};

const Extrabuttons = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Flex
      grow={1}
      mx={-0.5}
      mb={-1.75}
      direction="column"
      height="100%"
      align="stretch"
      justify="center">

      <Flex.Item>
        <Flex justify="space-between">
          <Flex.Item grow={1} ml={0.25}>
            <NoticeBox info>
              <Button
                color="blue"
                icon="sync-alt"
                fluid
                content="Обесточить техтонели"
                onClick={() => act('maint')}
              />
            </NoticeBox>
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

export const DarkEvent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tab-index', 2);
  const TabComponent = TAB2NAME[tabIndex - 1].component();
  return (
    <Window title="Очень крутая панелька" width={530} height={500}>
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item mb={1}>
            <Section
              title="Не секреты..."
            >
              <Flex mx={-0.5} align="stretch" justify="center">
                <Flex.Item bold>
                  <NoticeBox color="black">
                    &quot;Возможно, это будет полезно.&quot;
                  </NoticeBox>
                </Flex.Item>
              </Flex>
              <Flex
                textAlign="center"
                mx={-0.5}
                align="stretch"
                justify="center">
                <Flex.Item ml={-4} mr={2}>
                  <Button
                    selected={tabIndex === 2}
                    icon="check-circle"
                    content="Доп кнопки"
                    onClick={() => setTabIndex(2)}
                  />
                </Flex.Item>
              </Flex>
              <Flex mx={-0.5} align="stretch" justify="center">
                <Flex.Item mt={1} ml={12}>
                  <Button
                    selected={tabIndex === 1}
                    icon="glasses"
                    content="Отключение зон"
                    onClick={() => setTabIndex(1)}
                  />
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section
              fill={false}
              title={
                TAB2NAME[tabIndex - 1].title +
                ' Или: ' +
                TAB2NAME[tabIndex - 1].blurb
              }>
              <TabComponent />
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
