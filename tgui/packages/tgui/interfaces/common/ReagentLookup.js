import { useBackend } from '../../backend';
import { Box, Button, Icon, LabeledList } from '../../components';

export const ReagentLookup = (props, context) => {
  const { reagent } = props;
  const { act } = useBackend(context);
  if (!reagent) {
    return (
      <Box>
        Не выбран химикат!
      </Box>
    );
  }

  return (
    <LabeledList>
      <LabeledList.Item label="Химикат">
        <Icon name="circle" mr={1} color={reagent.reagentCol} />
        {reagent.name}
        <Button
          ml={1}
          icon="wifi"
          color="teal"
          tooltip="Открыть вики по этому реагенту."
          tooltipPosition="left"
          onClick={() => {
            Byond.command(`wiki Guide_to_chemistry#${reagent.name}`);
          }} />
      </LabeledList.Item>
      <LabeledList.Item label="Описание">
        {reagent.desc}
      </LabeledList.Item>
      <LabeledList.Item label="pH">
        <Icon name="circle" mr={1} color={reagent.pHCol} />
        {reagent.pH}
      </LabeledList.Item>
      <LabeledList.Item label="Свойства">
        <LabeledList>
          {!!reagent.OD && (
            <LabeledList.Item label="Передоз">
              {reagent.OD}u
            </LabeledList.Item>
          )}
          {reagent.addictions[0] && (
            <LabeledList.Item label="Зависимость">
              {reagent.addictions.map(addiction => (
                <Box key={addiction}>
                  {addiction}
                </Box>
              ))}
            </LabeledList.Item>
          )}
          <LabeledList.Item label="Скорость метаболизма">
            {reagent.metaRate}е/с
          </LabeledList.Item>
        </LabeledList>
      </LabeledList.Item>
      <LabeledList.Item label="Примеси">
        <LabeledList>
          {reagent.impureReagent && (
            <LabeledList.Item label="Нечистый химикат">
              <Button
                icon="vial"
                tooltip="Этот химикат частично превратится в него, когда чистота выше обратной чистоты при потреблении."
                tooltipPosition="left"
                content={reagent.impureReagent}
                onClick={() => act('reagent_click', {
                  id: reagent.impureId,
                })} />
            </LabeledList.Item>
          )}
          {reagent.inverseReagent && (
            <LabeledList.Item label="Инверсный химикат">
              <Button
                icon="vial"
                content={reagent.inverseReagent}
                tooltip="Этот химикат превратится в него, когда чистота ниже обратной чистоты при потреблении."
                tooltipPosition="left"
                onClick={() => act('reagent_click', {
                  id: reagent.inverseId,
                })} />
            </LabeledList.Item>
          )}
          {reagent.failedReagent && (
            <LabeledList.Item label="Провальный химикат">
              <Button
                icon="vial"
                tooltip="Этот химикат превратится в него, если чистота реакции ниже минимальной чистоты по завершении."
                tooltipPosition="left"
                content={reagent.failedReagent}
                onClick={() => act('reagent_click', {
                  id: reagent.failedId,
                })} />
            </LabeledList.Item>
          )}
        </LabeledList>
        {reagent.isImpure && (
          <Box>
            Этот химикат создан примесью.
          </Box>
        )}
        {reagent.deadProcess && (
          <Box>
            Этот химикат работает на мёртвых.
          </Box>
        )}
        {!reagent.failedReagent
          && !reagent.inverseReagent
          && !reagent.impureReagent && (
          <Box>
            Этот химикат не имеет примесей.
          </Box>
        )}
      </LabeledList.Item>
      <LabeledList.Item>
        <Button
          icon="flask"
          mt={2}
          content={"Найти подходящую реакцию"}
          color="purple"
          onClick={() => act('find_reagent_reaction', {
            id: reagent.id,
          })} />
      </LabeledList.Item>
    </LabeledList>
  );
};
