import { AnimatedNumber, Box } from '../../components';

export const BeakerContents = props => {
  const { beakerLoaded, beakerContents } = props;
  return (
    <Box>
      {!beakerLoaded && (
        <Box color="label">
          Нет пробирки.
        </Box>
      ) || beakerContents.length === 0 && (
        <Box color="label">
          Пробирка пуста.
        </Box>
      )}
      {beakerContents.map(chemical => (
        <Box key={chemical.name} color="label">
          <AnimatedNumber
            initial={0}
            value={chemical.volume} /> 
          {" единиц "+chemical.name}
        </Box>
      ))}
    </Box>
  );
};
