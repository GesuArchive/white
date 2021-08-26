import { useBackend } from '../../backend';
import { Box, Button, Chart, Flex, Icon, LabeledList, Tooltip } from '../../components';

export const RecipeLookup = (props, context) => {
  const { recipe, bookmarkedReactions } = props;
  const { act, data } = useBackend(context);
  if (!recipe) {
    return (
      <Box>
        Не выбрана реакция!
      </Box>
    );
  }

  const getReaction = id => {
    return data.master_reaction_list.filter(reaction => (
      reaction.id === id
    ));
  };

  const addBookmark = bookmark => {
    bookmarkedReactions.add(bookmark);
  };

  return (
    <LabeledList>
      <LabeledList.Item bold label="Рецепт">
        <Icon name="circle" mr={1} color={recipe.reagentCol} />
        {recipe.name}
        <Button
          icon="arrow-left"
          ml={3}
          disabled={recipe.subReactIndex === 1}
          onClick={() => act('reduce_index', {
            id: recipe.name,
          })} />
        <Button
          icon="arrow-right"
          disabled={recipe.subReactIndex === recipe.subReactLen}
          onClick={() => act('increment_index', {
            id: recipe.name,
          })} />
        {bookmarkedReactions && (
          <Button
            icon="book"
            color="green"
            disabled={bookmarkedReactions.has(getReaction(recipe.id)[0])}
            onClick={() => {
              addBookmark(getReaction(recipe.id)[0]);
              act('update_ui');
            }} />
        )}
      </LabeledList.Item>
      {recipe.products && (
        <LabeledList.Item bold label="Выход">
          {recipe.products.map(product => (
            <Button
              key={product.name}
              icon="vial"
              disabled={product.hasProduct}
              content={product.ratio + "е " + product.name}
              onClick={() => act('reagent_click', {
                id: product.id,
              })} />
          ))}
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Реагенты">
        {recipe.reactants.map(reactant => (
          <Box key={reactant.id}>
            <Button
              icon="vial"
              color={reactant.color}
              content={reactant.ratio + "е " + reactant.name}
              onClick={() => act('reagent_click', {
                id: reactant.id,
              })} />
            {!!reactant.tooltipBool && (
              <Button
                icon="flask"
                color="purple"
                tooltip={reactant.tooltip}
                tooltipPosition="right"
                onClick={() => act('find_reagent_reaction', {
                  id: reactant.id,
                })} />
            )}
          </Box>
        ))}
      </LabeledList.Item>
      {recipe.catalysts && (
        <LabeledList.Item bold label="Катализаторы">
          {recipe.catalysts.map(catalyst => (
            <Box key={catalyst.id}>
              {catalyst.tooltipBool && (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + "е " + catalyst.name}
                  tooltip={catalyst.tooltip}
                  tooltipPosition={"right"}
                  onClick={() => act('reagent_click', {
                    id: catalyst.id,
                  })} />
              ) || (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + "е " + catalyst.name}
                  onClick={() => act('reagent_click', {
                    id: catalyst.id,
                  })} />
              )}
            </Box>
          ))}
        </LabeledList.Item>
      )}
      {recipe.reqContainer && (
        <LabeledList.Item bold label="Пробирка">
          <Button
            color="transparent"
            textColor="white"
            tooltipPosition="right"
            content={recipe.reqContainer}
            tooltip="Требуемая ёмкость для этой реакции." />
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="Чистота">
        <LabeledList>
          <LabeledList.Item label="Оптимальная зона pH">
            <Box position="relative">
              <Tooltip
                content="Если реакция будет проходить в рамках этого pH, то чистота будет 100%">
                {recipe.lowerpH + "-" + recipe.upperpH}
              </Tooltip>
            </Box>
          </LabeledList.Item>
          {!!recipe.inversePurity && (
            <LabeledList.Item label="Инверсная чистота">
              <Box position="relative">
                <Tooltip
                  content="Если чистота ниже этого процента, то 100% реагентов конвертирует в инверсивный реагент при реакции." >
                  {`<${(recipe.inversePurity*100)}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
          {!!recipe.minPurity && (
            <LabeledList.Item label="Минимальная чистота">
              <Box position="relative">
                <Tooltip
                  content="Если чистота ниже этого параметра, это вызовет негативные эффекты и если реакция пройдёт до конца с такими условиями, то получится провальный реагент." >
                  {`<${(recipe.minPurity*100)}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
        </LabeledList>
      </LabeledList.Item>
      <LabeledList.Item bold label="Температура" width="10px">
        <Box
          height="50px"
          position="relative"
          style={{
            'background-color': 'black',
          }}>
          <Chart.Line
            fillPositionedParent
            data={recipe.thermodynamics}
            strokeWidth={0}
            fillColor={"#3cf072"} />
          {recipe.explosive && (
            <Chart.Line
              position="absolute"
              justify="right"
              top={0.01}
              bottom={0}
              right={recipe.isColdRecipe ? null : 0}
              width="28px"
              data={recipe.explosive}
              strokeWidth={0}
              fillColor={"#d92727"} />
          )}
        </Box>
        <Flex
          justify="space-between">
          <Tooltip
            content={recipe.isColdRecipe
              ? "При превышении данной температуры реакция будет провальной."
              : "Минимальная температура для начала реакции. Нагрев сильнее лишь только ускорит скорость прохождения реакции."} >
            <Flex.Item
              position="relative"
              textColor={recipe.isColdRecipe && "red"}>
              {recipe.isColdRecipe
                ? recipe.explodeTemp + "K"
                : recipe.tempMin + "K"}
            </Flex.Item>
          </Tooltip>

          {recipe.explosive && (
            <Tooltip
              content={recipe.isColdRecipe
                ? "Минимальная температура для начала реакции. Нагрев сильнее лишь только ускорит скорость прохождения реакции."
                : "При превышении данной температуры реакция будет провальной."}>
              <Flex.Item
                position="relative"
                textColor={!recipe.isColdRecipe && "red"}>
                {recipe.isColdRecipe
                  ? recipe.tempMin + "K"
                  : recipe.explodeTemp + "K"}
              </Flex.Item>
            </Tooltip>
          )}
        </Flex>
      </LabeledList.Item>
      <LabeledList.Item bold label="Динамика">
        <LabeledList>
          <LabeledList.Item label="Оптимальная скорость">
            <Tooltip
              content="Максимальная скорость прохождения реакции. Можете определить её по плато на графике выше.">
              <Box position="relative">
                {recipe.thermoUpper + "е/с"}
              </Box>
            </Tooltip>
          </LabeledList.Item>
        </LabeledList>
        <Tooltip
          content="Тепло, которое генерируется при реакции - экзотермическая производит тепло, эндотермическая поглощает тепло." >
          <Box
            position="relative">
            {recipe.thermics}
          </Box>
        </Tooltip>
      </LabeledList.Item>
    </LabeledList>
  );
};
