import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const TurretControl = (props, context) => {
  const { act, data } = useBackend(context);
  const locked = data.locked && !data.siliconUser;
  const {
    enabled,
    lethal,
    shootCyborgs,
  } = data;
  return (
    <Window
      width={325}
      height={data.siliconUser ? 198 : 194}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section>
          <LabeledList>
            <LabeledList.Item label="Состояние турелей">
              <Button
                icon={enabled ? 'power-off' : 'times'}
                content={enabled ? 'Включены' : 'Отключены'}
                selected={enabled}
                disabled={locked}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Режим">
              <Button
                icon={lethal ? 'exclamation-triangle' : 'minus-circle'}
                content={lethal ? 'Летальный' : 'Останавливающий'}
                color={lethal ? "bad" : "average"}
                disabled={locked}
                onClick={() => act('mode')} />
            </LabeledList.Item>
            <LabeledList.Item label="Стрелять в киборгов">
              <Button
                icon={shootCyborgs ? 'check' : 'times'}
                content={shootCyborgs ? 'Да' : 'Нет'}
                selected={shootCyborgs}
                disabled={locked}
                onClick={() => act('shoot_silicons')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
