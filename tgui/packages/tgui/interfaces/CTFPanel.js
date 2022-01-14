import { useBackend } from '../backend';
import { Box, Button, Section, Flex, Stack, Divider } from '../components';
import { Window } from '../layouts';

export const CTFPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const teams = data.teams || [];
  const enabled = data.enabled || [];
  return (
    <Window
      title="Захват флага"
      width={700}
      height={600}>
      <Window.Content scrollable>
        <Box textAlign="center" fontSize="18px">
          {enabled}
        </Box>

        <Divider />

        <Flex align="center" wrap="wrap" textAlign="center" m={-0.5}>
          {teams.map(team => (
            <Flex.Item key={team.name} width="49%" m={0.5} mb={8}>
              <Section
                key={team.name}
                title={`Команда ${team.color}`}
              >
                <Stack fill mb={1}>
                  <Stack.Item grow>
                    <Box>
                      <b>{team.team_size}</b> член
                      {team.team_size === 1 ? "" : "ов"}
                    </Box>
                  </Stack.Item>

                  <Stack.Item grow>
                    <Box>
                      <b>{team.score}</b> очко
                      {team.score === 1 ? "" : "в"}
                    </Box>
                  </Stack.Item>
                </Stack>

                <Button
                  content="Прыгнуть"
                  fontSize="18px"
                  fluid={1}
                  color={team.color.toLowerCase()}
                  onClick={() => act('jump', {
                    refs: team.refs,
                  })} />

                <Button
                  content="Ворваться"
                  fontSize="18px"
                  fluid={1}
                  color={team.color.toLowerCase()}
                  onClick={() => act('join', {
                    refs: team.refs,
                  })} />
              </Section>
            </Flex.Item>
          ))}
        </Flex>
      </Window.Content>
    </Window>
  );
};
