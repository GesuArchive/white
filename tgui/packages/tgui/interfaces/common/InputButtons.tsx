import { useBackend } from '../../backend';
import { Box, Button, Stack } from '../../components';

type InputButtonsProps = {
  input: string | number | null;
  inputIsValid: Validator;
};

export type Validator = {
  isValid: boolean;
  error: string | null;
};

export const InputButtons = (props: InputButtonsProps, context) => {
  const { act } = useBackend(context);
  const { input, inputIsValid } = props;
  const { isValid, error } = inputIsValid;
  const submitButton = (
    <Button
      color="good"
      disabled={!isValid}
      onClick={() => act('submit', { entry: input })}
      textAlign="center"
      width={6}>
      Отправить
    </Button>
  );
  const cancelButton = (
    <Button
      color="bad"
      onClick={() => act('cancel')}
      textAlign="center"
      width={6}>
      Отмена
    </Button>
  );
  const leftButton = cancelButton;
  const rightButton = submitButton;

  return (
    <Stack>
      <Stack.Item>{leftButton}</Stack.Item>
      <Stack.Item grow>
        {!isValid && (
          <Box color="average" nowrap textAlign="center">
            {error}
          </Box>
        )}
      </Stack.Item>
      <Stack.Item>{rightButton}</Stack.Item>
    </Stack>
  );
};
