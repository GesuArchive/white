import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, Grid, Icon } from '../components';
import { Window } from '../layouts';

export const Cellphone = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window>
      <Window.Content>
        <CellphoneNumpad />
      </Window.Content>
    </Window>
  );
};

const CellphoneNumpad = (props, context) => {
  const { act } = useBackend(context);
  const keypadKeys = [
    ['1', '4', '7', '#'],
    ['2', '5', '8', '0'],
    ['3', '6', '9', '*'],
  ];
  return (
    <Box width="200px">
      <Grid width="1px">
        {keypadKeys.map(keyColumn => (
          <Grid.Column key={keyColumn[0]}>
            {keyColumn.map(key => (
              <Button
                fluid
                bold
                key={key}
                mb={1}
                content={key}
                textAlign="center"
                fontSize="35px"
                lineHeight="40px"
                width="45px"
                className={classes([
                  'NuclearBomb__Button',
                  'NuclearBomb__Button--keypad',
                  'NuclearBomb__Button--' + key,
                ])}
                onClick={() => act('numpad', { digit: key })} />
            ))}
          </Grid.Column>
        ))}
      </Grid>
    </Box>
  );
};
