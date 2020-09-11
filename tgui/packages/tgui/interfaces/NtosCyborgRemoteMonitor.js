import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosCyborgRemoteMonitor = (props, context) => {
  return (
    <NtosWindow
      width={600}
      height={800}
      resizable>
      <NtosWindow.Content scrollable>
        <NtosCyborgRemoteMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosCyborgRemoteMonitorContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    card,
    cyborgs = [],
  } = data;

  if (!cyborgs.length) {
    return (
      <NoticeBox>
        Не обнаружено киборгов.
      </NoticeBox>
    );
  }

  return (
    <Fragment>
      {!card && (
        <NoticeBox>
          Для особых прав необходима ID-карта.
        </NoticeBox>
      )}
      {cyborgs.map(cyborg => {
        return (
          <Section
            key={cyborg.ref}
            title={cyborg.name}
            buttons={(
              <Button
                icon="terminal"
                content="Отправить сообщение"
                color="blue"
                disabled={!card}
                onClick={() => act('messagebot', {
                  ref: cyborg.ref,
                })} />
            )}>
            <LabeledList>
              <LabeledList.Item label="Состояние">
                <Box color={cyborg.status
                  ? 'bad'
                  : cyborg.locked_down
                    ? 'average'
                    : 'good'}>
                  {cyborg.status
                    ? "Не отвечает"
                    : cyborg.locked_down
                      ? "Заблокирован"
                      : cyborg.shell_discon
                        ? "Стабильное/Отключен"
                        : "Стабильное"}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Заряд">
                <Box color={cyborg.charge <= 30
                  ? 'bad'
                  : cyborg.charge <= 70
                    ? 'average'
                    : 'good'}>
                  {typeof cyborg.charge === 'number'
                    ? cyborg.charge + "%"
                    : "Не найдено"}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Модуль">
                {cyborg.module}
              </LabeledList.Item>
              <LabeledList.Item label="Улучшения">
                {cyborg.upgrades}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        );
      })}
    </Fragment>
  );
};
