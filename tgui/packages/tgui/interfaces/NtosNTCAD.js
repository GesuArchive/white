import { Section, Button, LabeledList } from "../components";
import { useBackend } from "../backend";
import { NtosWindow } from "../layouts";

export const NtosNTCAD = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <NtosWindow>
      <NtosWindow.Content>
        <Section>
          <Button
            content="кнопка прикол тест"
            onClick={(e, value) => act('PRG_test')}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
