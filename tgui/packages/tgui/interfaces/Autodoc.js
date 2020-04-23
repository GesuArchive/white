import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Box } from '../components';

export const Autodoc = props => {
  const { act, data } = useBackend(props);
  const operations = data.surgeries;
  if (data.mode === 1) {
    return (
      <Fragment>
        <Tabs>
          <Tabs.Tab
            key="head"
            label="Голова"
            onClick={() => act('target', { part: "head" })} />
          <Tabs.Tab
            key="chest"
            label="Грудь"
            onClick={() => act('target', { part: "chest" })} />
          <Tabs.Tab
            key="l_arm"
            label="Л. рука"
            onClick={() => act('target', { part: "l_arm" })} />
          <Tabs.Tab
            key="r_arm"
            label="П. рука"
            onClick={() => act('target', { part: "r_arm" })} />
          <Tabs.Tab
            key="l_leg"
            label="Л. нога"
            onClick={() => act('target', { part: "l_leg" })} />
          <Tabs.Tab
            key="r_leg"
            label="П. нога"
            onClick={() => act('target', { part: "r_leg" })} />
          <Tabs.Tab
            key="groin"
            label="Пах"
            onClick={() => act('target', { part: "groin" })} />
          <Tabs.Tab
            key="eyes"
            label="Глаза"
            onClick={() => act('target', { part: "eyes" })} />
          <Tabs.Tab
            key="mouth"
            label="Рот"
            onClick={() => act('target', { part: "mouth" })} />
        </Tabs>
        <Section>
          {operations.map(op => (
            <Button
              icon="vial"
              key={op.name}
              content={op.name}
              selected={op.selected}
              onClick={() => act('surgery', { path: op.path })} />
          ))}
        </Section>
        <Section>
          <Button
            key="start_op"
            content="Начать операцию"
            onClick={() => act('start')} />
        </Section>
      </Fragment>
    );
  } else if (data.mode === 2) {
    return (
      <Fragment>
        <Section textAlign="center" title={'Операция: ' + data.s_name}>
          {data.steps.map(step => (
            <Box
              key={step.name}
              fontSize={(step.current ? '16px' : '12px')}>
              {(step.current ? '>> ' : '')}
              {step.name}{(step.current ? ' <<' : '')}
            </Box>
          ))}
        </Section>
        <NoticeBox textAlign="center">
          Выполняется операция
        </NoticeBox>
      </Fragment>
    );
  } else {
    return (
      <NoticeBox textAlign="center">
        Нет доступа
      </NoticeBox>
    );
  }
};
