import { decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Grid, LabeledList, Section } from '../components';

export const EngravedMessage = props => {
  const { act, data } = useBackend(props);
  const {
    admin_mode,
    creator_key,
    creator_name,
    has_liked,
    has_disliked,
    hidden_message,
    is_creator,
    num_likes,
    num_dislikes,
    realdate,
  } = data;
  return (
    <Fragment>
      <Section>
        <Box
          bold
          textAlign="center"
          fontSize="20px"
          mb={2}>
          {decodeHtmlEntities(hidden_message)}
        </Box>
        <Grid>
          <Grid.Column>
            <Button
              fluid
              icon="arrow-up"
              content={" " + num_likes}
              disabled={is_creator}
              selected={has_liked}
              textAlign="center"
              fontSize="16px"
              lineHeight="24px"
              onClick={() => act('like')} />
          </Grid.Column>
          <Grid.Column>
            <Button
              fluid
              icon="circle"
              disabled={is_creator}
              selected={!has_disliked && !has_liked}
              textAlign="center"
              fontSize="16px"
              lineHeight="24px"
              onClick={() => act('neutral')} />
          </Grid.Column>
          <Grid.Column>
            <Button
              fluid
              icon="arrow-down"
              content={" " + num_dislikes}
              disabled={is_creator}
              selected={has_disliked}
              textAlign="center"
              fontSize="16px"
              lineHeight="24px"
              onClick={() => act('dislike')} />
          </Grid.Column>
        </Grid>
      </Section>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Создано">
            {realdate}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section />
      {!!admin_mode && (
        <Section
          title="АП"
          buttons={(
            <Button
              icon="times"
              content="Удалить"
              color="bad"
              onClick={() => act('delete')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Автор">
              {creator_key}
            </LabeledList.Item>
            <LabeledList.Item label="Имя персонажа">
              {creator_name}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )}
    </Fragment>
  );
};
