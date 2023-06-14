import { toFixed } from 'common/math';
import { useBackend, useLocalState } from '../backend';
import { Button, Flex, LabeledControls, NoticeBox, RoundGauge, Section } from '../components';
import { Window } from '../layouts';

const TAB2NAME = [
  {
    title: 'Дебаг',
    blurb: 'Куда вербы отправляются умирать',
    gauge: 5,
    component: () => DebuggingTab,
  },
  {
    title: 'Полезные',
    blurb: 'Где чулочники подкладывают логи',
    gauge: 25,
    component: () => HelpfulTab,
  },
  {
    title: 'Смешное',
    blurb: 'Как я решил устроил """ивент"""',
    gauge: 75,
    component: () => FunTab,
  },
  {
    title: 'Смешно Только Тебе',
    blurb: 'Как я попедалил напоследок',
    gauge: 95,
    component: () => FunForYouTab,
  },
];

const lineHeightNormal = 2.79;
const lineHeightDebug = 6;

const DebuggingTab = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Flex
      grow={1}
      mb={-0.25}
      mx={-0.5}
      direction="column"
      height="100%"
      textAlign="center"
      align="stretch"
      justify="center">
      <Flex.Item my={0.5}>
        <Button
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          content="Сменить доступ всех технических шлюзов на бриг/инженерный"
          onClick={() => act('maint_access_engiebrig')}
        />
      </Flex.Item>
      <Flex.Item my={0.5}>
        <Button
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          content="Сменить доступ всех технических шлюзов на бриг"
          onClick={() => act('maint_access_brig')}
        />
      </Flex.Item>
      <Flex.Item mt={0.5} mb={-0.5}>
        <Button
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          content="Убрать кап на офицеров"
          onClick={() => act('infinite_sec')}
        />
      </Flex.Item>
    </Flex>
  );
};

