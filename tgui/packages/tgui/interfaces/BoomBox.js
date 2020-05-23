import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const BoomBox = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window>
      <Window.Content>
        <Section
          title={data.name}
          buttons={(
            <Fragment>
              <Button
                icon={data.active ? 'times' : 'power-off'}
                content={data.active ? 'СТОП' : 'СТАРТ'}
                disabled={!data.curtrack}
                onClick={() => act('toggle')} />
              <Button
                content="Выбрать трек"
                onClick={() => act('select')} />
            </Fragment>
          )}>

          <LabeledList>
            <LabeledList.Item label="Трек">
              {data.curtrack ? data.curtrack : "Не выбран"}
            </LabeledList.Item>

            {!data.curlenght || (
              <LabeledList.Item label="Длительность">
                {data.curlenght}
              </LabeledList.Item>
            )}

            <LabeledList.Item label="Громкость">
              <NumberInput
                value={data.volume}
                unit="%"
                width="59px"
                minValue={0}
                maxValue={100}
                step={1}
                stepPixelSize={1}
                onChange={(e, value) => act('change_volume', {
                  volume: value,
                })} />
            </LabeledList.Item>

            <LabeledList.Item label="Объемный звук">
              <Button
                content={data.env ? "ВКЛ" : "ВЫКЛ"}
                onClick={() => act('env')} />
            </LabeledList.Item>

          </LabeledList>
        </Section>

        {!data.disk || (
          <Section title="Диск">

            <LabeledList>
              <LabeledList.Item label="Трек">
                {data.disktrack ? data.disktrack : "Отсутствует"}
              </LabeledList.Item>

              <LabeledList.Item
                buttons={
                  <Button
                    content="Изъять диск"
                    disabled={!data.disk}
                    onClick={() => act('eject')} />
                } />
            </LabeledList>

          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
