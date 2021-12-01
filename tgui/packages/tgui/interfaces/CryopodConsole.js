import { useBackend } from '../backend';
import { Stack, Button, Section, NoticeBox, LabeledList, Collapsible } from '../components';
import { Window } from '../layouts';

export const CryopodConsole = (props, context) => {
  const { data } = useBackend(context);
  const { account_name, allow_items } = data;

  const welcomeTitle = `Привет, ${account_name || '[REDACTED]'}!`;

  return (
    <Window title="Консоль криокамер" width={400} height={480}>
      <Window.Content>
        <Stack vertical>
          <Section title={welcomeTitle}>
            Эта автоматизированная система сохранит ваше тело надёжно.
          </Section>
          <CrewList />
          {!!allow_items && <ItemList />}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const CrewList = (props, context) => {
  const { data } = useBackend(context);
  const { frozen_crew } = data;

  return (
    <Collapsible title="Хранилище экипажа">
      {!frozen_crew.length ? (
        <NoticeBox>Внутри никого нет!</NoticeBox>
      ) : (
        <Section height={10} fill scrollable>
          <LabeledList>
            {frozen_crew.map((person) => (
              <LabeledList.Item key={person} label={person.name}>
                {person.job}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      )}
    </Collapsible>
  );
};

const ItemList = (props, context) => {
  const { act, data } = useBackend(context);
  const { frozen_items } = data;

  const replaceItemName = (item) => {
    let itemName = item.toString();
    if (itemName.startsWith('the')) {
      itemName = itemName.slice(4, itemName.length);
    }
    return itemName.replace(/^\w/, (c) => c.toUpperCase());
  };

  return (
    <Collapsible title="Хранилище предметов">
      {!frozen_items.length ? (
        <NoticeBox>Внутри ничего нет!</NoticeBox>
      ) : (
        <>
          <Section height={12} fill scrollable>
            <LabeledList>
              {frozen_items.map((item, index) => (
                <LabeledList.Item
                  key={item}
                  label={replaceItemName(item)}
                  buttons={
                    <Button
                      icon="arrow-down"
                      content="Drop"
                      mr={1}
                      onClick={() => act('one_item', { item: index + 1 })}
                    />
                  }
                />
              ))}
            </LabeledList>
          </Section>
          <Button
            content="Выбросить всё"
            color="red"
            onClick={() => act('all_items')}
          />
        </>
      )}
    </Collapsible>
  );
};
