import { useBackend } from "../backend";
import { Box, Icon, Stack, Button, Section, NoticeBox, LabeledList, Collapsible } from "../components";
import { Window } from "../layouts";

export const Vote = (props, context) => {
  const { data } = useBackend(context);
  const { mode, question, lower_admin } = data;

  // Adds the voting type to title if there is an ongoing vote
  let windowTitle = "Голосование";
  if (mode) {
    windowTitle += ": " + (question || mode).replace(/^\w/, c => c.toUpperCase());
  }

  return (
    <Window resizable title={windowTitle} width={400} height={550}>
      <Window.Content>
        <Stack fill vertical>
          {!!lower_admin && (
            <Section title="ОПЦИИ">
              <VoteOptions />
              <VotersList />
            </Section>
          )}
          <ChoicesPanel />
          <TimePanel />
        </Stack>
      </Window.Content>
    </Window>
  );
};

// Gives access to starting votes
const VoteOptions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    allow_vote_mode,
    allow_vote_restart,
    allow_vote_map,
    upper_admin,
  } = data;

  return (
    <Stack.Item>
      <Collapsible title="Начать голосование">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_vote_map ? 1 : 1.6}
                    color="red"
                    checked={!!allow_vote_map}
                    onClick={() => act("toggle_map")}>
                    {allow_vote_map ? "Включено" : "Выключено"}
                  </Button.Checkbox>
                )}
                <Button
                  disabled={!upper_admin || !allow_vote_map}
                  onClick={() => act("map")}>
                  Карта
                </Button>
              </Stack.Item>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_vote_restart ? 1 : 1.6}
                    color="red"
                    checked={!!allow_vote_restart}
                    onClick={() => act("toggle_restart")}>
                    {allow_vote_restart ? "Включено" : "Выключено"}
                  </Button.Checkbox>
                )}
                <Button
                  disabled={!upper_admin || !allow_vote_restart}
                  onClick={() => act("restart")}>
                  Перезапуск
                </Button>
              </Stack.Item>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_vote_mode ? 1 : 1.6}
                    color="red"
                    checked={!!allow_vote_mode}
                    onClick={() => act("toggle_gamemode")}>
                    {allow_vote_mode ? "Включено" : "Выключено"}
                  </Button.Checkbox>
                )}
                <Button
                  disabled={!upper_admin || !allow_vote_mode}
                  onClick={() => act("gamemode")}>
                  Режим
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Button disabled={!upper_admin} onClick={() => act("custom")}>
              Своё
            </Button>
          </Stack.Item>
        </Stack>
      </Collapsible>
    </Stack.Item>
  );
};

// Table to view voters by ckey
const VotersList = (props, context) => {
  const { data } = useBackend(context);
  const { voting } = data;

  return (
    <Stack.Item>
      <Collapsible title={`Голосующие: ${voting.length}`}>
        <Section height={8} fill scrollable>
          {voting.map(voter => {
            return <Box key={voter}>{voter}</Box>;
          })}
        </Section>
      </Collapsible>
    </Stack.Item>
  );
};

// Display choices
const ChoicesPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { choices, selected_choice } = data;

  return (
    <Stack.Item grow>
      <Section fill scrollable title="Выбирай!">
        {choices.length !== 0 ? (
          <LabeledList>
            {choices.map((choice, i) => (
              <Box key={choice.id}>
                <LabeledList.Item
                  label={choice.name.replace(/^\w/, c => c.toUpperCase())}
                  textAlign="right"
                  buttons={
                    <Button
                      disabled={i === selected_choice - 1}
                      onClick={() => {
                        act("vote", { index: i + 1 });
                      }}>
                      Голосовать
                    </Button>
                  }>
                  {i === selected_choice - 1 && (
                    <Icon
                      alignSelf="right"
                      mr={2}
                      color="green"
                      name="vote-yea" />
                  )}
                  {choice.votes} Голосов
                </LabeledList.Item>
                <LabeledList.Divider />
              </Box>
            ))}
          </LabeledList>
        ) : (
          <NoticeBox>Выбора нет!</NoticeBox>
        )}
      </Section>
    </Stack.Item>
  );
};

// Countdown timer at the bottom. Includes a cancel vote option for admins
const TimePanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { upper_admin, time_remaining } = data;

  return (
    <Stack.Item mt={1}>
      <Section>
        <Stack justify="space-between">
          <Box fontSize={1.5}>
            Времени осталось: {time_remaining || 0}с
          </Box>
          {!!upper_admin && (
            <Button color="red" onClick={() => act('cancel')}>
              Отменить голосование
            </Button>
          )}
        </Stack>
      </Section>
    </Stack.Item>
  );
};
