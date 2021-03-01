import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const CivCargoHoldTerminal = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    pad,
    sending,
    status_report,
    id_inserted,
    id_bounty_info,
    picking,
  } = data;
  const in_text = "Приветствуем, драгоценный сотрудник.";
  const out_text = "Для начала работы вставьте вашу ID-карту в консоль.";
  return (
    <Window
      width={600}
      height={300}>
      <Window.Content scrollable>
        <Flex>
          <Flex.Item>
            <NoticeBox
              color={!id_inserted ? 'default': 'blue'}>
              {id_inserted ? in_text : out_text}
            </NoticeBox>
            <Section
              title="Платформа"
              buttons={(
                <>
                  <Button
                    icon={"sync"}
                    tooltip={"Проверить"}
                    disabled={!pad || !id_inserted}
                    onClick={() => act('recalc')} />
                  <Button
                    icon={sending ? 'times' : 'arrow-up'}
                    tooltip={sending ? "Отменить" : "Отправить"}
                    selected={sending}
                    disabled={!pad || !id_inserted}
                    onClick={() => act(sending ? 'stop' : 'send')} />
                  <Button
                    icon={id_bounty_info ? 'recycle' : 'pen'}
                    color={id_bounty_info ? 'green' : 'default'}
                    tooltip={id_bounty_info ? "Заменить" : "Новый"}
                    disabled={!id_inserted}
                    onClick={() => act('bounty')} />
                  <Button
                    icon={'download'}
                    content={"Изъять"}
                    disabled={!id_inserted}
                    onClick={() => act('eject')} />
                </>
              )}>
              <LabeledList>
                <LabeledList.Item
                  label="Состояние"
                  color={pad ? "good" : "bad"}>
                  {pad ? "Подключена" : "Не найдена"}
                </LabeledList.Item>
                <LabeledList.Item label="Сообщение">
                  {status_report}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {picking ? <BountyPickBox /> : <BountyTextBox />}
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const BountyTextBox = (props, context) => {
  const { data } = useBackend(context);
  const {
    id_bounty_info,
    id_bounty_value,
    id_bounty_num,
  } = data;
  const na_text = "Нет описания, получите новый заказ.";
  return (
    <Section title="Информация о заказе">
      <LabeledList>
        <LabeledList.Item label="Описание">
          {id_bounty_info ? id_bounty_info : na_text}
        </LabeledList.Item>
        <LabeledList.Item label="Количество">
          {id_bounty_info ? id_bounty_num : "N/A"}
        </LabeledList.Item>
        <LabeledList.Item label="Ценность">
          {id_bounty_info ? id_bounty_value : "N/A"}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const BountyPickBox = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    id_bounty_names,
    id_bounty_values,
  } = data;
  return (
    <Section
      title="Пожалуйста, выберите заказ:"
      textAlign="center">
      <Flex wrap>
        <Flex.Item
          shrink={0}
          grow={0.5}>
          <Button
            fluid
            icon="check"
            color="green"
            content={id_bounty_names[0]}
            onClick={() => act('pick', { 'value': 1 })}>
            <Box fontSize="14px">
              Доля: {id_bounty_values[0]}
            </Box>
          </Button>
        </Flex.Item>
        <Flex.Item
          shrink={0}
          grow={0.5}
          px={1}>
          <Button
            fluid
            icon="check"
            color="green"
            content={id_bounty_names[1]}
            onClick={() => act('pick', { 'value': 2 })}>
            <Box fontSize="14px">
              Доля: {id_bounty_values[1]}
            </Box>
          </Button>
        </Flex.Item>
        <Flex.Item
          shrink={0}
          grow={0.5}>
          <Button
            fluid
            icon="check"
            color="green"
            content={id_bounty_names[2]}
            onClick={() => act('pick', { 'value': 3 })}>
            <Box fontSize="14px">
              Доля: {id_bounty_values[2]}
            </Box>
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};
