import { Window } from '../layouts';
import { Section, LabeledList, ProgressBar, Button } from "../components";
import { useBackend } from '../backend';

export const chem_reagent_forge = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window>
      <Window.Content>
        <Section
          title="Кузница">
          <LabeledList>
            <LabeledList.Item
              label="{data.currently_forging}" />
            <ProgressBar
              minValue="0"
              maxvalue="200000"
              value={data.material_amount} />
            <Button
              title="Eject"
              icon="Dump"
              disabled="{data.currently_forging}"
              OnClick={() => act("Dump")} />
          </LabeledList>
        </Section>
        <Section
          title="Рецепты">
          <div
            class="display tabular">
            <Section
              className="candystripe">
              <Section
                className="cell bold">
                Recipe
              </Section>
              <Section
                className="cell bold">
                Cost (Cm3)
              </Section>
              <Section
                className="cell bold">
                Type
              </Section>
              <Section
                className="cell bold"
                align="center">
                Create
              </Section>
            </Section>
            {data.recipes}
            <Section
              className="candystripe">
              <Section
                className="cell">
                {name}
              </Section>
              <Section
                className="cell"
                align="right">
                {"cost"}
              </Section>
              <Section
                className="cell"
                align="right">
                {"category"}
              </Section>
              <Section
                className="table"
                alight="right" />
              <Section
                className="cell" />
              <Section
                className="cell" />
              <Section
                className="cell">
                <Button
                  disabled="{data.can_afford}"
                  OnClick={() => act('create', {
                    name: "name" })}>
                  Create
                </Button>
              </Section>
            </Section>
          </div>
        </Section>
      </Window.Content>
    </Window>
  );
};
