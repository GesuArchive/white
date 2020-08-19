import { multiline } from 'common/string';
import { useBackend } from '../backend';
import { Button, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const TOOLTIP_TEXT = multiline`
  %PERSON будет использоваться как имя.
  %RANK будет использовать как должность.
`;

export const AutomatedAnnouncement = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    arrivalToggle,
    arrival,
    newheadToggle,
    newhead,
  } = data;
  return (
    <Window
      title="Автоматизированная Система Оповещений"
      width={500}
      height={225}>
      <Window.Content>
        <Section
          title="Аннонсирование прибытия"
          buttons={(
            <Button
              icon={arrivalToggle ? 'power-off' : 'times'}
              selected={arrivalToggle}
              content={arrivalToggle ? 'Вкл' : 'Выкл'}
              onClick={() => act('ArrivalToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Сообщение"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={arrival}
                onChange={(e, value) => act('ArrivalText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Аннонсирование прибытия главы"
          buttons={(
            <Button
              icon={newheadToggle ? 'power-off' : 'times'}
              selected={newheadToggle}
              content={newheadToggle ? 'Вкл' : 'Выкл'}
              onClick={() => act('NewheadToggle')} />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Сообщение"
              buttons={(
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left" />
              )}>
              <Input
                fluid
                value={newhead}
                onChange={(e, value) => act('NewheadText', {
                  newText: value,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
