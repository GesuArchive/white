import { createSearch, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Icon, Box, Button, Flex, Input, Section, Table, Tabs, NoticeBox, Divider, Grid, ProgressBar, Collapsible } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';
import { TableRow } from '../components/Table';
import { GridColumn } from '../components/Grid';

export const convertPower = power_in => {
  const units = ["W", "kW", "MW", "GW"];
  let power = 0;
  let value = power_in;
  while (value >= 1000 && power < units.length)
  {
    power ++;
    value /= 1000;
  }
  return ((Math.round((value + Number.EPSILON) * 100)/100) + units[power]);
};

export const ClockworkSlab = (props, context) => {
  const { data } = useBackend(context);
  const { power } = data;
  const { recollection } = data;
  const [
    selectedTab,
    setSelectedTab,
  ] = useLocalState(context, 'selectedTab', "Порабощение");
  return (
    <Window
      theme="clockwork"
      resizable
      width={860}
      height={700}>
      <Window.Content>
        <Section
          title={(
            <Box
              inline
              color={'good'}>
              <Icon name={"cog"} rotation={0} spin={1} />
              {" Механизм "}
              <Icon name={"cog"} rotation={35} spin={1} />
            </Box>
          )}>
          <ClockworkButtonSelection />
        </Section>
        <div className="ClockSlab__left">
          <Section
            height="100%"
            overflowY="scroll">
            <ClockworkSpellList selectedTab={selectedTab} />
          </Section>
        </div>
        <div className="ClockSlab__right">
          <div className="ClockSlab__stats">
            <Section
              height="100%"
              overflowY="scroll">
              <ClockworkOverview />
            </Section>
          </div>
          <div className="ClockSlab__current">
            <Section
              height="100%"
              overflowY="scroll"
              title="Слуги шестерни том.1">
              <ClockworkHelp />
            </Section>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

export const ClockworkHelp = (props, context) => {
  return (
    <Fragment>
      <Collapsible title="Что делать" color="average" open={1}>
        <Section>
          После долгой и разрушительной
          войны, Рат&#39;вар был заключен в тюрьму
          внутри измерения страдания.
          <br />
          Вы - группа из его последних оставшихся,
          самых лояльных служителей. <br />
          Вы очень слабы и у вас мало сил,
          с большинством ваших Священных Писаний, неспособных
          работать.
          <br />
          <b>
            Используйте&nbsp;
            <font color="#BD78C4">
              консоли наблюдения Ратвара&nbsp;
            </font>
            для перемещения на станцию!
          </b>
          <br />
          <b>
            Устанавливайте&nbsp;
            <font color="#DFC69C">
              Интеграционные шестерни&nbsp;
            </font>
            чтобы разблокировать больше священных писаний!
          </b>
          <br />
          <b>
            Разблокируйте&nbsp;
            <font color="#D8D98D">
              Разжечь&nbsp;
            </font>
            ,&nbsp;
            <font color="#F19096">
              Оковы ненависти&nbsp;
            </font>
            и вызов&nbsp;
            <font color="#9EA7E5">
              Сигила подчинения&nbsp;
            </font>
            для конвертирования неверных!
          </b>
          <br />
        </Section>
      </Collapsible>
      <Collapsible title="Открытие Священных Писаний" color="average">
        <Section>
          Большинство Священных Писаний требует <b>шестерни</b> для открытия.
          <br />
          Создавай&nbsp;
          <font color="#DFC69C">
            <b>
              интеграционные шестерни&nbsp;
            </b>
          </font>
          для призыва этих самых шестерней,
          которые могут быть установлены в любой&nbsp;
          <b>
            электрощиток&nbsp;
          </b>
          на станции.
          <br />
          Вскрывай&nbsp;
          <b>
            электрощитки&nbsp;
          </b>
          используя&nbsp;
          <b>
            интеграционные шестерни&nbsp;
          </b>
          , затем вставляй их для выкачивания
          энергии.
          <br />
        </Section>
      </Collapsible>
      <Collapsible title="Конвертирование" color="average">
        <Section>
          Вызывай&nbsp;
          <b>
            <font color="#D8D98D">
              Разжечь&nbsp;
            </font>
          </b>
          (после разблокировки), для&nbsp;
          <b>
            оглушения&nbsp;
          </b>
          и&nbsp;
          <b>
            немоты&nbsp;
          </b>
          любой цели, по времени достаточные,
          чтобы связать их.
          <br />
          Используя&nbsp;
          <b>
            стяжки&nbsp;
          </b> найденные на станции, или
          же вызовом&nbsp;
          <b>
            <font color="#F19096">
              Оков ненависти&nbsp;
            </font>
          </b>
          , можно связывать неверных
          для предотвращения их побега от СВЕТА.
          <br />
          Вызывай&nbsp;
          <b>
            <font color="#D5B8DC">
              Бегство&nbsp;
            </font>
          </b>
          для возврата обратно на Риби, пока держишь
          неверного с собой.
          <br />
          Теперь, вызывай&nbsp;
          <b>
            <font color="#9EA7E5">
              Сигил подчинения&nbsp;
            </font>
          </b>
          и держи цель на нём
          примерно 8 секунд. <br />
          Однако, не получится сделать это с&nbsp;
          <b>
            защитой разума.
          </b>
          <br />
          Убедись, что снял их&nbsp;
          <b>
            наушник&nbsp;
          </b>
          , чтобы они не говорили много!
          <br />
        </Section>
      </Collapsible>
      <Collapsible title="Защита Риби" color="average">
        <Section>
          <b>
            У вас широкий спектр структур и механизмов
            это будет жизненно важно для защиты Ковчега.
          </b>
          <br />
          <b>
            <font color="#B5FD9D">
              Производитель реплик:&nbsp;
            </font>
          </b>
          Мощный инструмент, который может быстро построить
          Латунные конструкции или преобразовать большинство материалов
          в латунь.
          <br />
          <b>
            <font color="#DED09F">
              Мехскарабей:&nbsp;
            </font>
          </b>
          Маленький дрон, одержимый духами
          павших солдат, который будет защищать Риби,
          пока вы выходите и распространяете правду!<br />
          <b>
            <font color="#FF9D9D">
              Механический мародёр:&nbsp;
            </font>
          </b>
          Сильный боец, который может отражать
          атаки дальнего боя и наносить сильные
          удары в ближнем бою.<br />
          <br />
        </Section>
      </Collapsible>
      <Collapsible title="Ковчег" color="average">
        <Section>
          Для призыва Рат&#39;вара &nbsp;
          <b>
            <font color="#E9E094">
              Ковчег&nbsp;
            </font>
          </b> должен быть открыт.
          <br />
          Это можно сделать, если рядом
          будет достаточное количество слуг у&nbsp;
          <b>
            <font color="#B5FD9D">
              Ковчега.&nbsp;
            </font>
          </b>
          <br />
          После того, как вы достаточно просветите станцию,&nbsp;
          <b>
            <font color="#E9E094">
              Ковчег&nbsp;
            </font>
          </b>
          будет открыт.
          <br />
          <b>
            Убедитесь, что вы готовы к открытию Ковчега,
            так как вся станция собирается уничтожить его!
          </b>
          <br />
        </Section>
      </Collapsible>
    </Fragment>
  );
};

export const ClockworkSpellList = (props, context) => {
  const { act, data } = useBackend(context);
  const { selectedTab } = props;
  const {
    scriptures = [],
  } = data;
  return (
    <Table>
      {scriptures.map(script => (
        script.type === selectedTab
          ? (
            <Fragment
              key={script}>
              <TableRow>
                <Table.Cell bold>
                  {script.name}
                </Table.Cell>
                <Table.Cell collapsing textAlign="right">
                  <Button
                    fluid
                    color={script.purchased
                      ? "default"
                      : "average"}
                    content={script.purchased
                      ? "Вызвать " + (convertPower(script.cost))
                      : script.cog_cost + " Шестерней"}
                    disabled={false}
                    onClick={() => act("invoke", {
                      scriptureName: script.name,
                    })} />
                </Table.Cell>
              </TableRow>
              <TableRow>
                <Table.Cell>
                  {script.desc}
                </Table.Cell>
                <Table.Cell collapsing textAlign="right">
                  <Button
                    fluid
                    content={"Быстрый вызов"}
                    disabled={!script.purchased}
                    onClick={() => act("quickbind", {
                      scriptureName: script.name,
                    })} />
                </Table.Cell>
              </TableRow>
              <Table.Cell>
                <Divider />
              </Table.Cell>
            </Fragment>
          )
          : <Box key={script} />
      ))}
    </Table>
  );
};

export const ClockworkOverview = (props, context) => {
  const { data } = useBackend(context);
  const {
    power,
    cogs,
    vitality,
  } = data;
  return (
    <Box>
      <Box
        color="good"
        bold
        fontSize="16px">
        {"Состояние Ковчега"}
      </Box>
      <Divider />
      <ClockworkOverviewStat
        title="Шестерни"
        amount={cogs}
        maxAmount={cogs + (50 / cogs)}
        iconName="cog"
        unit="" />
      <ClockworkOverviewStat
        title="Энергия"
        amount={power}
        maxAmount={power + (500000 / power)}
        iconName="battery-half "
        overrideText={convertPower(power)} />
      <ClockworkOverviewStat
        title="Жизнеспособность"
        amount={vitality}
        maxAmount={vitality + (50 / vitality)}
        iconName="tint"
        unit="е" />
    </Box>
  );
};

export const ClockworkOverviewStat = (props, context) => {
  const {
    title,
    iconName,
    amount,
    maxAmount,
    unit,
    overrideText,
  } = props;
  return (
    <Box height="32px" fontSize="16px">
      <Grid>
        <Grid.Column>
          <Icon name={iconName} rotation={0} spin={0} />
        </Grid.Column>
        <Grid.Column size="2">
          {title}
        </Grid.Column>
        <Grid.Column size="8">
          <ProgressBar
            value={amount}
            minValue={0}
            maxValue={maxAmount}
            ranges={{
              good: [maxAmount/2, Infinity],
              average: [maxAmount/4, maxAmount/2],
              bad: [-Infinity, maxAmount/4],
            }}>
            {overrideText
              ? overrideText
              : amount + " " + unit}
          </ProgressBar>
        </Grid.Column>
      </Grid>
    </Box>
  );
};

export const ClockworkButtonSelection = (props, context) => {
  const [
    selectedTab,
    setSelectedTab,
  ] = useLocalState(context, 'selectedTab', {});
  const tabs = ["Порабощение", "Сохранение", "Структуры"];
  return (
    <Table>
      <Table.Row>
        {tabs.map(tab => (
          <Table.Cell
            key={tab}
            collapsing>
            <Button
              key={tab}
              fluid
              content={tab}
              onClick={() => setSelectedTab(tab)} />
          </Table.Cell>
        ))}
      </Table.Row>
    </Table>
  );
};
