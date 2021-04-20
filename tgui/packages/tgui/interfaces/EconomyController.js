import { useBackend } from '../backend';
import { Box, Flex, Button, LabeledList, Section, NumberInput } from '../components';
import { Window } from '../layouts';

export const EconomyController = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    eng_eco_mod,
    sci_eco_mod,
    med_eco_mod,
    sec_eco_mod,
    srv_eco_mod,
    civ_eco_mod,
    accounts = [],
    selflog = [],
  } = data;
  return (
    <Window
      width={900}
      height={600}>
      <Window.Content>
        <Flex
          height="250px"
          direction="row">
          <Flex.Item width="17%" grow={1} m={3}>
            <Section title="Модификаторы">
              <LabeledList>
                <LabeledList.Item label="Инженерный">
                  <ModifyValue
                    department="change_eng"
                    count={eng_eco_mod} />
                </LabeledList.Item>
                <LabeledList.Item label="Научный">
                  <ModifyValue
                    department="change_sci"
                    count={sci_eco_mod} />
                </LabeledList.Item>
                <LabeledList.Item label="Медицинский">
                  <ModifyValue
                    department="change_med"
                    count={med_eco_mod} />
                </LabeledList.Item>
                <LabeledList.Item label="Безопасность">
                  <ModifyValue
                    department="change_sec"
                    count={sec_eco_mod} />
                </LabeledList.Item>
                <LabeledList.Item label="Сервис">
                  <ModifyValue
                    department="change_srv"
                    count={srv_eco_mod} />
                </LabeledList.Item>
                <LabeledList.Item label="Гражданский">
                  <ModifyValue
                    department="change_civ"
                    count={civ_eco_mod} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item width="80%" grow={1} m={1}>
            <Section
              title="Аккаунты"
              overflowY="scroll"
              height="185px">
              {accounts.map(bbb => (
                <Box key={bbb.id} className="candystripe">
                  {bbb.id} - {bbb.name} - {bbb.balance}
                </Box>
              ))}
            </Section>
          </Flex.Item>
        </Flex>
        <Section
          title="Журнал транзакций"
          buttons={(
            <Button.Confirm
              icon="trash"
              content="Очистить"
              onClick={() => act('clear_me')} />
          )}>
          {selflog.map(log => (
            <Box key={log.entry} className="candystripe">
              {log.entry}
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

const ModifyValue = (props, context) => {
  const { act } = useBackend(context);

  const { department, count } = props;

  return (
    <NumberInput
      width="30px"
      animated
      value={count}
      minValue={0.5}
      maxValue={10}
      initial={1}
      stepPixelSize={25}
      onDrag={(e, value) => act(department, {
        nalog: value,
      })} />
  );
};
