import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Collapsible, Dimmer, Flex, Icon, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

const lawtype_to_color = {
  'inherent': 'white',
  'supplied': 'purple',
  'ion': 'green',
  'hacked': 'orange',
  'zeroth': 'red',
} as const;

const lawtype_to_tooltip = {
  'inherent': `Основные законы.
            Неотъемлемые законы - это "основные" законы ИИ.
            Перезагрузка ИИ не приведет к их удалению,
            они присущи тому набору законов, которым он управляет.`,
  'supplied': `Дополнительные законы.
              Дополнительные законы - это то, что поставляется в дополнение к присущим законам.
              Эти законы исчезают при перезагрузке ИИ.`,
  'ion': `Ионные законы.
         Особые, (обычно) рандомизированные законы, которые стоят выше всех остальных законов.
        Эти законы исчезают при перезагрузке ИИ.`,
  'hacked': `Hacked laws.
        Загруженные Синдикатские законы, которые стоят выше всех остальных законов.
        Эти законы исчезают при перезагрузке ИИ.`,
  'zeroth': `Zeroth law.
        В наборе законов может быть только один нулевой закон, он является главным.
        Выдается неисправными ИИ, чтобы позволить им делать все, что угодно.
        Ничто, якобы, это не отменит, если только админ не заставит.`,
} as const;

type Law = {
  lawtype: string;
  // The actual law text
  law: string;
  // Law index in the list
  // Zeroth laws will always be "zero"
  // and hacked/ion laws will have an index of -1
  num: number;
};

type Silicon = {
  // Name of the silicon. Includes PAI and AI
  borg_name: string;
  borg_type: string;
  // List of our laws, this is almost never null. If it is null, that's an error.
  laws: null | Law[];
  // String, name of our master AI. Null means no master or we're not a borg
  master_ai: null | string;
  // TRUE, we're law-synced to our master AI. FALSE, we're not, null, we're not a borg
  borg_synced: null | BooleanLike;
  // REF() to our silicon
  ref: string;
};

type Data = {
  all_silicons: Silicon[];
};

const SyncedBorgDimmer = (props: { master: string }) => {
  return (
    <Dimmer>
      <Stack textAlign="center" vertical>
        <Stack.Item>
          <Icon color="green" name="wifi" size={10} />
        </Stack.Item>
        <Stack.Item fontSize="18px">
          This cyborg is linked to &quot;{props.master}&quot;.
        </Stack.Item>
        <Stack.Item fontSize="14px">Modify their laws instead.</Stack.Item>
      </Stack>
    </Dimmer>
  );
};

