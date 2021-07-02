import { useBackend } from '../backend';
import { Slider, NoticeBox, Table, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const EnerNet = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      theme="scarlet"
      width={300}
      height={300}>
      <Window.Content>
        <Button
          content={data.autosell ? "АВТОПРОДАЖА ВКЛЮЧЕНА" : "АВТОПРОДАЖА ОТКЛЮЧЕНА"}
          textAlign="center"
          fontSize="18px"
          fluid
          mb={1}
          onClick={() => act('toggle_autosell')} />
        <Slider
          value={data.autosell_amount}
          unit="W"
          minValue={1}
          maxValue={10000000}
          step={100000}
          stepPixelSize={5}
          mb={1}
          onDrag={(e, value) => act('setautosellamount', {
            autosell_selected: value,
          })} />
        <Table mb={1}>
          <Table.Row header>
            <Table.Cell p={1}>
              Коил
            </Table.Cell>
            <Table.Cell p={1}>
              Запас
            </Table.Cell>
            <Table.Cell p={1}>
              Максимум
            </Table.Cell>
            <Table.Cell p={1}>
              Скорость
            </Table.Cell>
          </Table.Row>
          {data.coils.map((coil, i) => (
            <Table.Row key={i}>
              <Table.Cell p={1}>
                #{i+1}
              </Table.Cell>
              <Table.Cell p={1}>
                {coil.acc}W
              </Table.Cell>
              <Table.Cell p={1}>
                {coil.max}W
              </Table.Cell>
              <Table.Cell p={1}>
                {coil.suc}W
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
        <Button
          content="НАЙТИ КАТУШКИ"
          textAlign="center"
          fontSize="18px"
          fluid
          mb={1}
          onClick={() => act('get_coils')} />
        <NoticeBox
          fontSize="16px"
          p={1}>
          {data.price_for_one_kw} кредита за один kW
        </NoticeBox>
      </Window.Content>
    </Window>
  );
};
