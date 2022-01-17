import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const MinigamesMenu = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Window
      title="Мини-игры"
      width={550}
      height={200}>
      <Window.Content>
        <Section title="Выбирай с умом" textAlign="center">
          <Stack>
            <Stack.Item grow>
              <Button
                content="Захват флага"
                fluid={1}
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('ctf')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="Мафия"
                fluid={1}
                fontSize={3}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('mafia')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
