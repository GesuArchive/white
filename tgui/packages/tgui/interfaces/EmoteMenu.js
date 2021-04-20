import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';

export const EmoteMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const emotes = data.emotes;
  return (
    <Window
      theme="abductor"
      width={490}
      height={385}>
      <Window.Content scrollable>
        {emotes
          .map((thing, index) => (
            <Button
              key={thing.name}
              width="90px"
              fontSize="11px"
              compact
              color={index%2 === 0 ? "white" : "grey"}
              content={thing.ru_name}
              onClick={() => act(thing.name)} />
          ))}
      </Window.Content>
    </Window>
  );
};
