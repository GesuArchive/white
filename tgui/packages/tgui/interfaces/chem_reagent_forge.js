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
              value={data.material_amount>Math.round(data.material_amount)} cm3
              minValue="0"
              maxvalue="200000"
              content={data.material_amount} />
          </LabeledList>
          <Button
            title="Eject"
            icon="Dump"
            OnClick={() => act('Dump')} />
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
              class="candystripe">
              <Section
                class="cell">
                {'name'}
              </Section>
              <Section
                class="cell"
                align="right">
                {'cost'}
              </Section>
              <Section
                class="cell"
                align="right">
                {'category'}
              </Section>
              <Section
                class="table"
                alight="right" />
              <Section
                class="cell" />
              <Section
                class="cell" />
              <Section
                class="cell">
                <Button.Grid
                  disabled="{data.can_afford}"
                  OnClick={() => act('create', {
                    name: 'name' })}>
                  Create
                </Button.Grid>
              </Section>
            </Section>
          </div>
        </Section>
      </Window.Content>
    </Window>
  );
};
