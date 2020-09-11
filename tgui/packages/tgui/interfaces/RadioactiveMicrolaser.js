import { useBackend } from '../backend';
import { Button, Box, NumberInput, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const RadioactiveMicrolaser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    irradiate,
    stealth,
    scanmode,
    intensity,
    wavelength,
    on_cooldown,
    cooldown,
  } = data;
  return (
    <Window
      title="Радиоактивный микролазер"
      width={320}
      height={335}
      theme="syndicate">
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Состояние лазера">
              <Box color={on_cooldown ? "average" : "good"}>
                {on_cooldown ? "Перезарядка" : "Готов"}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Настройки сканера">
          <LabeledList>
            <LabeledList.Item label="Облучение">
              <Button
                icon={irradiate ? 'power-off' : 'times'}
                content={irradiate ? 'ВКЛ' : 'ВЫКЛ'}
                selected={irradiate}
                onClick={() => act('irradiate')} />
            </LabeledList.Item>
            <LabeledList.Item label="Тихий режим">
              <Button
                icon={stealth ? 'eye-slash' : 'eye'}
                content={stealth ? 'ВКЛ' : 'ВЫКЛ'}
                disabled={!irradiate}
                selected={stealth}
                onClick={() => act('stealth')} />
            </LabeledList.Item>
            <LabeledList.Item label="Сканирование">
              <Button
                icon={scanmode ? 'mortar-pestle' : 'heartbeat'}
                content={scanmode ? 'Реагенты' : 'Здоровье'}
                disabled={irradiate && stealth}
                onClick={() => act('scanmode')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Настройка лазера">
          <LabeledList>
            <LabeledList.Item label="Интенсивность облучения">
              <Button
                icon="fast-backward"
                onClick={() => act('radintensity', { adjust: -5 })} />
              <Button
                icon="backward"
                onClick={() => act('radintensity', { adjust: -1 })} />
              {' '}
              <NumberInput
                value={Math.round(intensity)}
                width="40px"
                minValue={1}
                maxValue={20}
                onChange={(e, value) => {
                  return act('radintensity', {
                    target: value,
                  });
                }} />
              {' '}
              <Button
                icon="forward"
                onClick={() => act('radintensity', { adjust: 1 })} />
              <Button
                icon="fast-forward"
                onClick={() => act('radintensity', { adjust: 5 })} />
            </LabeledList.Item>
            <LabeledList.Item label="Длина волны">
              <Button
                icon="fast-backward"
                onClick={() => act('radwavelength', { adjust: -5 })} />
              <Button
                icon="backward"
                onClick={() => act('radwavelength', { adjust: -1 })} />
              {' '}
              <NumberInput
                value={Math.round(wavelength)}
                width="40px"
                minValue={0}
                maxValue={120}
                onChange={(e, value) => {
                  return act('radwavelength', {
                    target: value,
                  });
                }} />
              {' '}
              <Button
                icon="forward"
                onClick={() => act('radwavelength', { adjust: 1 })} />
              <Button
                icon="fast-forward"
                onClick={() => act('radwavelength', { adjust: 5 })} />
            </LabeledList.Item>
            <LabeledList.Item label="Перезарядка лазера">
              <Box inline bold>
                {cooldown}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
