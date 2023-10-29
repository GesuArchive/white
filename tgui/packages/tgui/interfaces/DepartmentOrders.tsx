import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Dimmer, Icon, NoticeBox, Section, Stack, Tabs, Tooltip } from '../components';
import { Window } from '../layouts';

// 15x crate value
const COST_UPPER_BOUND = 3000;

type Pack = {
  name: string;
  cost: number;
  id: string;
  desc: string;
  goody: string;
};

type Category = {
  name: string;
  packs: Pack[];
};

type Info = {
  can_override: BooleanLike;
  time_left: number;
  supplies: Category[];
};

const CooldownEstimate = (props) => {
  const { cost } = props;
  const cooldownColor =
    (cost > COST_UPPER_BOUND * 0.75 && 'red') ||
    (cost > COST_UPPER_BOUND * 0.25 && 'orange') ||
    'green';
  const cooldownText =
    (cost > COST_UPPER_BOUND * 0.75 && 'большая') ||
    (cost > COST_UPPER_BOUND * 0.25 && 'средняя') ||
    'короткая';
  return (
    <Box as="span" textColor={cooldownColor}>
      {cooldownText} задержка
    </Box>
  );
};

export const DepartmentOrders = (props, context) => {
  const { data } = useBackend<Info>(context);
  const { time_left } = data;
  return (
    <Window title="Заказы отдела" width={620} height={620}>
      <Window.Content>
        {(!!time_left && <CooldownDimmer />) || (
          <Stack vertical fill>
            <Stack.Item grow>
              <Stack fill vertical>
                <Stack.Item>
                  <NoticeBox info>
                    Для сотрудников Нанотрейзен, покупка товаров здесь полностью
                    бесплатна, однако существует проблема с изготовлением,
                    поэтому, чем дешевле заказ, тем меньше придётся ждать, перед
                    заказом нового товара, дабы уменьшить вероятность лишнего
                    заказа.
                  </NoticeBox>
                </Stack.Item>
                <Stack.Item grow>
                  <DepartmentCatalog />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

const CooldownDimmer = (props, context) => {
  const { act, data } = useBackend<Info>(context);
  const { can_override, time_left } = data;
  return (
    <Dimmer>
      <Stack vertical>
        <Stack.Item textAlign="center">
          <Icon color="orange" name="route" size={20} />
        </Stack.Item>
        <Stack.Item fontSize="18px" color="orange">
          Готовы к следующему заказу через {time_left}...
        </Stack.Item>
        <Stack.Item textAlign="center" color="orange">
          <Button
            width="300px"
            lineHeight={2}
            tooltip={
              (!!can_override && 'Это действие требует доступ главы!') ||
              'Товар уже отправлен! Никаких отмен!'
            }
            fontSize="14px"
            color="red"
            disabled={!can_override}
            onClick={() => act('override_order')}>
            <Box fontSize="22px">Отменить</Box>
          </Button>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const DepartmentCatalog = (props, context) => {
  const { act, data } = useBackend<Info>(context);
  const { supplies } = data;
  const [tabCategory, setTabCategory] = useLocalState(
    context,
    'tabName',
    supplies[0]
  );
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs textAlign="center" fluid>
          {supplies.map((cat) => (
            <Tabs.Tab
              key={cat}
              selected={tabCategory === cat}
              onClick={() => setTabCategory(cat)}>
              {cat.name}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {tabCategory.packs.map((pack) => (
              <Stack.Item className="candystripe" key={pack.name}>
                <Stack fill>
                  <Stack.Item grow>
                    <Tooltip content={pack.desc}>
                      <Box
                        as="span"
                        style={{
                          'border-bottom':
                            '2px dotted rgba(255, 255, 255, 0.8)',
                        }}>
                        {pack.name}
                      </Box>
                    </Tooltip>
                  </Stack.Item>
                  <Stack.Item>
                    <CooldownEstimate cost={pack.cost} />
                    &ensp;
                    <Button
                      onClick={() =>
                        act('order', {
                          id: pack.id,
                        })
                      }>
                      Заказать
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
