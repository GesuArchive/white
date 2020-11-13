import { Fragment } from 'inferno';
import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, Dropdown, LabeledControls, Box, Knob, Section, Tabs, Flex } from '../components';
import { Window } from '../layouts';

export const BoomBox = (props, context) => {
  const { act, data } = useBackend(context);
  const songs = flow([
    sortBy(
      song => song.name),
  ])(data.songs || []);
  const [
    selectedCategory,
    setSelectedCategory,
  ] = useLocalState(context, 'category', songs.category);
  return (
    <Window
      width={520}
      height={500}
      resizable>
      <Window.Content>
          <Flex.Item>
            <Tabs vertical>
              {songs.map(thing => (
                <Tabs.Tab
                  key={thing.short_name}
                  selected={thing.short_name === selectedCategory}
                  onClick={() => setSelectedCategory(thing.short_name)}>
                  {thing.short_name} ({thing.items?.length || 0})
                </Tabs.Tab>
              ))}
            </Tabs>
          </Flex.Item>
        <Section
          title="Проигрыватель"
          buttons={(
            <Fragment>
              <Button
                icon={data.active ? 'pause' : 'play'}
                content={data.active ? 'СТОП' : 'СТАРТ'}
                disabled={!data.curtrack}
                onClick={() => act('toggle')} />
              {!data.disk || (
                <Button
                  content="Изъять диск"
                  disabled={!data.disk}
                  onClick={() => act('eject')} />
              )}
            </Fragment>
          )}>

          <LabeledList>
            <LabeledList.Item label="Трек">
              <Dropdown
                overflow-y="scroll"
                width="380px"
                options={songs.map(song => song.name)}
                disabled={data.active}
                selected={data.curtrack || "Выберите трек"}
                onSelected={value => act('select_track', {
                  track: value,
                })} />
            </LabeledList.Item>

            {!data.curlenght || (
              <LabeledList.Item label="Длительность">
                {data.curlenght}
              </LabeledList.Item>
            )}

            <LabeledList.Item label="Объемный звук">
              <Button
                content={data.env ? "ВКЛ" : "ВЫКЛ"}
                onClick={() => act('env')} />
            </LabeledList.Item>

          </LabeledList>
        </Section>
        <Section title="Переключатели">
          <LabeledControls justify="center">
            <LabeledControls.Item label="Громкость">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={data.volume >= 50 ? 'red' : 'green'}
                  value={data.volume}
                  unit="%"
                  minValue={0}
                  maxValue={100}
                  step={1}
                  stepPixelSize={1}
                  onDrag={(e, value) => act('change_volume', {
                    volume: value,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() => act('change_volume', {
                    volume: 0,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() => act('change_volume', {
                    volume: 100,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() => act('change_volume', {
                    volume: 20,
                  })} />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
