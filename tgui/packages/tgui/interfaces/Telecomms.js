import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend } from '../backend';
import { Button, Input, LabeledList, Section, Table, NoticeBox, NumberInput, LabeledControls, Box } from '../components';
import { RADIO_CHANNELS } from '../constants';
import { Window } from '../layouts';

export const Telecomms = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    type,
    minfreq,
    maxfreq,
    frequency,
    multitool,
    multibuff,
    toggled,
    id,
    network,
    prefab,
    changefrequency,
    currfrequency,
    broadcasting,
    receiving,
  } = data;
  const linked = data.linked || [];
  const frequencies = data.frequencies || [];
  return (
    <Window
      title={id}
      width={400}
      height={600}>
      <Window.Content scrollable>
        {!multitool && (
          <NoticeBox>Используйте мультитул для внесения изменений.</NoticeBox>
        )}
        <Section title="Настройки">
          <LabeledList>
            <LabeledList.Item
              label="Энергия"
              buttons={
                <Button
                  icon={toggled ? "power-off" : "times"}
                  content={toggled ? "Вкл" : "Выкл"}
                  color={toggled ? "good" : "bad"}
                  disabled={!multitool}
                  onClick={() => act('toggle')} />
              } />
            <LabeledList.Item
              label="Идентификационное имя"
              buttons={
                <Input
                  width={13}
                  value={id}
                  onChange={(e, value) => act('id', { value })} />
              } />
            <LabeledList.Item
              label="Сеть"
              buttons={
                <Input
                  width={10}
                  value={network}
                  defaultValue={"tcommsat"}
                  onChange={(e, value) => act('network', { value })} />
              } />
            <LabeledList.Item
              label="Преднастройка"
              buttons={
                <Button
                  icon={prefab ? "check" : "times"}
                  content={prefab ? "Да" : "Нет"}
                  disabled={"Да"} />
              } />
          </LabeledList>
        </Section>
        {!!(toggled && multitool) && (
          <Box>
            {(type === 'bus') && (
              <Section title="Шина">
                <Table>
                  <Table.Row>
                    <Table.Cell>
                      Изменить частоту:
                    </Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS
                        .find(channel => channel.freq === changefrequency) && (
                        <Box
                          inline
                          color={RADIO_CHANNELS
                            .find(channel => channel.freq === changefrequency)
                            .color}
                          ml={2}>
                          [{RADIO_CHANNELS
                            .find(channel => channel
                              .freq === changefrequency).name}]
                        </Box>
                      )}
                    </Table.Cell>
                    <NumberInput
                      animate
                      unit="GHz"
                      step={0.2}
                      stepPixelSize={10}
                      minValue={minfreq / 10}
                      maxValue={maxfreq / 10}
                      value={changefrequency / 10}
                      onChange={(e, value) => act(
                        'change_freq', { value })}
                    />
                    <Button
                      icon={"times"}
                      disabled={changefrequency === 0}
                      onClick={() => act('change_freq', { value: 10001 })}
                    />
                  </Table.Row>
                </Table>
              </Section>
            )}
            {(type === 'relay') && (
              <Section title="Реле">
                <Button
                  content={"Принимающий"}
                  icon={receiving ? 'volume-up' : 'volume-mute'}
                  color={receiving ? '' : 'bad'}
                  onClick={() => act('receive')} />
                <Button
                  content={"Отправляющий"}
                  icon={broadcasting ? 'microphone' : 'microphone-slash'}
                  color={broadcasting ? '' : 'bad'}
                  onClick={() => act('broadcast')} />
              </Section>
            )}
            <Section title="Подключённые сетевые элементы">
              <Table>
                {linked.map(entry => (
                  <Table.Row key={entry.id} className="candystripe">
                    <Table.Cell bold>
                      {entry.index}. {entry.id} ({entry.name})
                    </Table.Cell>
                    {!!multitool && (
                      <Button
                        icon={"times"}
                        disabled={!multitool}
                        onClick={() => act('unlink', { value: entry.index })} />
                    )}
                  </Table.Row>
                ))}
              </Table>
            </Section>
            <Section title="Фильтрованные частоты">
              <Table>
                {frequencies.map(entry => (
                  <Table.Row key={frequencies.i} className="candystripe">
                    <Table.Cell bold>
                      {entry/10} GHz
                    </Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS
                        .find(channel => channel.freq === entry) && (
                        <Box
                          inline
                          color={RADIO_CHANNELS
                            .find(channel => channel.freq === entry)
                            .color}
                          ml={2}>
                          [{RADIO_CHANNELS
                            .find(channel => channel
                              .freq === entry).name } ]
                        </Box>
                      )}
                    </Table.Cell>
                    <Table.Cell />
                    {!!multitool && (
                      <Button
                        icon={"times"}
                        disabled={!multitool}
                        onClick={() => act('delete', { value: entry })} />
                    )}
                  </Table.Row>
                ))}
                {!!multitool && (
                  <Table.Row className="candystripe" collapsing>
                    <Table.Cell>
                      Добавить частоту
                    </Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS
                        .find(channel => channel.freq === frequency) && (
                        <Box
                          inline
                          color={RADIO_CHANNELS
                            .find(channel => channel.freq === frequency)
                            .color}
                          ml={2}>
                          [{RADIO_CHANNELS
                            .find(channel => channel
                              .freq === frequency).name}]
                        </Box>
                      )}
                    </Table.Cell>
                    <Table.Cell>
                      <NumberInput
                        animate
                        unit="GHz"
                        step={0.2}
                        stepPixelSize={10}
                        minValue={minfreq / 10}
                        maxValue={maxfreq / 10}
                        value={frequency / 10}
                        onChange={(e, value) => act(
                          "tempfreq", { value })}
                      />
                    </Table.Cell>
                    <Button
                      icon={"plus"}
                      disabled={!multitool}
                      onClick={() => act('freq')} />
                  </Table.Row>
                )}
              </Table>
            </Section>
            {!!multitool && (
              <Section title="Мультитул">
                {!!multibuff && (
                  <Box bold m={1}>
                    Текущий буфер: {multibuff}
                  </Box>
                )}
                <LabeledControls m={1}>
                  <Button
                    icon={"plus"}
                    content={"Добавить машину"}
                    disabled={!multitool}
                    onClick={() => act('buffer')} />
                  <Button
                    icon={"link"}
                    content={"Привязать"}
                    disabled={!multibuff}
                    onClick={() => act('link')} />
                  <Button
                    icon={"times"}
                    content={"Очистить"}
                    disabled={!multibuff}
                    onClick={() => act('flush')} />
                </LabeledControls>
              </Section>)}
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};
