import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, Grid, Icon, Label } from '../components';
import { Window } from '../layouts';

export const LockerPad = (props, context) => {
  const { act, data } = useBackend(context);
  const keypadKeys = [
    ['1', '4', '7', 'C'],
    ['2', '5', '8', '0'],
    ['3', '6', '9', 'E'],
  ];
  const {
    keypad,
  } = data;
  return (
    <Window
      width={180}
      height={310}>
      <Flex.Item grow={1}>
        <Box
          width="165px"
          textAlign="center"
          fontSize="20px">
          {"Enter password\n"}
          {"Here: "}{keypad}
        </Box>
      </Flex.Item>
      <Box width="165px">
        <Grid width="1px">
          {keypadKeys.map(keyColumn => (
            <Grid.Column key={keyColumn[0]}>
              {keyColumn.map(key => (
                <Button
                  fluid
                  bold
                  key={key}
                  mb="6px"
                  content={key}
                  textAlign="center"
                  fontSize="40px"
                  lineHeight={1.25}
                  width="55px"
                  onClick={() => act('keypad', { digit: key })} />
              ))}
            </Grid.Column>
          ))}
        </Grid>
      </Box>
    </Window>
  );
};
