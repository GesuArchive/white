import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, Knob, Section, Tabs, Flex, Table } from '../components';
import { Window } from '../layouts';

export const BoomBox = (props, context) => {
  const { act, data } = useBackend(context);
  const songs = Object.values(data.songs);
  const [
    selectedCategory,
    setSelectedCategory,
  ] = useLocalState(context, 'category', songs[0]?.name);
  const selectedCategorySel = songs.find(track => {
    return track.name === selectedCategory;
  });
  return (
    <Window
      width={525}
      height={650}
      theme="ntos">
      <Window.Content scrollable>
        <Section
          title="Текущий трек"
          buttons={(
            <Fragment>
              <Button
                icon={data.active ? 'pause' : 'play'}
                content={data.active ? 'СТОП' : 'СТАРТ'}
                disabled={!data.curtrack}
                onClick={() => act('toggle')} />
              <Button
                icon="deaf"
                content={data.env ? "ДИНАМИКА" : "СТАТИКА"}
                onClick={() => act('env')} />
              {!data.disk || (
                <Button
                  content="Изъять диск"
                  disabled={!data.disk}
                  onClick={() => act('eject')} />
              )}
            </Fragment>
          )}>
          <Flex>
            <Flex.Item grow={1} basis={0} fontSize="24px">
              <marquee
                behavior="scroll"
                direction="right">
                {data.curtrack} - {data.curlength}
              </marquee>
            </Flex.Item>
            <Flex.Item ml={2} mr={1}>
              <Knob
                size={1.0}
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
            </Flex.Item>
          </Flex>
        </Section>
        <Section title="Плейлист">
          <Flex>
            <Flex.Item ml={-1} mr={1}>
              <Tabs vertical>
                {songs.map(genre => (
                  <Tabs.Tab
                    key={genre.name}
                    selected={genre.name === selectedCategory}
                    onClick={() => setSelectedCategory(genre.name)}>
                    {genre.name} ({genre.tracks?.length || 0})
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Flex.Item>
            <Flex.Item grow={1} ml={1} basis={0}>
              <Table>
                {selectedCategorySel?.tracks.map(track => {
                  return (
                    <Table.Row
                      key={track.short_name}
                      className="candystripe">
                      <Table.Cell>
                        {track.length_t} - {track.short_name}
                      </Table.Cell>
                      <Table.Cell
                        collapsing
                        textAlign="right">
                        <Button
                          fluid
                          icon={data.curtrack === track.short_name ? 'play' : 'eject'}
                          disabled={(data.curtrack === track.short_name)
                            || data.active}
                          onClick={() => act('select_track', {
                            track: track.name,
                          })} />
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
