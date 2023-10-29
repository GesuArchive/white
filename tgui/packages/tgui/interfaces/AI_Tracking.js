import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Button, Flex, Icon, Input, Section } from '../components';
import { Window } from '../layouts';

const PATTERN_NUMBER = / \(([0-9]+)\)$/;

const searchFor = (searchText) =>
  createSearch(searchText, (thing) => thing.name);

const compareString = (a, b) => (a < b ? -1 : a > b);

const compareNumberedText = (a, b) => {
  const aName = a.name;
  const bName = b.name;

  // Check if aName and bName are the same except for a number at the end
  // e.g. Medibot (2) and Medibot (3)
  const aNumberMatch = aName.match(PATTERN_NUMBER);
  const bNumberMatch = bName.match(PATTERN_NUMBER);

  if (
    aNumberMatch &&
    bNumberMatch &&
    aName.replace(PATTERN_NUMBER, '') === bName.replace(PATTERN_NUMBER, '')
  ) {
    const aNumber = parseInt(aNumberMatch[1], 10);
    const bNumber = parseInt(bNumberMatch[1], 10);

    return aNumber - bNumber;
  }

  return compareString(aName, bName);
};

const BasicSection = (props, context) => {
  const { act } = useBackend(context);
  const { searchText, source, title } = props;

  const things = source.filter(searchFor(searchText));
  things.sort(compareNumberedText);
  return (
    source.length > 0 && (
      <Section title={`${title} - (${source.length})`}>
        {things.map((thing) => (
          <Button
            key={thing.name}
            content={thing.name}
            onClick={() =>
              act('follow', {
                target_name: thing.name,
              })
            }
          />
        ))}
      </Section>
    )
  );
};

const OrbitedButton = (props, context) => {
  const { act } = useBackend(context);
  const { color, thing } = props;

  return (
    <Button
      color={color}
      onClick={() =>
        act('follow', {
          target_name: thing.name,
        })
      }>
      {thing.name}
    </Button>
  );
};

export const AI_Tracking = (props, context) => {
  const { act, data } = useBackend(context);
  const { humans, others } = data;

  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');

  const orbitMostRelevant = (searchText) => {
    for (const source of [humans, others]) {
      const member = source
        .filter(searchFor(searchText))
        .sort(compareNumberedText)[0];
      if (member !== undefined) {
        act('follow', {
          target_name: member.name,
        });
        break;
      }
    }
  };

  return (
    <Window title="Слежка" width={350} height={700}>
      <Window.Content scrollable>
        <Section>
          <Flex>
            <Flex.Item>
              <Icon name="search" mr={1} />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Input
                placeholder="Искать..."
                autoFocus
                fluid
                value={searchText}
                onInput={(_, value) => setSearchText(value)}
                onEnter={(_, value) => orbitMostRelevant(value)}
              />
            </Flex.Item>
          </Flex>
        </Section>

        <Section title={`Люди - (${humans.length})`}>
          {humans
            .filter(searchFor(searchText))
            .sort(compareNumberedText)
            .map((thing) => (
              <OrbitedButton key={thing.name} color="good" thing={thing} />
            ))}
        </Section>

        <BasicSection title="Другие" source={others} searchText={searchText} />
      </Window.Content>
    </Window>
  );
};
