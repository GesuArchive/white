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
        <Box width="252px" height="240px"
          className={classes(['Cellphone__bg'])}>
          <CellphoneScreen />
          <CellphoneFuncMenu />
        </Box>
        <Box width="252px" height="10px" />
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
    <Box width="240px" height="202px" >
      <Box className={classes(['Cellphone__font'])}>
        ShwainokarasOS v0.9.3
      </Box>
      <Box height="200px"
        className="Cellphone__OSIcon" />
    </Box>
  );
};

const CellphoneFuncMenu = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Box width="240px">
      <Grid>
        <Grid.Column>
          {data.lf_menu && (
            <Section height="30px" align="center">
              {data.lf_menu}
            </Section>)}
        </Grid.Column>
        <Grid.Column>
          <Box />
        </Grid.Column>
        <Grid.Column>
          {data.rf_menu && (
            <Section height="30px" align="center">
              {data.rf_menu}
            </Section>)}
        </Grid.Column>
      </Grid>
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
                  'Cellphone__Button',
                  'Cellphone__Button--keypad',
                ])}
                onClick={() => act('numpad', { digit: key })} />
            ))}
          </Grid.Column>
        ))}
      </Grid>
    </Box>
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
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('call')} />

          <Button fluid bold content="➥"
            textAlign="center" fontSize="30px"
            lineHeight="35px" width="55px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('leftfunc')} />
        </Flex.Item>

        <Flex.Item align="center">
          <Button fluid bold content="◀"
            textAlign="center" fontSize="20px"
            lineHeight="60px" width="20px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('dpad', { button: "larrow" })} />
        </Flex.Item>

        <Flex.Item >
          <Button fluid bold content="▲"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('dpad', { button: "uarrow" })} />

          <Button fluid bold content="⎆"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('dpad', { button: "enter" })} />

          <Button fluid bold content="▼"
            textAlign="center" fontSize="20px"
            lineHeight="20px" width="50px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('dpad', { button: "darrow" })} />
        </Flex.Item>

        <Flex.Item align="center">
          <Button fluid bold content="▶"
            textAlign="center" fontSize="20px"
            lineHeight="60px" width="20px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('dpad', { button: "rarrow" })} />
        </Flex.Item>

        <Flex.Item>
          <Button fluid bold content="📴"
            textAlign="center" fontSize="20px"
            lineHeight="35px" width="55px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('hang')} />

          <Button fluid bold content="➈"
            textAlign="center" fontSize="20px"
            lineHeight="35px" width="55px"
            className={classes([
              'Cellphone__Button',
              'Cellphone__Button--keypad',
            ])}
            onClick={() => act('rightfunc')} />
        </Flex.Item>

      </Flex>
    </Box>
  );
};
