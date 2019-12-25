import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';

export const BluespaceArtillery = props => {
  const { act, data } = useBackend(props);
  const {
    notice,
    connected,
    unlocked,
    target,
  } = data;
  return (
    <Fragment>
      {!!notice && (
        <NoticeBox>
          {notice}
        </NoticeBox>
      )}
      {connected ? (
        <Fragment>
          <Section
            title="Цель"
            buttons={(
              <Button
                icon="crosshairs"
                disabled={!unlocked}
                onClick={() => act('recalibrate')} />
            )}>
            <Box
              color={target ? 'average' : 'bad'}
              fontSize="25px">
              {target || 'Нет цели'}
            </Box>
          </Section>
          <Section>
            {unlocked ? (
              <Box style={{ margin: 'auto' }}>
                <Button
                  fluid
                  content="ОГОНЬ"
                  color="bad"
                  disabled={!target}
                  fontSize="30px"
                  textAlign="center"
                  lineHeight="46px"
                  onClick={() => act('fire')} />
              </Box>
            ) : (
              <Fragment>
                <Box
                  color="bad"
                  fontSize="18px">
                  Блюспейс артиллерия заблокирована
                </Box>
                <Box mt={1}>
                  Ожидается разблокировка от, как минимум, двух
                  авторизованных людей на станции.
                </Box>
              </Fragment>
            )}
          </Section>
        </Fragment>
      ) : (
        <Section>
          <LabeledList>
            <LabeledList.Item label="Сборка">
              <Button
                icon="wrench"
                content="Завершить сборку"
                onClick={() => act('build')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
    </Fragment>
  );
};
