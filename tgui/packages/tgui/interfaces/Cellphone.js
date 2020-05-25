import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, Grid, Icon, Section } from '../components';
import { Window } from '../layouts';

export const Cellphone = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window theme="retro">
      <Window.Content>
        <CellphoneStat />
        <Section width="252px" height="240px">
          <CellphoneScreen />
        </Section>
        <CellphoneFunc />
        <CellphoneNumpad />
      </Window.Content>
    </Window>
  );
};

const CellphoneStat = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Box width="240px" height="30px" />
  );
};

const CellphoneScreen = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Box />
  );
};

const CellphoneFunc = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Box width="252px">
      <Flex justify="space-between">
        <Flex.Item>
          <Button fluid bold content="📞"
            textAlign="center" fontSize="30px"
            lineHeight="35px" width="55px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('func', { digit: "call" })} />

          <Button fluid bold content="➥"
            textAlign="center" fontSize="30px"
            lineHeight="35px" width="55px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('func', { digit: "funcleft" })} />
        </Flex.Item>

        <Flex.Item align="center">
          <Button fluid bold content="◀"
            textAlign="center" fontSize="20px"
            lineHeight="60px" width="20px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('dpad', { digit: "larrow" })} />
        </Flex.Item>

        <Flex.Item >
          <Button fluid bold content="▲"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('dpad', { digit: "uarrow" })} />

          <Button fluid bold content="⎆"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('dpad', { digit: "enter" })} />

          <Button fluid bold content="▼"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('dpad', { digit: "darrow" })} />
        </Flex.Item>

        <Flex.Item align="center">
          <Button fluid bold content="▶"
            textAlign="center" fontSize="20px"
            lineHeight="60px" width="20px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('dpad', { digit: "rarrow" })} />
        </Flex.Item>

        <Flex.Item>
          <Button fluid bold content="📴"
            textAlign="center" fontSize="20px"
            lineHeight="35px" width="55px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('func', { digit: "hangyourself" })} />

          <Button fluid bold content="➈"
            textAlign="center" fontSize="20px"
            lineHeight="35px" width="55px"
            className={classes([
              'NuclearBomb__Button',
              'NuclearBomb__Button--keypad',
            ])}
            onClick={() => act('func', { digit: "funcright" })} />
        </Flex.Item>

      </Flex>
    </Box>
  );
};

const CellphoneNumpad = (props, context) => {
  const { act, data } = useBackend(context);
  const keypadKeys = [
    ['1', '4', '7', '*'],
    ['2', '5', '8', '0'],
    ['3', '6', '9', '#'],
  ];
  return (
    <Box width="240px">
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
                fontSize="20px"
                lineHeight="20px"
                width="80px"
                className={classes([
                  'NuclearBomb__Button',
                  'NuclearBomb__Button--keypad',
                ])}
                onClick={() => act('numpad', { digit: key })} />
            ))}
          </Grid.Column>
        ))}
      </Grid>
    </Box>
  );
};
