import { useBackend } from '../backend';
import { Icon, Section } from '../components';
import { Window } from '../layouts';

const changelogIcons = {
  "+": {
    type: "plus",
  },
  "-": {
    type: "minus",
  },
  "=": {
    type: "wrench",
  },
  "a": {
    type: "cross",
  },
};

export const Changelog = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    all_changelog = [],
  } = data;
  return (
    <Window
      title="Список изменений"
      width={400}
      height={700}>
      <Window.Content scrollable>
        {all_changelog.reverse().map(entry => (
          <Section
            title={new Date(parseInt(entry.timestamp, 10) * 1000)
              .toLocaleDateString("ru-RU") + " - " + entry.author}
            key={entry.timestamp}>
            <Icon
              name={changelogIcons[entry.content.substring(0, 1)].type}
              rotation={0}
              spin={0} />
            {entry.content.substring(1)}
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
