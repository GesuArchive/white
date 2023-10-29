import { createSearch, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Input, Section, Table, Tabs, NoticeBox, LabeledList } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

const MAX_SEARCH_RESULTS = 25;

export const DonationsMenu = (props, context) => {
  const { data } = useBackend(context);
  const { money } = data;
  return (
    <Window width={620} height={580} theme="hackerman">
      <Window.Content scrollable>
        <GenericUplink currencyAmount={money} currencySymbol="Р" />
      </Window.Content>
    </Window>
  );
};

export const GenericUplink = (props, context) => {
  const { currencyAmount = 0, currencySymbol = 'р' } = props;
  const { act, data } = useBackend(context);
  const { compactMode, categories = [] } = data;
  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
  const [selectedCategory, setSelectedCategory] = useLocalState(
    context,
    'category',
    'INFO'
  );
  const testSearch = createSearch(searchText, (item) => {
    return item.name;
  });
  const items =
    (searchText.length > 0 &&
      // Flatten all categories and apply search to it
      categories
        .flatMap((category) => category.items || [])
        .filter(testSearch)
        .filter((item, i) => i < MAX_SEARCH_RESULTS)) ||
    // Select a category and show all items in it
    categories.find((category) => category.name === selectedCategory)?.items ||
    // If none of that results in a list, return an empty list
    [];
  return (
    <Section
      title={
        <Box inline color={currencyAmount > 0 ? 'good' : 'bad'}>
          Баланс: {formatMoney(currencyAmount)} {currencySymbol}
        </Box>
      }
      buttons={
        <Fragment>
          <Button
            icon="plus"
            tooltip="Откроет страницу пополнения"
            mr={1}
            tooltipPosition="right"
            onClick={() => Byond.command('Войти-в-ХАБ')}>
            Пополнить счёт
          </Button>
          Поиск
          <Input
            autoFocus
            value={searchText}
            onInput={(e, value) => setSearchText(value)}
            mx={1}
          />
          <Button
            icon={compactMode ? 'list' : 'info'}
            content={compactMode ? 'Компактно' : 'Детально'}
            onClick={() => act('compact_toggle')}
          />
        </Fragment>
      }>
      <Flex>
        {searchText.length === 0 && (
          <Flex.Item>
            <Tabs vertical mr={1}>
              <Tabs.Tab
                key="test"
                selected={'INFO' === selectedCategory}
                onClick={() => setSelectedCategory('INFO')}>
                Информация
              </Tabs.Tab>
              {categories.map((category) => (
                <Tabs.Tab
                  key={category.name}
                  selected={category.name === selectedCategory}
                  onClick={() => setSelectedCategory(category.name)}>
                  {category.name} ({category.items?.length || 0})
                </Tabs.Tab>
              ))}
            </Tabs>
          </Flex.Item>
        )}
        <Flex.Item grow={1} basis={0}>
          {'INFO' === selectedCategory && (
            <Box>
              <NoticeBox danger>
                Очень важная информация для тех, кто собирается донатить
              </NoticeBox>
              <Section title="Реквизиты">
                <LabeledList>
                  <LabeledList.Item label="HUB">
                    Кнопочка <b>Пополнить счёт</b>
                  </LabeledList.Item>
                  <LabeledList.Item label="BTC">
                    3MYLd3PEuou6coQ3AYCNtNKTBh9y9o7GbJ
                  </LabeledList.Item>
                  <LabeledList.Item label="ETH">
                    0x74E77B4559f8F0200435281CffE963af54412C81
                  </LabeledList.Item>
                  <LabeledList.Item label="LTC">
                    MTQyQVu9Dw8ucP46ydBteYSgxFNUpDKW5D
                  </LabeledList.Item>
                  <LabeledList.Item label="DASH">
                    Xn5t2U7NdyLp72efhdEjijMuBa5VCsiJRd
                  </LabeledList.Item>
                  <LabeledList.Item label="DOGE">
                    DRiBpqRp7EdE1PfGzgSY1ov6Q2GNwJgrV1
                  </LabeledList.Item>
                  <LabeledList.Item label="TRX">
                    TCbyTr3fx4dvicJrtNN2SaZBsj6xyaB3km
                  </LabeledList.Item>
                  <LabeledList.Item label="ЮMoney">
                    410011561142450
                  </LabeledList.Item>
                  <LabeledList.Item label="sobe.ru">
                    <a
                      href="https://sobe.ru/na/novye_koleni_dlya_vaita"
                      style={{ 'color': '#ffffff' }}>
                      https://sobe.ru/na/novye_koleni_dlya_vaita
                    </a>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <NoticeBox>
                ОБЯЗАТЕЛЬНО сверяйте способы пополнения счёта
                с теми, что были описаны выше!
              </NoticeBox>
              <Section title="Дополнительные награды">
                Полный список можно найти здесь:&nbsp;
                <a
                  href="https://station13.ru/ru/donate"
                  style={{ 'color': '#ffffff' }}>
                  https://station13.ru/ru/donate
                </a>
              </Section>
              <NoticeBox info>
                При платеже указывайте свой CKEY, чтобы не было потом проблем с
                обновлением баланса. Прикольный цвет, кстати.
              </NoticeBox>
              <Section title="Как работает эта панель?">
                <big>
                  Всё просто! Любой предмет из списка вы можете вызывать по
                  желанию в первые 10 минут в любом месте на карте, после начала
                  игры, после чего, далее, только на территории бара.
                  Баланс каждый новый раунд сбрасывается к изначальной сумме,
                  поэтому не стесняйтесь экспериментировать.
                </big>
              </Section>
              <NoticeBox success>Успехов!</NoticeBox>
            </Box>
          )}
          {items.length === 0 && 'INFO' !== selectedCategory && (
            <NoticeBox>
              {searchText.length === 0
                ? 'Нет предметов в этой категории.'
                : 'Не обнаружено ничего по запросу.'}
            </NoticeBox>
          )}
          <ItemList
            compactMode={searchText.length > 0 || compactMode}
            currencyAmount={currencyAmount}
            currencySymbol={currencySymbol}
            items={items}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const ItemList = (props, context) => {
  const { compactMode, currencyAmount, currencySymbol } = props;
  const { act } = useBackend(context);
  const [hoveredItem, setHoveredItem] = useLocalState(
    context,
    'hoveredItem',
    {}
  );
  const hoveredCost = (hoveredItem && hoveredItem.cost) || 0;
  // Append extra hover data to items
  const items = props.items.map((item) => {
    const notSameItem = hoveredItem && hoveredItem.name !== item.name;
    const notEnoughHovered = currencyAmount - hoveredCost < item.cost;
    const disabledDueToHovered = notSameItem && notEnoughHovered;
    const disabled = currencyAmount < item.cost || disabledDueToHovered;
    return {
      ...item,
      disabled,
    };
  });
  if (compactMode) {
    return (
      <Table>
        {items.map((item) => (
          <Table.Row key={item.name} className="candystripe">
            <Table.Cell bold>{decodeHtmlEntities(item.name)}</Table.Cell>
            <Table.Cell collapsing textAlign="right">
              <Button
                fluid
                content={formatMoney(item.cost) + ' ' + currencySymbol}
                disabled={item.disabled}
                tooltipPosition="left"
                onmouseover={() => setHoveredItem(item)}
                onmouseout={() => setHoveredItem({})}
                onClick={() =>
                  act('buy', {
                    name: item.name,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }
  return (
    <Table>
      {items.map((item) => (
        <Table.Row key={item.name} className="candystripe">
          <Table.Cell bold>
            <img
              src={`data:image/jpeg;base64,${item.icon}`}
              style={{
                'vertical-align': 'middle',
                'horizontal-align': 'middle',
              }}
            />
            {decodeHtmlEntities(item.name)}
          </Table.Cell>
          <Table.Cell collapsing textAlign="right">
            <Button
              fluid
              content={formatMoney(item.cost) + ' ' + currencySymbol}
              disabled={item.disabled}
              tooltipPosition="left"
              onmouseover={() => setHoveredItem(item)}
              onmouseout={() => setHoveredItem({})}
              onClick={() =>
                act('buy', {
                  'ref': item.ref,
                })
              }
            />
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
