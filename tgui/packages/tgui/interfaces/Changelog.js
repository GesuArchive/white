import { useBackend } from '../backend';
import { LabeledList } from '../components';
import { Window } from '../layouts';

export const Changelog = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    all_changelog = [],
  } = data;
  return (
    <Window
      width={500}
      height={700}>
      <Window.Content>
        <LabeledList>
          {all_changelog.map(entry => (
            <LabeledList.Item
              label={new Date(entry.timestamp).toLocaleDateString("en-US")}
              key={entry.timestamp}>
              {entry.author}: {entry.message}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Window.Content>
    </Window>
  );
};
