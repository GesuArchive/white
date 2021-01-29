import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';

export const EmoteMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const emotes = data.emotes;
  return (
    <Window
      width={450}
      height={520}
      resizable>
      <Window.Content scrollable>
        {emotes
          .map(thing => (
            <Button
              key={thing.name}
              color="white"
              content={thing.ru_name}
              onClick={() => act(thing.name)} />
          ))}
      </Window.Content>
    </Window>
  );
};
