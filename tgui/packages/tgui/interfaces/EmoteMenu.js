import { useBackend, useLocalState } from '../backend';
import { Button, Input } from '../components';
import { Window } from '../layouts';

export const EmoteMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
  const keys = Object.keys(data);
  const verbsByTab = data.verbs[keys[tab]];
  const matchingVerbs = verbsByTab.filter((val, key) =>
    val[0].toLowerCase().search(searchText.toLowerCase()) !== -1).sort();
  return (
    <Window
      width={450}
      height={400}
      resizable>
      <Window.Content scrollable>
        <Input
          fluid
          mb={1}
          placeholder="Поиск..."
          onInput={(e, value) => setSearchText(value)} />
        {matchingVerbs.map((val, key) => {
          return (
            <Button key={key} content={<font color={val[2]}>{val[0]}</font>}
              onClick={() => act(val[1])} />
          );
        })}
      </Window.Content>
    </Window>
  );
};
