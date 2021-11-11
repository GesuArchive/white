import { useBackend } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';

export const KeycardAuth = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={375}
      height={155}>
      <Window.Content>
        <Section>
          <Box>
            {data.waiting === 1 && (
              <span>
                Ожидание подтверждения вашего
                запроса другим устройством...
              </span>
            )}
          </Box>
          <Box>
            {data.waiting === 0 && (
              <>
                {!!data.auth_required && (
                  <Button
                    icon="check-square"
                    color="red"
                    textAlign="center"
                    lineHeight="60px"
                    fluid
                    onClick={() => act('auth_swipe')}
                    content="Авторизовать" />
                )}
                {data.auth_required === 0 && (
                  <>
                    <Button
                      icon="exclamation-triangle"
                      fluid
                      onClick={() => {
                        return act('red_alert');
                      }}
                      content="Красная тревога" />
                    <Button
                      icon="wrench"
                      fluid
                      onClick={() => act('emergency_maint')}
                      content="Аварийный доступ к техтоннелям" />
                    <Button
                      icon="meteor"
                      fluid
                      onClick={() => act('bsa_unlock')}
                      content="Разблокировка блюспейс артиллерии" />
                    <Button
                      icon="circle"
                      fluid
                      onClick={() => act('migger_alarm')}
                      content="Миграционная политика" />
                  </>
                )}
              </>
            )}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
