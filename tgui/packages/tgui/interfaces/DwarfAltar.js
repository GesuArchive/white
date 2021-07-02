import { useBackend } from '../backend';
import { Button, Section, Stack, Box, BlockQuote, Icon } from '../components';
import { Window } from '../layouts';

export const DwarfAltar = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    favor,
    rituals,
  } = data;
  return (
    <Window>
      <Box textAlign="center">
        Благосклонности Армока {favor}
      </Box>
      <Stack vertical>
        {rituals.map(rite => (
          <Stack.Item key={rite}>
            <Section
              title={rite.name}
              buttons={(
                <Button
                  fontColor="white"
                  disabled={favor < rite.cost}
                  color="transparent"
                  icon="arrow-right"
                  onClick={() => act('perform_rite', {
                    path: rite.path,
                    cost: rite.cost,
                  })} >
                  Провести
                </Button>
              )} >
              <Box
                color={favor < rite.cost ? "red" : "green"}
                mb={0.5}>
                <Icon name="star" /> Цена {rite.cost}.
              </Box>
              <BlockQuote>
                {rite.desc}
              </BlockQuote>
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Window>
  );
};
