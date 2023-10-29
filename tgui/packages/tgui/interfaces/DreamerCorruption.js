import { Box, Section } from '../components';
import { Window } from '../layouts';

export const DreamerCorruption = (props, context) => {
  const generate10String = (length) => {
    let outString = '';
    while (outString.length < length) {
      if (Math.random() > 0.5) {
        outString += '0';
      } else {
        outString += '1';
      }
    }
    return outString;
  };

  const lineLength = 54;

  return (
    <Window width={400} height={250} theme="scarlet">
      <Section fontFamily="monospace" textAlign="center">
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
      </Section>
    </Window>
  );
};
