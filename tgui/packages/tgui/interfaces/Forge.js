import { useBackend } from '../backend';
import { Button, Section, Stack, Box, BlockQuote, Icon } from '../components';
import { Window } from '../layouts';

export const Forge = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    material,
    amount,
    max_amount,
    crafts,
  } = data;
  return (
    <Window>
      <Box textAlign="center">
        Forge
      </Box>
      <Section>
      <Box textAlign="center">
        {material}: {amount}/{max_amount}
      </Box>
      <Button
        fontColor="white"
        color="transparent"
        icon="arrow-right"
        onClick={() => act('dump')}>
        Dump
      </Button>
      </Section>
      <Stack vertical>
        {crafts.map(craft => (
          <Stack.Item key={craft}>
            <Section
              title={craft.name}
              buttons={(
                <Button
                  fontColor="white"
                  disabled={amount < craft.cost}
                  color="transparent"
                  icon="arrow-right"
                  onClick={() => act('create', {
                    path: craft.path,
                    cost: craft.cost,
                  })} >
                  Craft
                </Button>
              )} >
              <Box
                color={amount < craft.cost ? "red" : "green"}
                mb={0.5}>
                <Icon name="star" /> Цена {craft.cost}.
              </Box>
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Window>
  );
};
