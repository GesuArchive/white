import { useBackend, useLocalState } from '../backend';
import { Button, Input } from '../components';
import { Window } from '../layouts';

export const EmoteMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const {emotes} = data.keys;
  return (
    <Window
      width={450}
      height={400}
      resizable>
      <Window.Content scrollable>
        {emotes
          .map(thing => (
            <OrbitedButton
              key={thing.key}
              color="grey"
              thing={thing} />
          ))}
      </Window.Content>
    </Window>
  );
};
