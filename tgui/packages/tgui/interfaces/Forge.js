import { useBackend } from '../backend';
import { Button, Section, Stack, Box, Icon, LabeledList } from '../components';
import { Window } from '../layouts';

export const Forge = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    selected_material,
    amount,
    max_amount,
    reagent_list,
    crafts,
  } = data;
  return (
    <Window>
      <Box textAlign="center">
        Плавильня
      </Box>
      <Section>
        <Box textAlign="center">
          {selected_material}: {amount}/{max_amount}
        </Box>
      </Section>
      <Section>
        <LabeledList>
          {reagent_list.map(reagent => (
            <Button
              key={reagent.name}
              content={reagent.name}
              tooltip={reagent.volume}
              selected={reagent.name === selected_material}
              textAlign="center"
              color="transparent"
              onClick={() => act('select', {
                reagent: reagent.name,
              })} />
          ))}
        </LabeledList>
        <Button
          fontColor="white"
          color="transparent"
          icon="arrow-right"
          onClick={() => act('dump')}>
          Очистить
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
                  Создать
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
