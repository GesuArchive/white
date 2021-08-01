import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const PortableTurret = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    silicon_user,
    locked,
    on,
    check_weapons,
    neutralize_criminals,
    neutralize_all,
    neutralize_unidentified,
    neutralize_nonmindshielded,
    neutralize_cyborgs,
    neutralize_heads,
    manual_control,
    allow_manual_control,
    lasertag_turret,
  } = data;
  return (
    <Window
      width={420}
      height={lasertag_turret ? 120 : 318}>
      <Window.Content>
        <NoticeBox>
          Проведите ID-картой для {locked ? 'раз' : ''}блокировки интерфейса.
        </NoticeBox>
        <>
          <Section>
            <LabeledList>
              <LabeledList.Item
                label="Состояние"
                buttons={!lasertag_turret && (!!allow_manual_control
                  || (!!manual_control && !!silicon_user)) && (
                  <Button
                    icon={manual_control ? "wifi" : "terminal"}
                    content={manual_control
                      ? "Управляется удалённо"
                      : "Ручное управление"}
                    disabled={manual_control}
                    color="bad"
                    onClick={() => act('manual')} />
                )}>
                <Button
                  icon={on ? 'power-off' : 'times'}
                  content={on ? 'ВКЛ' : 'ВЫКЛ'}
                  selected={on}
                  disabled={locked}
                  onClick={() => act('power')} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          {!lasertag_turret && (
            <Section
              title="Выбор целей"
              buttons={(
                <Button.Checkbox
                  checked={!neutralize_heads}
                  content="Игнорировать командование"
                  disabled={locked}
                  onClick={() => act('shootheads')} />
              )}>
              <Button.Checkbox
                fluid
                checked={neutralize_all}
                content="Не СБ и не Командование"
                disabled={locked}
                onClick={() => act('shootall')} />
              <Button.Checkbox
                fluid
                checked={check_weapons}
                content="Оружие"
                disabled={locked}
                onClick={() => act('authweapon')} />
              <Button.Checkbox
                fluid
                checked={neutralize_unidentified}
                content="Ксеносы"
                disabled={locked}
                onClick={() => act('checkxenos')} />
              <Button.Checkbox
                fluid
                checked={neutralize_nonmindshielded}
                content="Нет защиты разума"
                disabled={locked}
                onClick={() => act('checkloyal')} />
              <Button.Checkbox
                fluid
                checked={neutralize_criminals}
                content="В розыске"
                disabled={locked}
                onClick={() => act('shootcriminals')} />
              <Button.Checkbox
                fluid
                checked={neutralize_cyborgs}
                content="Киборги"
                disabled={locked}
                onClick={() => act('shootborgs')} />
            </Section>
          )}
        </>
      </Window.Content>
    </Window>
  );
};
