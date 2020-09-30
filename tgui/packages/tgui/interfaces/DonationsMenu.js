import { createSearch, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Input, Section, Table, Tabs, NoticeBox } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

const MAX_SEARCH_RESULTS = 25;

export const DonationsMenu = (props, context) => {
  const { data } = useBackend(context);
  const { money } = data;
  return (
    <Window
      width={620}
      height={580}
      theme="malfunction"
      resizable>
      <Window.Content scrollable>
        <GenericUplink
          currencyAmount={money}
          currencySymbol="Р" />
      </Window.Content>
    </Window>
  );
};

export const GenericUplink = (props, context) => {
  const {
    currencyAmount = 0,
    currencySymbol = 'р',
  } = props;
  const { act, data } = useBackend(context);
  const {
    compactMode,
    categories = [],
  } = data;
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const [
    selectedCategory,
    setSelectedCategory,
  ] = useLocalState(context, 'category', categories[0]?.name);
  const testSearch = createSearch(searchText, item => {
    return item.name;
  });
  const items = searchText.length > 0
    // Flatten all categories and apply search to it
    && categories
      .flatMap(category => category.items || [])
      .filter(testSearch)
      .filter((item, i) => i < MAX_SEARCH_RESULTS)
    // Select a category and show all items in it
    || categories
      .find(category => category.name === selectedCategory)
      ?.items
    // If none of that results in a list, return an empty list
    || [];
  return (
    <Section
      title={(
        <Box
          inline
          color={currencyAmount > 0 ? 'good' : 'bad'}>
          {formatMoney(currencyAmount)} {currencySymbol}
        </Box>
      )}
      buttons={(
        <Fragment>
          Поиск
          <Input
            autoFocus
            value={searchText}
            onInput={(e, value) => setSearchText(value)}
            mx={1} />
          <Button
            icon={compactMode ? 'list' : 'info'}
            content={compactMode ? 'Компактно' : 'Детально'}
            onClick={() => act('compact_toggle')} />
        </Fragment>
      )}>
      <Flex>
        {searchText.length === 0 && (
          <Flex.Item>
            <Tabs vertical>
              {categories.map(category => (
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
          {items.length === 0 && (
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
            items={items} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const ItemList = (props, context) => {
  const {
    compactMode,
    currencyAmount,
    currencySymbol,
  } = props;
  const { act } = useBackend(context);
  const [
    hoveredItem,
    setHoveredItem,
  ] = useLocalState(context, 'hoveredItem', {});
  const hoveredCost = hoveredItem && hoveredItem.cost || 0;
  // Append extra hover data to items
  const items = props.items.map(item => {
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
        {items.map(item => (
          <Table.Row
            key={item.name}
            className="candystripe">
            <Table.Cell bold>
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
                onClick={() => act('buy', {
                  name: item.name,
                })} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }
  return (
    <Table>
      {items.map(item => (
        <Table.Row
          key={item.name}
          className="candystripe">
          <Table.Cell bold>
            <img
              src={`data:image/jpeg;base64,${item.icon}`}
              style={{
                'vertical-align': 'middle',
                'horizontal-align': 'middle',
              }} />
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
              onClick={() => act('buy', {
                'ref': item.ref,
              })} />
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
