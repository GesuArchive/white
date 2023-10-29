import { useBackend } from '../backend';
import { Button, LabeledList, Section, Collapsible, Slider } from '../components';
import { Window } from '../layouts';

export const Crayon = (props, context) => {
  const { act, data } = useBackend(context);
  const capOrChanges = data.has_cap || data.can_change_colour;
  const drawables = data.drawables || [];
  const last_colours = data.last_colours || [];
  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        {!!capOrChanges && (
          <Section title="Базовое">
            <LabeledList>
              <LabeledList.Item label="Крышка">
                <Button
                  icon={data.is_capped ? 'power-off' : 'times'}
                  content={data.is_capped ? 'Есть' : 'Нет'}
                  selected={data.is_capped}
                  onClick={() => act('toggle_cap')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Цвет">
                <Button
                  content="Изменить"
                  iconColor={data.current_colour}
                  icon="stop"
                  onClick={() => act('select_colour')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Последние цвета">
                {last_colours.map((col) => {
                  return (
                    <Button
                      key={col}
                      iconColor={col}
                      icon="stop"
                      onClick={() =>
                        act('select_last_colour', {
                          col: col,
                        })
                      }
                    />
                  );
                })}
              </LabeledList.Item>
              <LabeledList.Item label="Непрозрачность">
                <Slider
                  value={data.current_alpha}
                  minValue={0}
                  maxValue={255}
                  step={1}
                  stepPixelSize={4}
                  onDrag={(e, value) =>
                    act('new_alpha', {
                      alp: value,
                    })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
        <Collapsible title="Продвинутое">
          <Section title="Шаблон">
            <LabeledList>
              {drawables.map((drawable) => {
                const items = drawable.items || [];
                return (
                  <LabeledList.Item key={drawable.name} label={drawable.name}>
                    {items.map((item) => (
                      <Button
                        key={item.item}
                        content={item.item}
                        selected={item.item === data.selected_stencil}
                        onClick={() =>
                          act('select_stencil', {
                            item: item.item,
                          })
                        }
                      />
                    ))}
                  </LabeledList.Item>
                );
              })}
            </LabeledList>
          </Section>
          <Section title="Текст">
            <LabeledList>
              <LabeledList.Item label="Текущий буффер">
                {data.text_buffer}
              </LabeledList.Item>
            </LabeledList>
            <Button content="Новый текст" onClick={() => act('enter_text')} />
          </Section>
        </Collapsible>
      </Window.Content>
    </Window>
  );
};
