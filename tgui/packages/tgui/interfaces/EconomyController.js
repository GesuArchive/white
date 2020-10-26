import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const EconomyController = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    eng_eco_mod,
    sci_eco_mod,
    med_eco_mod,
    sec_eco_mod,
    srv_eco_mod,
    civ_eco_mod,
    selflog
  } = data;
  return (
    <Window
      width={600}
      height={600}
      resizable>
      <Window.Content scrollable>
        {eng_eco_mod}
      </Window.Content>
    </Window>
  );
};
