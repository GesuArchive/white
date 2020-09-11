import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Input, NoticeBox, Section, Tabs } from '../components';
import { NtosWindow } from '../layouts';
import { AccessList } from './common/AccessList';

export const NtosCard = (props, context) => {
  return (
    <NtosWindow
      width={450}
      height={520}
      resizable>
      <NtosWindow.Content scrollable>
        <NtosCardContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosCardContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'tab', 1);
  const {
    authenticated,
    regions = [],
    access_on_card = [],
    jobs = {},
    id_rank,
    id_owner,
    has_id,
    have_printer,
    have_id_slot,
    id_name,
  } = data;
  const [
    selectedDepartment,
    setSelectedDepartment,
  ] = useLocalState(context, 'department', Object.keys(jobs)[0]);
  if (!have_id_slot) {
    return (
      <NoticeBox>
        Эта программа требует слот для ID-карты
      </NoticeBox>
    );
  }
  const departmentJobs = jobs[selectedDepartment] || [];
  return (
    <Fragment>
      <Section
        title={has_id && authenticated
          ? (
            <Input
              value={id_owner}
              width="250px"
              onInput={(e, value) => act('PRG_edit', {
                name: value,
              })} />
          )
          : (id_owner || 'Вставьте карту')}
        buttons={(
          <Fragment>
            <Button
              icon="print"
              content="Распечатать"
              disabled={!have_printer || !has_id}
              onClick={() => act('PRG_print')} />
            <Button
              icon={authenticated ? "sign-out-alt" : "sign-in-alt"}
              content={authenticated ? "Выйти" : "Войти"}
              color={authenticated ? "bad" : "good"}
              onClick={() => {
                act(authenticated ? 'PRG_logout' : 'PRG_authenticate');
              }} />
          </Fragment>
        )}>
        <Button
          fluid
          icon="eject"
          content={id_name}
          onClick={() => act('PRG_eject')} />
      </Section>
      {(!!has_id && !!authenticated) && (
        <Box>
          <Tabs>
            <Tabs.Tab
              selected={tab === 1}
              onClick={() => setTab(1)}>
              Доступы
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 2}
              onClick={() => setTab(2)}>
              Должности
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && (
            <AccessList
              accesses={regions}
              selectedList={access_on_card}
              accessMod={ref => act('PRG_access', {
                access_target: ref,
              })}
              grantAll={() => act('PRG_grantall')}
              denyAll={() => act('PRG_denyall')}
              grantDep={dep => act('PRG_grantregion', {
                region: dep,
              })}
              denyDep={dep => act('PRG_denyregion', {
                region: dep,
              })} />
          )}
          {tab === 2 && (
            <Section
              title={id_rank}
              buttons={(
                <Button.Confirm
                  icon="exclamation-triangle"
                  content="Терминация"
                  color="bad"
                  onClick={() => act('PRG_terminate')} />
              )}>
              <Button.Input
                fluid
                content="Своя..."
                onCommit={(e, value) => act('PRG_assign', {
                  assign_target: 'Custom',
                  custom_name: value,
                })} />
              <Flex>
                <Flex.Item>
                  <Tabs vertical>
                    {Object.keys(jobs).map(department => (
                      <Tabs.Tab
                        key={department}
                        selected={department === selectedDepartment}
                        onClick={() => setSelectedDepartment(department)}>
                        {department}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Flex.Item>
                <Flex.Item grow={1}>
                  {departmentJobs.map(job => (
                    <Button
                      fluid
                      key={job.job}
                      content={job.display_name}
                      onClick={() => act('PRG_assign', {
                        assign_target: job.job,
                      })} />
                  ))}
                </Flex.Item>
              </Flex>
            </Section>
          )}
        </Box>
      )}
    </Fragment>
  );
};
