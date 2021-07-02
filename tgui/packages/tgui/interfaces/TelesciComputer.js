import { useBackend } from '../backend';
import { Box, Button, Icon, NoticeBox, Slider, Dimmer, NumberInput, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const TelesciComputer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    telepad,
    power_options,
    efficiency,
    crystals,
    z_co,
    angle,
    rotation,
    power,
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
      width={374}
      height={472}>
      {!!teleporting && (
        <Dimmer fontSize="24px">
          <Icon name="cog" spin={1} />
          {' Телепортация: '}{timedata}{' с.'}
        </Dimmer>
      )}
      <Window.Content>
        {telepad && (
          <Section
            title="Управление"
            buttons={(
              <>
                <Button
                  icon="eject"
                  tooltip="Изъять кристаллы"
                  onClick={() => act('eject')} />
                <Button
                  icon="sync"
                  tooltip="Перекалибровать"
                  color="yellow"
                  onClick={() => act('recal')} />
                <Button
                  icon="arrow-up"
                  content="Отправить"
                  color="green"
                  onClick={() => act('send')} />
                <Button
                  icon="arrow-down"
                  content="Принять"
                  color="blue"
                  onClick={() => act('receive')} />
              </>
            )}>
            <LabeledList>
              <LabeledList.Item label="Подъём">
                <Slider
                  value={angle}
                  unit="°"
                  minValue={1}
                  maxValue={90}
                  step={1}
                  stepPixelSize={5}
                  onDrag={(e, value) => act('setangle', {
                    newangle: value,
                  })} />
              </LabeledList.Item>
              <LabeledList.Item label="Поворот">
                <Slider
                  value={rotation}
                  unit="°"
                  minValue={0}
                  maxValue={360}
                  step={1}
                  stepPixelSize={1}
                  onDrag={(e, value) => act('setrotation', {
                    newrotation: value,
                  })} />
              </LabeledList.Item>
              <LabeledList.Item label="Сила">
                {power_options.map(opt => (
                  <Button
                    key={opt}
                    content={opt}
                    disabled={opt > (crystals * 5) * efficiency}
                    color={opt === power ? 'green' : null}
                    onClick={() => act('setpower', {
                      newpower: opt,
                    })} />
                ))}
              </LabeledList.Item>
              <LabeledList.Item label="Сектор">
                <NumberInput
                  value={z_co}
                  minValue={1}
                  maxValue={13}
                  step={1}
                  stepPixelSize={1}
                  fluid
                  onChange={(e, value) => act('setz', {
                    newz: value,
                  })} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
        {last_tele_data && (
          <Section title="Координаты консоли">
            <Box
              fontSize="48px"
              textAlign="center">
              X:{src_x} Y:{src_y}
            </Box>
          </Section>
        )}
        {inserted_gps && (
          <Section
            title="GPS Маячок"
            buttons={(
              <Button
                icon="eject"
                content="Изъять"
                tooltip="Я серьёзно не знаю зачем он нужен. Напишите в Баги, если есть идеи."
                tooltipPosition="left"
                onClick={() => act('ejectGPS')} />
            )}>
            {inserted_gps}
          </Section>
        )}
        <Section
          title="Последнее сообщение">
          <NoticeBox>
            {temp_msg}
          </NoticeBox>
        </Section>
      </Window.Content>
    </Window>
  );
};
