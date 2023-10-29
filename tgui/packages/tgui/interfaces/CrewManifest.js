import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Icon, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

const commandJobs = [
  'Глава Персонала',
  'Начальник Охраны',
  'Старший Инженер',
  'Научный Руководитель',
  'Главный Врач',
];

export const CrewManifest = (props, context) => {
  const {
    data: { manifest, positions },
  } = useBackend(context);

  return (
    <Window title="Список Персонала" width={400} height={600}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={'CrewManifest--' + dept}
            key={dept}
            title={
              dept +
              (dept !== 'Misc' ? ` (${positions[dept]} позиций открыто)` : '')
            }>
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell className={'CrewManifest__Cell'}>
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Icons',
                    ])}
                    collapsing>
                    {crewMember.rank === 'Капитан' && (
                      <Tooltip content="Captain" position="bottom">
                        <Icon
                          className={classes([
                            'CrewManifest__Icon',
                            'CrewManifest__Icon--Command',
                          ])}
                          name="star"
                        />
                      </Tooltip>
                    )}
                    {commandJobs.includes(crewMember.rank) && (
                      <Tooltip content="Член командования" position="bottom">
                        <Icon
                          className={classes([
                            'CrewManifest__Icon',
                            'CrewManifest__Icon--Command',
                            'CrewManifest__Icon--Chevron',
                          ])}
                          name="chevron-up"
                        />
                      </Tooltip>
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Cell--Rank',
                    ])}
                    collapsing>
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
