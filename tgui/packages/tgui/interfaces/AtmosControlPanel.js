import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Table } from '../components';
import { Window } from '../layouts';

export const AtmosControlPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const groups = flow([
    map((group, i) => ({
      ...group,
      // Generate a unique id
      id: group.area + i,
    })),
    sortBy(group => group.id),
  ])(data.excited_groups);
  return (
    <Window
      title="SSAir Control Panel"
      width={900}
      height={500}
      resizable>
      <Section m={1}>
        <Flex
          justify="space-between"
          align="baseline">
          <Flex.Item>
            <Button
              onClick={() => act('toggle-freeze')}
              color={data.frozen === 1 ? 'good' : 'bad'}>
              {data.frozen === 1
                ? 'Freeze Subsystem'
                : 'Unfreeze Subsystem'}
            </Button>
          </Flex.Item>
          <Flex.Item>
            Fire Cnt: {data.fire_count}
          </Flex.Item>
          <Flex.Item>
            Active Turfs: {data.active_size}
          </Flex.Item>
          <Flex.Item>
            Hotspots: {data.hotspots_size}
          </Flex.Item>
          <Flex.Item>
            Superconductors: {data.conducting_size}
          </Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              checked={data.showing_user}
              onClick={() => act('toggle_user_display')}>
              Personal View
            </Button.Checkbox>
          </Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              checked={data.show_all}
              onClick={() => act('toggle_show_all')}>
              Display all
            </Button.Checkbox>
          </Flex.Item>
        </Flex>
      </Section>
    </Window>
  );
};
