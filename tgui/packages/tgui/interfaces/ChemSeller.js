import { useBackend } from '../backend';
import { Button, Box, Section, ProgressBar, Flex } from '../components';
import { Window } from '../layouts';

export const ChemSeller = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    chemicals,
    selected,
    isBeakerLoaded,
    beakerReagentAmount,
    beakerVolume,
  } = data;
  return (
    <Window resizable width={300} height={500} title="Chem Vendor">
      <Window.Content scrollable>
        <Section title="Выбор химиката">
          <Box ml={2} mr={5}>
            {chemicals.map(chemical => (

              <Button
                content={chemical.title+" ("+chemical.price+")"}
                key={chemical.title}
                icon="tint"
                color="transparent"
                fluid={1}
                selected={chemical.typepath === selected[0].typepath}
                lineHeight={1.25}
                tooltip={chemical.desc}
                onClick={() => act("select",
                  { reagent: chemical.typepath }
                )}
              />

            ))}
          </Box>
        </Section>
        <Section title={selected[0].title}>
          <ProgressBar
            value={beakerReagentAmount}
            maxValue={beakerVolume}
          >
            {isBeakerLoaded ? beakerReagentAmount+"u/"+beakerVolume+"u." : "No beaker found."}
          </ProgressBar>
          <Flex>
            <Flex.Item grow={1}>
              <Button
                content={"Синтезировать! ("+selected[0].price+")"}
                disabled={isBeakerLoaded === 0}
                onClick={() => act("dispense", {})}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                content="Изъять"
                disabled={isBeakerLoaded === 0}
                onClick={() => act("eject", {})}
              />
            </Flex.Item>
          </Flex>
          <Box mt={1} mb={1}>
            {selected[0].desc}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
