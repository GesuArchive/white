import { toFixed } from 'common/math';
import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Icon, LabeledList, ProgressBar, Section } from '../components';

export const ChemDispenser = props => {
  const { act, data } = useBackend(props);
  const recording = !!data.recordingRecipe;
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
    <Fragment>
      <Section
        title="Состояние"
        buttons={recording && (
          <Box inline mx={1} color="red">
            <Icon name="circle" mr={1} />
            Запись
          </Box>
        )}>
        <LabeledList>
          <LabeledList.Item label="Энергия">
            <ProgressBar
              value={data.energy / data.maxEnergy}
              content={toFixed(data.energy) + ' единиц'} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Рецепты"
        buttons={(
          <Fragment>
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
                content="Запись"
                onClick={() => act('record_recipe')} />
            )}
            {recording && (
              <Button
                icon="ban"
                color="transparent"
                content="Отменить"
                onClick={() => act('cancel_recording')} />
            )}
            {recording && (
              <Button
                icon="save"
                color="green"
                content="Сохранить"
                onClick={() => act('save_recording')} />
            )}
          </Fragment>
        )}>
        <Box mr={-1}>
          {recipes.map(recipe => (
            <Button key={recipe.name}
              icon="tint"
              width="129.5px"
              lineHeight="21px"
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
        title="Распределение"
        buttons={(
          beakerTransferAmounts.map(amount => (
            <Button key={amount}
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
            <Button key={chemical.id}
              icon="tint"
              width="129.5px"
              lineHeight="21px"
              content={chemical.title}
              onClick={() => act('dispense', {
                reagent: chemical.id,
              })} />
          ))}
        </Box>
      </Section>
      <Section
        title="Пробирка"
        buttons={(
          beakerTransferAmounts.map(amount => (
            <Button key={amount}
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
                content="Eject"
                disabled={!data.isBeakerLoaded}
                onClick={() => act('eject')} />
            )}>
            {recording
              && 'Виртуальная пробирка'
              || data.isBeakerLoaded
                && (
                  <Fragment>
                    <AnimatedNumber
                      initial={0}
                      value={data.beakerCurrentVolume} />
                    /{data.beakerMaxVolume} units
                  </Fragment>
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
    </Fragment>
  );
};
