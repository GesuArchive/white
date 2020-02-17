import { map } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs } from '../components';

export const NaniteProgramHub = props => {
  const { act, data } = useBackend(props);
  const {
    detail_view,
    disk,
    has_disk,
    has_program,
    programs = {},
  } = data;
  return (
    <Fragment>
      <Section
        title="Программный диск"
        buttons={(
          <Fragment>
            <Button
              icon="eject"
              content="Изъять"
              onClick={() => act('eject')} />
            <Button
              icon="minus-circle"
              content="Удалить программу"
              onClick={() => act('clear')} />
          </Fragment>
        )}>
        {has_disk ? (
          has_program ? (
            <LabeledList>
              <LabeledList.Item label="Имя программы">
                {disk.name}
              </LabeledList.Item>
              <LabeledList.Item label="Описание">
                {disk.desc}
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <NoticeBox>
              Нет программ
            </NoticeBox>
          )
        ) : (
          <NoticeBox>
            Вставить диск
          </NoticeBox>
        )}
      </Section>
      <Section
        title="Программы"
        buttons={(
          <Fragment>
            <Button
              icon={detail_view ? 'info' : 'list'}
              content={detail_view ? 'Детально' : 'Компактно'}
              onClick={() => act('toggle_details')} />
            <Button
              icon="sync"
              content="Синхронизировать"
              onClick={() => act('refresh')} />
          </Fragment>
        )}>
        {programs !== null ? (
          <Tabs vertical>
            {map((cat_contents, category) => {
              const progs = cat_contents || [];
              // Backend was sending stupid data that would have been
              // annoying to fix
              const tabLabel = category.substring(0, category.length - 8);
              return (
                <Tabs.Tab
                  key={category}
                  label={tabLabel}>
                  {detail_view ? (
                    progs.map(program => (
                      <Section
                        key={program.id}
                        title={program.name}
                        level={2}
                        buttons={(
                          <Button
                            icon="download"
                            content="Загрузить"
                            disabled={!has_disk}
                            onClick={() => act('download', {
                              program_id: program.id,
                            })} />
                        )}>
                        {program.desc}
                      </Section>
                    ))
                  ) : (
                    <LabeledList>
                      {progs.map(program => (
                        <LabeledList.Item
                          key={program.id}
                          label={program.name}
                          buttons={(
                            <Button
                              icon="download"
                              content="Загрузить"
                              disabled={!has_disk}
                              onClick={() => act('download', {
                                program_id: program.id,
                              })} />
                          )} />
                      ))}
                    </LabeledList>
                  )}
                </Tabs.Tab>
              );
            })(programs)}
          </Tabs>
        ) : (
          <NoticeBox>
            Программы нанитов не исследованы.
          </NoticeBox>
        )}
      </Section>
    </Fragment>
  );
};
