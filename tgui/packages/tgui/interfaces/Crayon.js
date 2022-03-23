import { useBackend } from '../backend';
import { Button, LabeledList, Section, Collapsible, Slider } from '../components';
import { Window } from '../layouts';

export const Crayon = (props, context) => {
  const { act, data } = useBackend(context);
  const capOrChanges = data.has_cap || data.can_change_colour;
  const drawables = data.drawables || [];
  const last_colors = data.last_colors || [];
  return (
    <Window
      width={600}
      height={600}>
      <Window.Content scrollable>
        {!!capOrChanges && (
          <Section title="Базовое">
            <LabeledList>
              <LabeledList.Item label="Крышка">
                <Button
                  icon={data.is_capped ? 'power-off' : 'times'}
                  content={data.is_capped ? 'Есть' : 'Нет'}
                  selected={data.is_capped}
                  onClick={() => act('toggle_cap')} />
              </LabeledList.Item>
            </LabeledList>
            <Button
              content="Выбрать новый цвет"
              onClick={() => act('select_colour')} />
            <Slider
              value={data.current_alpha}
              minValue={0}
              maxValue={255}
              step={1}
              unit={"a"}
              stepPixelSize={4}
              onDrag={(e, value) => act('select_alpha', {
                target: value,
              })} />
            {last_colors.map(col => {
              return (
                <Button
                  key={col}
                  content={col}
                  color={col}
                  onClick={() => act('select_last_colour', {
                    col: col,
                  })} />
              );
            })}
          </Section>
        )}
        <Collapsible
          title="Продвинутое">
          <Section title="Шаблон">
            <LabeledList>
              {drawables.map(drawable => {
                const items = drawable.items || [];
                return (
                  <LabeledList.Item
                    key={drawable.name}
                    label={drawable.name}>
                    {items.map(item => (
                      <Button
                        key={item.item}
                        content={item.item}
                        selected={item.item === data.selected_stencil}
                        onClick={() => act('select_stencil', {
                          item: item.item,
                        })} />
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
            <Button
              content="Новый текст"
              onClick={() => act('enter_text')} />
          </Section>
        </Collapsible>
      </Window.Content>
    </Window>
  );
};
