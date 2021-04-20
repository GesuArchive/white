import { useBackend } from '../backend';
import { Button, ColorBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export const NtosMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    programs = [],
    has_light,
    light_on,
    comp_light_color,
    removable_media = [],
    cardholder,
    login = [],
  } = data;
  return (
    <NtosWindow
      title={device_theme === 'syndicate'
        && 'Syndix - Главное меню'
        || 'NtOS - Главное меню'}
      theme={device_theme}
      width={400}
      height={500}>
      <NtosWindow.Content scrollable>
        {!!has_light && (
          <Section>
            <Button
              width="144px"
              icon="lightbulb"
              selected={light_on}
              onClick={() => act('PC_toggle_light')}>
              Фонарик: {light_on ? 'ВКЛ' : 'ВЫКЛ'}
            </Button>
            <Button
              ml={1}
              onClick={() => act('PC_light_color')}>
              Цвет:
              <ColorBox ml={1} color={comp_light_color} />
            </Button>
          </Section>
        )}
        {!!cardholder && (
          <Section
            title="Вход"
            buttons={(
              <Button
                icon="eject"
                content="Изъять ID"
                disabled={!login.IDName}
                onClick={() => act('PC_Eject_Disk', { name: "ID" })}
              />
            )}>
            <Table>
              <Table.Row>
                Имя ID: {login.IDName}
              </Table.Row>
              <Table.Row>
                Должность: {login.IDJob}
              </Table.Row>
            </Table>
          </Section>
        )}
        {!!removable_media.length && (
          <Section title="Изъять диск">
            <Table>
              {removable_media.map(device => (
                <Table.Row key={device}>
                  <Table.Cell>
                    <Button
                      fluid
                      color="transparent"
                      icon="eject"
                      content={device}
                      onClick={() => act('PC_Eject_Disk', { name: device })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
        <Section title="Программы">
          <Table>
            {programs.map(program => (
              <Table.Row key={program.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color={program.alert ? 'yellow' : 'transparent'}
                    icon={program.icon}
                    content={program.desc}
                    onClick={() => act('PC_runprogram', {
                      name: program.name,
                    })} />
                </Table.Cell>
                <Table.Cell collapsing width="18px">
                  {!!program.running && (
                    <Button
                      color="transparent"
                      icon="times"
                      tooltip="Close program"
                      tooltipPosition="left"
                      onClick={() => act('PC_killprogram', {
                        name: program.name,
                      })} />
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
