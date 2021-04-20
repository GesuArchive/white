import { toTitleCase } from 'common/string';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { sortBy } from 'common/collections';

export const PortableChemMixer = (props, context) => {
  const { act, data } = useBackend(context);
  const recording = !!data.recordingRecipe;
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = recording
    && Object.keys(data.recordingRecipe)
      .map(id => ({
        id,
        name: toTitleCase(id.replace(/_/, ' ')),
        volume: data.recordingRecipe[id],
      }))
    || data.beakerContents
    || [];
  const chemicals = sortBy(chem => chem.title)(data.chemicals);
  return (
    <Window
      width={645}
      height={550}>
      <Window.Content scrollable>
        <Section
          title="Выдать"
          buttons={(
            beakerTransferAmounts.map(amount => (
              <Button
                key={amount}
                icon="plus"
                selected={amount === data.amount}
                content={amount}
                onClick={() => act('amount', {
                  target: amount,
                })} />
            ))
          )}>
          <Box mr={-1}>
            {chemicals.map(chemical => (
              <Button
                key={chemical.id}
                icon="tint"
                width="150px"
                lineHeight="21px"
                content={`(${chemical.volume}) ${chemical.title}`}
                onClick={() => act('dispense', {
                  reagent: chemical.id,
                })} />
            ))}
          </Box>
        </Section>
        <Section
          title="Выдача"
          buttons={(
            beakerTransferAmounts.map(amount => (
              <Button
                key={amount}
                icon="minus"
                disabled={recording}
                content={amount}
                onClick={() => act('remove', { amount })} />
            ))
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Пробирка"
              buttons={!!data.isBeakerLoaded && (
                <Button
                  icon="eject"
                  content="Изъять"
                  disabled={!data.isBeakerLoaded}
                  onClick={() => act('eject')} />
              )}>
              {recording
                && 'Виртуальная пробирка'
                || data.isBeakerLoaded
                  && (
                    <>
                      <AnimatedNumber
                        initial={0}
                        value={data.beakerCurrentVolume} />
                      /{data.beakerMaxVolume} единиц
                    </>
                  )
                || 'Нет пробирки'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Содержимое">
              <Box color="label">
                {(!data.isBeakerLoaded && !recording) && 'N/A'
                  || beakerContents.length === 0 && 'Ничего'}
              </Box>
              {beakerContents.map(chemical => (
                <Box
                  key={chemical.name}
                  color="label">
                  <AnimatedNumber
                    initial={0}
                    value={chemical.volume} />
                  {' '}
                  единиц {chemical.name}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
