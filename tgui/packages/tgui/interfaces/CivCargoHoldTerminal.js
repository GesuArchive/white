import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Flex, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const CivCargoHoldTerminal = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    pad,
    sending,
    status_report,
    id_inserted,
    id_bounty_info,
    id_bounty_value,
    id_bounty_num,
  } = data;
  const in_text = "Приветствуем, драгоценный сотрудник.";
  const out_text = "Для начала работы вставьте вашу ID-карту в консоль.";
  return (
    <Window resizable
      width={500}
      height={375}>
      <Window.Content scrollable>
        <Flex>
          <Flex.Item>
            <NoticeBox
              color={!id_inserted ? 'default': 'blue'}>
              {id_inserted ? in_text : out_text}
            </NoticeBox>
            <Section title="Платформа">
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
            <BountyTextBox />
          </Flex.Item>
          <Flex.Item m={1}>
            <Fragment>
              <Button
                fluid
                icon={"sync"}
                content={"Проверить"}
                disabled={!pad || !id_inserted}
                onClick={() => act('recalc')} />
              <Button
                fluid
                icon={sending ? 'times' : 'arrow-up'}
                content={sending ? "Отменить" : "Отправить"}
                selected={sending}
                disabled={!pad || !id_inserted}
                onClick={() => act(sending ? 'stop' : 'send')} />
              <Button
                fluid
                icon={id_bounty_info ? 'recycle' : 'pen'}
                color={id_bounty_info ? 'green' : 'default'}
                content={id_bounty_info ? "Заменить заказ" : "Новый заказ"}
                disabled={!id_inserted}
                onClick={() => act('bounty')} />
              <Button
                fluid
                icon={'download'}
                content={"Изъять"}
                disabled={!id_inserted}
                onClick={() => act('eject')} />
            </Fragment>
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
