import { useBackend } from '../backend';
import { Table, TextArea, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

import { createLogger } from '../logging';
const logger = createLogger('Window');

export const EconomyController = (props, context) => {
  const { act, data } = useBackend(context);
  const accArray = data.accounts || [];
  const {
    eng_eco_mod,
    sci_eco_mod,
    med_eco_mod,
    sec_eco_mod,
    srv_eco_mod,
    civ_eco_mod,
    selflog
  } = data;
  logger.log(accArray);
  return (
    <Window
      width={860}
      height={600}
      resizable>
      <Window.Content>
        <Section>
          {accArray.map(accs => (
            <Button
              content={accs.name}/>
          ))}
        </Section>
        <TextArea
          value={selflog}
          height="100%"
          overflowY="scroll" />
      </Window.Content>
    </Window>
  );
};
