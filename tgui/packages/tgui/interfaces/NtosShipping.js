import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosShipping = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <NtosWindow
      width={450}
      height={390}>
      <NtosWindow.Content scrollable>
        <Section
          title="Центр доставки NTOS."
          buttons={(
            <Button
              icon="eject"
              content="Изъять ID"
              onClick={() => act('ejectid')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Пользователь">
              {data.current_user || "N/A"}
            </LabeledList.Item>
            <LabeledList.Item label="Вставленная карта">
              {data.card_owner || "N/A"}
            </LabeledList.Item>
            <LabeledList.Item label="Доступно бумаги">
              {data.has_printer ? data.paperamt : "N/A"}
            </LabeledList.Item>
            <LabeledList.Item label="Прибыль при продаже">
              {data.barcode_split}%
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Опции доставки">
          <Box>
            <Button
              icon="id-card"
              tooltip="Текущая ID-карта станет текущим пользователем."
              tooltipPosition="right"
              disabled={!data.has_id_slot}
              onClick={() => act('selectid')}
              content="Выставить текущий ID" />
          </Box>
          <Box>
            <Button
              icon="print"
              tooltip="Распечатать штрих-код для использования на товаре в упаковке."
              tooltipPosition="right"
              disabled={!data.has_printer || !data.current_user}
              onClick={() => act('print')}
              content="Распечатать штрих-код" />
          </Box>
          <Box>
            <Button
              icon="tags"
              tooltip="Установите, какую прибыль вы хотите получить от своего пакета."
              tooltipPosition="right"
              onClick={() => act('setsplit')}
              content="Установить маржу" />
          </Box>
          <Box>
            <Button
              icon="sync-alt"
              content="Сбросить ID"
              onClick={() => act('resetid')} />
          </Box>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
