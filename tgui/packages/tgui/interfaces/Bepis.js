import { useBackend } from '../backend';
import { Box, Button, Grid, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const Bepis = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    amount,
  } = data;
  return (
    <Window
      width={500}
      height={480}>
      <Window.Content>
        <Section title="Business Exploration Protocol Incubation Sink">
          <Section
            title="Информация"
            backgroundColor="#450F44"
            buttons={(
              <Button
                icon="power-off"
                content={data.manual_power ? 'Выкл' : 'Вкл'}
                selected={!data.manual_power}
                onClick={() => act('toggle_power')} />
            )}>
            Все, что тебе нужно знать о B.E.P.I.S. и тебе!
            B.E.P.I.S. выполняет сотни тестов в секунду
            используя электрические и финансовые ресурсы для изобретения
            новых продуктов или открыватия новых технологий иным образом
            упускающихся из виду из-за того, что они слишком
            рискованные или слишком нишевые для производства!
          </Section>
          <Section
            title="Платёжный аккаунт"
            buttons={(
              <Button
                icon="redo-alt"
                content="Сбросить аккаунт"
                onClick={() => act('account_reset')} />
            )}>
            Консоль на данный момент оперируется
            {data.account_owner ? data.account_owner : 'N/A'}.
          </Section>
          <Grid>
            <Grid.Column size={1.5}>
              <Section title="Накопленные данные и статистика">
                <LabeledList>
                  <LabeledList.Item label="Депозит">
                    {data.stored_cash}
                  </LabeledList.Item>
                  <LabeledList.Item label="Вариативность инвестиций">
                    {data.accuracy_percentage}%
                  </LabeledList.Item>
                  <LabeledList.Item label="Бонус за инновации">
                    {data.positive_cash_offset}
                  </LabeledList.Item>
                  <LabeledList.Item label="Компенсация риска"
                    color="bad">
                    {data.negative_cash_offset}
                  </LabeledList.Item>
                  <LabeledList.Item label="Сумма вклада">
                    <NumberInput
                      value={amount}
                      unit="Кредиты"
                      minValue={100}
                      maxValue={30000}
                      step={100}
                      stepPixelSize={2}
                      onChange={(e, value) => act('amount', {
                        amount: value,
                      })} />
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <Box>
                <Button
                  icon="donate"
                  content="Вложить кредиты"
                  disabled={data.manual_power === 1
                    || data.silicon_check === 1}
                  onClick={() => act('deposit_cash')}
                />
                <Button
                  icon="eject"
                  content="Снять кредиты"
                  disabled={data.manual_power === 1}
                  onClick={() => act('withdraw_cash')} />
              </Box>
            </Grid.Column>
            <Grid.Column>
              <Section title="Рыночные данные и анализ">
                <Box>
                  Средняя стоимость технологии: {data.mean_value}
                </Box>
                <Box>
                  Текущий шанс на успех: {data.success_estimate}%
                </Box>
                {data.error_name && (
                  <Box color="bad">
                    Причина предыдущей неудачи: Слишком маленькая сумма.
                    Пожалуйста, вставьте больше денег для будущего успеха.
                  </Box>
                )}
                <Box m={1} />
                <Button
                  icon="microscope"
                  disabled={data.manual_power === 1}
                  onClick={() => act('begin_experiment')}
                  content="Начать тестирование" />
              </Section>
            </Grid.Column>
          </Grid>
        </Section>
      </Window.Content>
    </Window>
  );
};
