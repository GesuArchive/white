import { useBackend } from '../backend';
import { Button, Section, Box, Icon, LabeledList, NoticeBox } from '../components';
import { Window } from '../layouts';

export const Forge = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const { selected_material, amount, max_amount, reagent_list, crafts } = data;
  return (
    <Window width={300} height={455}>
      <Window.Content>
        <Section title="Плавильня">
          <Box mb={1} fontSize="20px" textAlign="center">
            {selected_material}: {amount}/{max_amount}
          </Box>
        </Section>
        <Section title="Реагенты">
          <LabeledList>
            {reagent_list.map((reagent) => (
              <Button
                key={reagent.name}
                content={reagent.name}
                tooltip={reagent.volume}
                m={1}
                selected={reagent.name === selected_material}
                textAlign="center"
                onClick={() =>
                  act('select', {
                    reagent: reagent.name,
                  })
                }
              />
            ))}
          </LabeledList>
          {(!!reagent_list.length && (
            <Button
              fontColor="white"
              color="transparent"
              icon="arrow-right"
              onClick={() => act('dump')}>
              Очистить
            </Button>
          )) || <NoticeBox>Нет реагентов.</NoticeBox>}
        </Section>
        <Section title="Рецепты">
          <LabeledList>
            {crafts.map((craft) => (
              <LabeledList.Item
                label={craft.name}
                key={craft}
                buttons={
                  <Button
                    fontColor="white"
                    disabled={amount < craft.cost}
                    color="white"
                    icon="arrow-right"
                    onClick={() =>
                      act('create', {
                        path: craft.path,
                        cost: craft.cost,
                      })
                    }>
                    Создать
                  </Button>
                }>
                <Box color={amount < craft.cost ? 'red' : 'green'} mb={0.5}>
                  <Icon name="star" /> {craft.cost} единиц
                </Box>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
