import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';

export const EmoteMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const emotes = data.emotes;
  return (
    <Window
      width={450}
      height={320}
      resizable>
      <Window.Content scrollable>
        {emotes
          .map(thing => (
            <Button
              key={thing}
              color="white"
              content={thing}
              onClick={() => act(thing)} />
          ))}
      </Window.Content>
    </Window>
  );
};
