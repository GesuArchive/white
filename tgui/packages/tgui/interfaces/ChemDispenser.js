import { toFixed } from 'common/math';
import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { AnimatedNumber, Box, Button, Icon, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const ChemDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const recording = !!data.recordingRecipe;
  const { recipeReagents = [] } = data;
  const [hasCol, setHasCol] = useLocalState(
    context, 'has_col', false);
  // TODO: Change how this piece of shit is built on server side
  // It has to be a list, not a fucking OBJECT!
  const recipes = Object.keys(data.recipes)
    .map(name => ({
      name,
      contents: data.recipes[name],
    }));
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
  return (
    <Window
      width={565}
      height={620}>
      <Window.Content scrollable>
        <Section
          title="Состояние"
          buttons={(
            <Fragment>
              {recording && (
                <Box inline mx={1} color="red">
                  <Icon name="circle" mr={1} />
                  Запись
                </Box>
              )}
              <Button
                icon="book"
                disabled={!data.isBeakerLoaded}
                content={"Поиск реакций"}
                tooltip={data.isBeakerLoaded ? "Поищем же рецепты и реагенты!" : "Вставьте пробирку!"}
                tooltipPosition="bottom-start"
                onClick={() => act('reaction_lookup')} />
              <Button
                icon="cog"
                tooltip="Цвета pH"
                tooltipPosition="bottom-start"
                selected={hasCol}
                onClick={() => setHasCol(!hasCol)} />
            </Fragment>
          )}>
          <LabeledList>
            <LabeledList.Item label="Энергия">
              <ProgressBar
                value={data.energy / data.maxEnergy}>
                {toFixed(data.energy) + ' единиц'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Рецепты"
          buttons={(
            <>
              {!recording && (
                <Box inline mx={1}>
                  <Button
                    color="transparent"
                    content="Очистить рецепты"
                    onClick={() => act('clear_recipes')} />
                </Box>
              )}
              {!recording && (
                <Button
                  icon="circle"
                  disabled={!data.isBeakerLoaded}
                  content="Записывать"
                  onClick={() => act('record_recipe')} />
              )}
              {recording && (
                <Button
                  icon="ban"
                  color="transparent"
                  content="Очистить"
                  onClick={() => act('cancel_recording')} />
              )}
              {recording && (
                <Button
                  icon="save"
                  color="green"
                  content="Сохранить"
                  onClick={() => act('save_recording')} />
              )}
            </>
          )}>
          <Box mr={-1}>
            {recipes.map(recipe => (
              <Button
                key={recipe.name}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                content={recipe.name}
                onClick={() => act('dispense_recipe', {
                  recipe: recipe.name,
                })} />
            ))}
            {recipes.length === 0 && (
              <Box color="light-gray">
                Нет рецептов.
              </Box>
            )}
          </Box>
        </Section>
        <Section
          title="Раздатчик"
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
            {data.chemicals.map(chemical => (
              <Button
                key={chemical.id}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                content={chemical.title.length > 15
                  ? chemical.title.substring(0, 12)
                  + "..." : chemical.title}
                tooltip={"pH: " + chemical.pH}
                color={recipeReagents.includes(chemical.id)
                  ? hasCol ? "black" : "green"
                  : hasCol ? chemical.pHCol : "default"}
                onClick={() => act('dispense', {
                  reagent: chemical.id,
                })} />
            ))}
          </Box>
        </Section>
        <Section
          title="Ёмкость"
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
              label="Ёмкость"
              buttons={!!data.isBeakerLoaded && (
                <Button
                  icon="eject"
                  content="Изъять"
                  disabled={!data.isBeakerLoaded}
                  onClick={() => act('eject')} />
              )}>
              {recording
                && 'Виртуальная ёмкость'
                || data.isBeakerLoaded
                  && (
                    <>
                      <AnimatedNumber
                        initial={0}
                        value={data.beakerCurrentVolume} />
                      /{data.beakerMaxVolume} единиц
                    </>
                  )
                || 'Нет ёмкости'}
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
                  ед. {chemical.name}
                </Box>
              ))}
              {((beakerContents.length > 0 && !!data.showpH) && (
                <Box>
                  pH:
                  <AnimatedNumber
                    value={data.beakerCurrentpH} />
                </Box>)
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
