import { useBackend } from '../backend';
import { Box, Button, Divider, Flex, Grid, Input, NoticeBox, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const TelesciComputer = (props, context) => {
  const { topLevel } = props;
  const { act, data } = useBackend(context);
  const {
    telepad,
    power_options,
    efficiency,
    crystals,
    z_co,
    angle,
    rotation,
    temp_msg,
    inserted_gps,
    teleporting,
    last_tele_data,
    src_x,
    src_y,
    timedata,
  } = data;
  return (
    <Window
      width={340}
      height={545}>
      <Window.Content>
        <Section
          title = "Управление">
            {temp_msg}
            <Button
              icon="times"
              content="send"
              color="bad"
              onClick={() => act('send')} />
            <NumberInput
              value={angle}
              unit="Угол"
              minValue={1}
              maxValue={90}
              step={1}
              stepPixelSize={1}
              onChange={(e, value) => act('setangle', {
                newangle: value,
              })} />
            <NumberInput
              value={rotation}
              unit="Поворот"
              minValue={1}
              maxValue={90}
              step={1}
              stepPixelSize={1}
              onChange={(e, value) => act('setrotation', {
                newrotation: value,
              })} />
            <NumberInput
              value={power_options.length}
              unit="Сила"
              minValue={1}
              maxValue={90}
              step={1}
              stepPixelSize={1}
              onChange={(e, value) => act('setpower', {
                newpower: value,
              })} />
            <NumberInput
              value={z_co}
              unit="Сектор"
              minValue={1}
              maxValue={90}
              step={1}
              stepPixelSize={1}
              onChange={(e, value) => act('setz', {
                newz: value,
              })} />
        </Section>
      </Window.Content>
    </Window>
  )
}
