import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const SatelliteControl = (props, context) => {
  const { act, data } = useBackend(context);
  const satellites = data.satellites || [];
  return (
    <Window
      width={400}
      height={505}>
      <Window.Content>
        {data.meteor_shield && (
          <Section>
            <LabeledList>
              <LabeledList.Item label="Покрытие">
                <ProgressBar
                  value={data.meteor_shield_coverage
                    / data.meteor_shield_coverage_max}
                  content={100 * data.meteor_shield_coverage
                    / data.meteor_shield_coverage_max + '%'}
                  ranges={{
                    good: [1, Infinity],
                    average: [0.30, 1],
                    bad: [-Infinity, 0.30],
                  }} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
        <Section
          title="Управление"
          buttons={(
            <Button.Confirm
              icon="forward"
              content="ПЕРЕКЛЮЧИТЬ ВСЕ"
              onClick={() => act('toggle_all')} />
          )}>
          <Box mr={-1}>
            {satellites.map(satellite => (
              <Button.Checkbox
                key={satellite.id}
                checked={satellite.active}
                content={"#" + satellite.id + " " + satellite.mode}
                onClick={() => act('toggle', {
                  id: satellite.id,
                })}
              />
            ))}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
