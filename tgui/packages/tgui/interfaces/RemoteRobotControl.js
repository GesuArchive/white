import { decodeHtmlEntities } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const RemoteRobotControl = (props, context) => {
  return (
    <Window
      title="Удалённое управление роботами"
      width={500}
      height={500}>
      <Window.Content scrollable>
        <RemoteRobotControlContent />
      </Window.Content>
    </Window>
  );
};

export const RemoteRobotControlContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    robots = [],
  } = data;
  if (!robots.length) {
    return (
      <Section>
        <NoticeBox textAlign="center">
          Не обнаружено роботов
        </NoticeBox>
      </Section>
    );
  }
  return robots.map(robot => {
    return (
      <Section
        key={robot.ref}
        title={robot.name + " (" + robot.model + ")"}
        buttons={(
          <>
            <Button
              icon="tools"
              content="Интерфейс"
              onClick={() => act('interface', {
                ref: robot.ref,
              })} />
            <Button
              icon="phone-alt"
              content="Вызвать"
              onClick={() => act('callbot', {
                ref: robot.ref,
              })} />
          </>
        )}>
        <LabeledList>
          <LabeledList.Item label="Состояние">
            <Box inline color={decodeHtmlEntities(robot.mode) === "Inactive"
              ? 'bad'
              : decodeHtmlEntities(robot.mode) === "Idle"
                ? 'average'
                : 'good'}>
              {decodeHtmlEntities(robot.mode)}
            </Box>
            {' '}
            {robot.hacked && (
              <Box inline color="bad">
                (ВЗЛОМАН)
              </Box>
            ) || "" }
          </LabeledList.Item>
          <LabeledList.Item label="Местоположение">
            {robot.location}
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  });
};
