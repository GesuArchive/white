import { Box, Section } from '../components';
import { Window } from '../layouts';

export const DreamerCorruption = (props, context) => {
  const generate10String = length => {
    let outString = "";
    const factor = (overload / capacity);
    while (outString.length < length) {
      if (Math.random() > factor) {
        outString += "0";
      } else {
        outString += "1";
      }
    }
    return outString;
  };

  const lineLength = 45;

  return (
    <Window
      width={400}
      height={250}
      theme="syndicate">
      <Section fontFamily="monospace" textAlign="center">
        <Box>
          {generate10String(lineLength)}
        </Box>
        <Box>
          {generate10String(lineLength)}
        </Box>
        <Box>
          {generate10String(lineLength)}
        </Box>
        <Box>
          {generate10String(lineLength)}
        </Box>
        <Box>
          {generate10String(lineLength)}
        </Box>
        <Box>
          {generate10String(lineLength)}
        </Box>
      </Section>
    </Window>
  );
};
