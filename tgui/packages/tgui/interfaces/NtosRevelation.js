import { Section, Button, LabeledList } from '../components';
import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export const NtosRevelation = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <NtosWindow
      width={400}
      height={250}
      theme="syndicate">
      <NtosWindow.Content>
        <Section>
          <Button.Input
            fluid
            content="Обфусцировать имя..."
            onCommit={(e, value) => act('PRG_obfuscate', {
              new_name: value,
            })}
            mb={1} />
          <LabeledList>
            <LabeledList.Item
              label="Состояние бекдура"
              buttons={(
                <Button
                  content={data.armed ? 'ГОТОВ' : 'НЕ ГОТОВ'}
                  color={data.armed ? 'bad' : 'average'}
                  onClick={() => act('PRG_arm')} />
              )} />
          </LabeledList>
          <Button
            fluid
            bold
            content="АКТИВИРОВАТЬ"
            textAlign="center"
            color="bad"
            disabled={!data.armed} />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
