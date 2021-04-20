import { useBackend } from '../backend';
import { Button, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const InfraredEmitter = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    on,
    visible,
  } = data;
  return (
    <Window
      width={225}
      height={110}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Состояние">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'Вкл' : 'Выкл'}
                selected={on}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Видимость">
              <Button
                icon={visible ? 'eye' : 'eye-slash'}
                content={visible ? 'Пиу' : 'Не пиу'}
                selected={visible}
                onClick={() => act('visibility')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
