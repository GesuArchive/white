import { useBackend } from '../../backend';
import { Box, Button, Stack } from '../../components';

type InputButtonsProps = {
  input: string | number | null;
  inputIsValid?: Validator;
};

export type Validator = {
  isValid: boolean;
  error: string | null;
};

export const InputButtons = (props: InputButtonsProps, context) => {
  const { act } = useBackend(context);
  const { input, inputIsValid } = props;
  const submitButton = (
    <Button
      color="good"
      fluid={1}
      height={2}
      disabled={inputIsValid && !inputIsValid.isValid}
      onClick={() => act('choose', { choice: input })}
      pt={0.33}
      textAlign="center"
      tooltip={inputIsValid?.error}>
      ОТПРАВИТЬ
    </Button>
  );
  const cancelButton = (
    <Button
      color="bad"
      fluid={1}
      height={2}
      onClick={() => act('cancel')}
      pt={0.33}
      textAlign="center">
      ОТМЕНА
    </Button>
  );
  const leftButton = cancelButton;
  const rightButton = submitButton;

  return (
    <Stack>
      <Stack.Item grow>{leftButton}</Stack.Item>
      <Stack.Item grow>{rightButton}</Stack.Item>
    </Stack>
  );
};
