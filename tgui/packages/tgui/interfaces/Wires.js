import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';

export const Wires = props => {
  const { act, data } = useBackend(props);
  const wires = data.wires || [];
  const statuses = data.status || [];
  return (
    <Fragment>
      <Section>
        <LabeledList>
          {wires.map(wire => (
            <LabeledList.Item
              key={wire.color}
              className="candystripe"
              label={wire.color}
              labelColor={wire.color}
              color={wire.color}
              buttons={(
                <Fragment>
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
                    content={wire.attached ? 'Отсоед.' : 'Подсоед.'}
                    onClick={() => act('attach', {
                      wire: wire.color,
                    })} />
                </Fragment>
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
    </Fragment>
  );
};
