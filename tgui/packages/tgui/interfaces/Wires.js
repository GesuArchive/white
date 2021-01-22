import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, NoticeBox } from '../components';
import { Window } from '../layouts';

export const Wires = (props, context) => {
  const { act, data } = useBackend(context);
  const { proper_name } = data;
  const wires = data.wires || [];
  const statuses = data.status || [];
  return (
    <Window
      width={450}
      height={150
        + (wires.length * 30)
        + (!!proper_name && 30)}>
      <Window.Content>
        {(!!proper_name && (
          <NoticeBox textAlign="center">
            {proper_name} Настройка проводов
          </NoticeBox>
        ))}
        <Section>
          <LabeledList>
            {wires.map(wire => (
              <LabeledList.Item
                key={wire.color}
                className="candystripe"
                label={wire.wname}
                labelColor={wire.color}
                color={wire.color}
                buttons={(
                  <>
                    <Button
                      content={wire.cut ? 'Паять' : 'Кусать'}
                      onClick={() => act('cut', {
                        wire: wire.color,
                      })} />
                    <Button
                      content="Пульс"
                      onClick={() => act('pulse', {
                        wire: wire.color,
                      })} />
                    <Button
                      content={wire.attached ? 'Отсо.' : 'Прис.'}
                      onClick={() => act('attach', {
                        wire: wire.color,
                      })} />
                  </>
                )}>
                {!!wire.wire && (
                  <i>
                    ({wire.wire})
                  </i>
                )}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {!!statuses.length && (
          <Section>
            {statuses.map(status => (
              <Box key={status}>
                {status}
              </Box>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
