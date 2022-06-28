import { useBackend } from '../backend';
import { Box, Button, Icon, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const Gateway = () => {
  return (
    <Window
      width={250}
      height={350}>
      <Window.Content scrollable>
        <GatewayContent />
      </Window.Content>
    </Window>
  );
};

const GatewayContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    gateway_present = false,
    gateway_found = false,
    gateway_status = false,
    current_target = null,
    destinations = [],
  } = data;
  if (!gateway_present) {
    return (
      <Section>
        <NoticeBox>
          Не привязаны врата
        </NoticeBox>
        <Button
          fluid
          onClick={() => act('linkup')}>
          Привязка
        </Button>
      </Section>
    );
  }
  if (current_target) {
    return (
      <Section
        title={current_target.name}>
        <Icon name="rainbow" size={4} color="green" />
        <Button
          fluid
          onClick={() => act("deactivate")}>
          Деактивация
        </Button>
      </Section>
    );
  }
  if (!destinations.length) {
    return (
      <Section>
        Не обнаружено других врат.
      </Section>
    );
  }
  return (
    <>
      {!gateway_status && (
        <NoticeBox>
          Врата не запитаны
        </NoticeBox>
      )}
      {!gateway_found && (
        <Section>
          <Button
            fluid
            onClick={() => act("find_new")}>
            Найти новые врата
          </Button>
        </Section>
      )}
      {destinations.map(dest => (
        <Section
          key={dest.ref}
          title={dest.name}>
          {dest.available && (
            <Button
              fluid
              onClick={() => act('activate', {
                destination: dest.ref,
              })}>
              Активировать
            </Button>
          ) || (
            <>
              <Box m={1} textColor="bad">
                {dest.reason}
              </Box>
              {!!dest.timeout && (
                <ProgressBar
                  value={dest.timeout}>
                  Калибровка...
                </ProgressBar>
              )}
            </>
          )}
        </Section>
      ))}
    </>
  );
};