const HelpfulTab = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Flex direction="column" mb={-0.75} mx={-0.5}>
      <Flex
        mb={1}
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="plus"
            lineHeight={lineHeightNormal}
            fluid
            content="Вылечить все болезни"
            onClick={() => act('clear_virus')}
          />
        </Flex.Item>
        <Flex.Item grow={1} ml={0.5}>
          <Button
            icon="eye"
            lineHeight={lineHeightNormal}
            fluid
            content="Показать Режим Игры"
            onClick={() => act('showgm')}
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
            icon="bomb"
            lineHeight={lineHeightNormal}
            fluid
            content="Список Джихадов"
            onClick={() => act('list_bombers')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="signal"
            lineHeight={lineHeightNormal}
            fluid
            content="Список Сигналлеров"
            onClick={() => act('list_signalers')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="robot"
            lineHeight={lineHeightNormal}
            fluid
            content="Список Законов"
            onClick={() => act('list_lawchanges')}
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
            icon="address-book"
            lineHeight={lineHeightNormal}
            fluid
            content="Показать Манифест"
            onClick={() => act('manifest')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="dna"
            lineHeight={lineHeightNormal}
            fluid
            content="Показать ДНК"
            onClick={() => act('dna')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="fingerprint"
            lineHeight={lineHeightNormal}
            fluid
            content="Показать Отпечатки"
            onClick={() => act('fingerprints')}
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
            icon="flag"
            lineHeight={lineHeightNormal}
            fluid
            content="Врубить CTF"
            onClick={() => act('ctfbutton')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="sync-alt"
            lineHeight={lineHeightNormal}
            fluid
            content="Сбросить Арену"
            onClick={() => act('tdomereset')}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon="moon"
            lineHeight={lineHeightNormal}
            fluid
            content="Врубить Ночную Смену"
            onClick={() => act('night_shift_set')}
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
            icon="pencil-alt"
            lineHeight={lineHeightNormal}
            fluid
            content="Переименовать Станцию"
            onClick={() => act('set_name')}
          />
        </Flex.Item>
        <Flex.Item grow={1} ml={0.5}>
          <Button
            icon="eraser"
            lineHeight={lineHeightNormal}
            fluid
            content="Сбросить Имя Станции"
            onClick={() => act('reset_name')}
          />
        </Flex.Item>
      </Flex>
      <Flex
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="plane-departure"
            lineHeight={lineHeightNormal}
            fluid
            content="Отправить Шаттл"
            onClick={() => act('moveferry')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="plane"
            lineHeight={lineHeightNormal}
            fluid
            content="Переключить Шаттл"
            onClick={() => act('togglearrivals')}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon="plane-arrival"
            lineHeight={lineHeightNormal}
            fluid
            content="Отправить Труд. Шаттл"
            onClick={() => act('movelaborshuttle')}
          />
        </Flex.Item>
      </Flex>
    </Flex>
  );
};

const FunTab = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Flex direction="column" mb={-0.75} mx={-0.5} textAlign="center">
      <Flex
        mb={1}
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="grin-beam-sweat"
            lineHeight={lineHeightNormal}
            fluid
            content="Сломать Все Лампы"
            onClick={() => act('blackout')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="magic"
            lineHeight={lineHeightNormal}
            fluid
            content="Починить Все Лампы"
            onClick={() => act('whiteout')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="biohazard"
            lineHeight={lineHeightNormal}
            fluid
            content="Вызвать Вспышку"
            onClick={() => act('virus')}
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
            icon="bolt"
            lineHeight={lineHeightNormal}
            fluid
            content="Зарядить все зоны"
            onClick={() => act('power')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="moon"
            lineHeight={lineHeightNormal}
            fluid
            content="Разрядить все зоны"
            onClick={() => act('unpower')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="plug"
            lineHeight={lineHeightNormal}
            fluid
            content="Зарядить СМЕСы"
            onClick={() => act('quickpower')}
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
            icon="user-ninja"
            lineHeight={lineHeightNormal}
            fluid
            content="Анонимные Имена"
            onClick={() => act('anon_name')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="users"
            lineHeight={lineHeightNormal}
            fluid
            content="Режим Тройного ИИ"
            onClick={() => act('tripleAI')}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon="bullhorn"
            lineHeight={lineHeightNormal}
            fluid
            content="ОСТАНЕТСЯ ЛИШЬ ОДИН!"
            onClick={() => act('onlyone')}
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
            icon="grin-beam-sweat"
            lineHeight={lineHeightNormal}
            fluid
            content="Раздать Пушки"
            onClick={() => act('guns')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="magic"
            lineHeight={lineHeightNormal}
            fluid
            content="Вызвать Магию"
            onClick={() => act('magic')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="meteor"
            lineHeight={lineHeightNormal}
            fluid
            content="Вызвать Ивенты"
            onClick={() => act('events')}
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
            icon="hammer"
            lineHeight={lineHeightNormal}
            fluid
            content="Эгалитарная Станция"
            onClick={() => act('eagles')}
          />
        </Flex.Item>
        <Flex.Item grow={1} ml={0.5}>
          <Button
            icon="dollar-sign"
            lineHeight={lineHeightNormal}
            fluid
            content="Анархо-Капиталистическая Станция"
            onClick={() => act('ancap')}
          />
        </Flex.Item>
      </Flex>
      <Flex
        grow={1}
        direction="row"
        height="100%"
        align="stretch"
        justify="space-between">
        <Flex.Item grow={1}>
          <Button
            icon="bullseye"
            lineHeight={lineHeightNormal}
            fluid
            content="Портальный Шторм"
            onClick={() => act('customportal')}
          />
        </Flex.Item>
        <Flex.Item grow={1} mx={0.5}>
          <Button
            icon="bomb"
            lineHeight={lineHeightNormal}
            fluid
            content="Поменять Бомбкап"
            onClick={() => act('changebombcap')}
          />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            icon="paw"
            lineHeight={lineHeightNormal}
            fluid
            content="Сменить Всем Расу"
            onClick={() => act('allspecies')}
          />
        </Flex.Item>
      </Flex>
    </Flex>
  );
};

const FunForYouTab = (props, context) => {
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
        <NoticeBox danger>
          <Button
            color="red"
            icon="paw"
            fluid
            content="Превратить всех в мартых"
            onClick={() => act('monkey')}
          />
        </NoticeBox>
      </Flex.Item>
      <Flex.Item>
        <NoticeBox danger>
          <Button
            color="red"
            icon="user-secret"
            fluid
            content="Выдать трейторку каждому"
            onClick={() => act('traitor_all')}
          />
        </NoticeBox>
      </Flex.Item>
      <Flex.Item>
        <NoticeBox danger>
          <Button
            color="red"
            icon="brain"
            fluid
            content="Брейндамаг всем игрокам"
            onClick={() => act('massbraindamage')}
          />
        </NoticeBox>
      </Flex.Item>
      <Flex.Item>
        <NoticeBox danger>
          <Button
            color="black"
            icon="fire"
            fluid
            content="Пол это лава! (ВНИМАНИЕ: пиздец уныло)"
            onClick={() => act('floorlava')}
          />
        </NoticeBox>
      </Flex.Item>
      <Flex.Item>
        <NoticeBox danger>
          <Button
            color="black"
            icon="tired"
            fluid
            content="Китайские Мультики! (ВНИМАНИЕ: возврата нет, и ещё, иди нахуй)"
            onClick={() => act('anime')}
          />
        </NoticeBox>
      </Flex.Item>
      <Flex.Item>
        <Flex>
          <Flex.Item width="240px" mr={0.25}>
            <NoticeBox danger>
              <Button
                color="red"
                icon="cat"
                fluid
                content="Массовая Пуррбация"
                onClick={() => act('masspurrbation')}
              />
            </NoticeBox>
          </Flex.Item>
          <Flex.Item grow={1} ml={0.25}>
            <NoticeBox info>
              <Button
                color="blue"
                icon="user"
                fluid
                content="Анмассовая Пуррбация"
                onClick={() => act('massremovepurrbation')}
              />
            </NoticeBox>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Flex justify="space-between">
          <Flex.Item width="240px" mr={0.25}>
            <NoticeBox danger>
              <Button
                color="red"
                icon="flushed"
                fluid
                content="Полное Погружение"
                onClick={() => act('massimmerse')}
              />
            </NoticeBox>
          </Flex.Item>
          <Flex.Item grow={1} ml={0.25}>
            <NoticeBox info>
              <Button
                color="blue"
                icon="sync-alt"
                fluid
                content="Разбить Погружение"
                onClick={() => act('unmassimmerse')}
              />
            </NoticeBox>
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

export const Secrets = (props, context) => {
  const { act, data } = useBackend(context);
  const { is_debugger, is_funmin } = data;
  const [tabIndex, setTabIndex] = useLocalState(context, 'tab-index', 2);
  const TabComponent = TAB2NAME[tabIndex - 1].component();
  return (
    <Window title="Панель управления" width={530} height={500}>
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item mb={1}>
            <Section
              title="Секреты"
              buttons={
                <>
                  <Button
                    color="blue"
                    icon="arrow-circle-right"
                    content="Ментор Лог"
                    onClick={() => act('mentor_log')}
                  />
                  <Button
                    color="blue"
                    icon="address-card"
                    content="Админ Лог"
                    onClick={() => act('admin_log')}
                  />
                  <Button
                    color="blue"
                    icon="eye"
                    content="Показать Админов"
                    onClick={() => act('show_admins')}
                  />
                </>
              }>
              <Flex mx={-0.5} align="stretch" justify="center">
                <Flex.Item bold>
                  <NoticeBox color="black">
                    &quot;Первое правило админабуза: никому не рассказывать о
                    админабузе.&quot;
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
                    content="Полезное"
                    onClick={() => setTabIndex(2)}
                  />
                </Flex.Item>
                <Flex.Item ml={1}>
                  <Button
                    disabled={is_funmin === 0}
                    selected={tabIndex === 3}
                    icon="smile"
                    content="Смешное"
                    onClick={() => setTabIndex(3)}
                  />
                </Flex.Item>
              </Flex>
              <Flex mx={-0.5} align="stretch" justify="center">
                <Flex.Item mt={1} ml={12}>
                  <Button
                    disabled={is_debugger === 0}
                    selected={tabIndex === 1}
                    icon="glasses"
                    content="Дебаг"
                    onClick={() => setTabIndex(1)}
                  />
                </Flex.Item>
                <Flex.Item>
                  <LabeledControls>
                    <LabeledControls.Item
                      minWidth="66px"
                      label="Шанс анпендала">
                      <RoundGauge
                        size={2}
                        value={TAB2NAME[tabIndex - 1].gauge}
                        minValue={0}
                        maxValue={100}
                        alertAfter={100 * 0.7}
                        ranges={{
                          'good': [-2, 100 * 0.25],
                          'average': [100 * 0.25, 100 * 0.75],
                          'bad': [100 * 0.75, 100],
                        }}
                        format={(value) => toFixed(value) + '%'}
                      />
                    </LabeledControls.Item>
                  </LabeledControls>
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Button
                    disabled={is_funmin === 0}
                    selected={tabIndex === 4}
                    icon="smile-wink"
                    content="Смешно Только Тебе"
                    onClick={() => setTabIndex(4)}
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
