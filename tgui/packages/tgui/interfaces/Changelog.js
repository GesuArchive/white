import { useBackend } from '../backend';
import { Icon, Section } from '../components';
import { Window } from '../layouts';

const changelogIcons = {
  '+': {
    desc: 'Добавлено',
    type: 'plus',
  },
  '-': {
    desc: 'Удалено',
    type: 'minus',
  },
  '=': {
    desc: 'Исправлено',
    type: 'wrench',
  },
  'a': {
    desc: 'Сломано',
    type: 'cross',
  },
};

export const Changelog = (props, context) => {
  const { data } = useBackend(context);
  const all_changelog = Object.values(data.all_changelog).reverse();
  return (
    <Window title="Список изменений" theme="hackerman" width={400} height={700}>
      <Window.Content scrollable>
        {all_changelog.map((entry) => {
          const splitted_clog = entry.content.split('\n');
          return (
            <Section
              title={
                new Date(
                  parseInt(entry.timestamp, 10) * 1000
                ).toLocaleDateString('ru-RU') +
                ' - ' +
                entry.author
              }
              key={entry.timestamp}>
              {splitted_clog.map((es) => {
                const clog_icon =
                  es.substring(0, 1) in changelogIcons
                    ? changelogIcons[es.substring(0, 1)].type
                    : null;
                return (
                  <div key={es}>
                    <Icon
                      name={clog_icon ? clog_icon : 'cross'}
                      rotation={0}
                      spin={0}
                    />
                    {clog_icon ? es.substring(1) : es}
                  </div>
                );
              })}
            </Section>
          );
        })}
      </Window.Content>
    </Window>
  );
};