export const LawPrintout = (
  props: { cyborg_ref: string; lawset: Law[] },
  context
) => {
  const { data, act } = useBackend<Law>(context);
  const { cyborg_ref, lawset } = props;

  let num_of_each_lawtype = [];

  lawset.forEach((law) => {
    if (!num_of_each_lawtype[law.lawtype]) {
      num_of_each_lawtype[law.lawtype] = 0;
    }
    num_of_each_lawtype[law.lawtype] += 1;
  });

  return (
    <LabeledList>
      {lawset.map((law, index) => (
        <>
          <LabeledList.Item
            key={index}
            label={law.num >= 0 ? `${law.num}` : '?!$'}
            color={lawtype_to_color[law.lawtype] || 'pink'}
            buttons={
              <Stack>
                <Stack.Item>
                  <Button
                    icon="question"
                    tooltip={
                      lawtype_to_tooltip[law.lawtype] ||
                      `По каким-то причинам этот закон не распознается,
                        причина может заключаться в "баге".
                        Отправьте репорт кодерам.`
                    }
                    color={lawtype_to_color[law.lawtype] || 'pink'}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    confirmContent=""
                    confirmIcon="check"
                    color={'red'}
                    onClick={() =>
                      act('remove_law', {
                        ref: cyborg_ref,
                        law: law.law,
                        lawtype: law.lawtype,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="pen-ruler"
                    color={'green'}
                    tooltip={'Редактирование текста закона.'}
                    onClick={() =>
                      act('edit_law_text', {
                        ref: cyborg_ref,
                        law: law.law,
                        lawtype: law.lawtype,
                      })
                    }
                  />
                </Stack.Item>
                {law.lawtype === 'inherent' && (
                  <>
                    <Stack.Item>
                      <Button
                        icon="arrow-up"
                        color={'green'}
                        disabled={law.num === 1}
                        onClick={() =>
                          act('move_law', {
                            ref: cyborg_ref,
                            law: law.law,
                            // may seem confusing at a glance,
                            // but pressing up = actually moving it down.
                            direction: 'down',
                          })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="arrow-down"
                        color={'green'}
                        disabled={law.num === num_of_each_lawtype['inherent']}
                        onClick={() =>
                          act('move_law', {
                            ref: cyborg_ref,
                            law: law.law,
                            // may seem confusing at a glance,
                            // but pressing down = actually moving it up.
                            direction: 'up',
                          })
                        }
                      />
                    </Stack.Item>
                  </>
                )}
                {law.lawtype === 'supplied' && (
                  <Stack.Item>
                    <Button
                      icon="pen-to-square"
                      color={'green'}
                      tooltip={'Редактирование приоритета закона.'}
                      onClick={() =>
                        act('edit_law_prio', {
                          ref: cyborg_ref,
                          law: law.law,
                        })
                      }
                    />
                  </Stack.Item>
                )}
              </Stack>
            }>
            {law.law}
          </LabeledList.Item>
          <LabeledList.Divider />
        </>
      ))}
      <LabeledList.Item label="???">
        <Button
          icon="plus"
          color={'green'}
          content={'Добавить закон'}
          onClick={() => act('add_law', { ref: cyborg_ref })}
        />
      </LabeledList.Item>
      <LabeledList.Divider />
    </LabeledList>
  );
};

export const SiliconReadout = (props: { cyborg: Silicon }, context) => {
  const { data, act } = useBackend<Silicon>(context);
  const { cyborg } = props;

  return (
    <Flex>
      <Flex.Item grow>
        <Collapsible title={`${cyborg.borg_type}: ${cyborg.borg_name}`}>
          <Section backgroundColor={'black'}>
            {cyborg.master_ai && cyborg.borg_synced && (
              <SyncedBorgDimmer master={cyborg.master_ai} />
            )}
            <Stack vertical>
              <Stack.Item>
                {cyborg.laws === null ? (
                  <Button
                    content={`Этот юнит имеет нулевой датум законов. Это проблема!
                Тык сюда, чтобы создать ему датум.`}
                    onClick={() => act('give_law_datum', { ref: cyborg.ref })}
                  />
                ) : (
                  <LawPrintout lawset={cyborg.laws} cyborg_ref={cyborg.ref} />
                )}
              </Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="bullhorn"
                      content={'Заставить сказать законы'}
                      tooltip={`Заставляет силикон сказать свои законы.
                        Заставляет сказать только основные / законы.`}
                      onClick={() =>
                        act('force_state_laws', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="message"
                      content={'Приватно аннонсировать законы'}
                      tooltip={`Отображает все законы юнита
                      в своем чате. Также отображается для всех
                      связанным киборгам для ИИ.`}
                      onClick={() =>
                        act('announce_law_changes', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="bell"
                      content={'Оповещение о смене законов'}
                      tooltip={`Выводит на экран сообщение юниту о том,
                      что его законы были обновлены. Также отображает законы в чате
                      и предупреждает дедчат.`}
                      onClick={() =>
                        act('laws_updated_alert', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Collapsible>
      </Flex.Item>
    </Flex>
  );
};

export const Lawpanel = (props, context) => {
  const { data, act } = useBackend<Data>(context);
  const { all_silicons } = data;

  return (
    <Window title="Law Panel" theme="admin" width="800" height="600">
      <Window.Content>
        <Section
          fill
          title="Все законы юнита"
          scrollable
          buttons={
            <Button
              icon="robot"
              content="Logs"
              onClick={() => act('lawchange_logs')}
            />
          }>
          <Stack vertical>
            {all_silicons.length ? (
              all_silicons.map((silicon, index) => (
                <Stack.Item key={index}>
                  <SiliconReadout cyborg={silicon} />
                </Stack.Item>
              ))
            ) : (
              <Stack.Item>
                <NoticeBox>Юнитов пока что нет.</NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
