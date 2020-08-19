import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Box } from '../components';
import { Window } from '../layouts';

// мне лень писать нормально на этом языке древних шизов, так что так

export const Autodoc = (props, context) => {
  const { act, data } = useBackend(context);
  const operations = data.surgeries;
  if (data.mode === 1) {
    return (
      <Window
        width={496}
        height={440}
        resizable>
        <Section
          title="Конечность">
          <Button
            key="head"
            content="Голова"
            onClick={() => act('target', { part: "head" })} />
          <Button
            key="chest"
            content="Грудь"
            onClick={() => act('target', { part: "chest" })} />
          <Button
            key="l_arm"
            content="Л. рука"
            onClick={() => act('target', { part: "l_arm" })} />
          <Button
            key="r_arm"
            content="П. рука"
            onClick={() => act('target', { part: "r_arm" })} />
          <Button
            key="l_leg"
            content="Л. нога"
            onClick={() => act('target', { part: "l_leg" })} />
          <Button
            key="r_leg"
            content="П. нога"
            onClick={() => act('target', { part: "r_leg" })} />
          <Button
            key="groin"
            content="Пах"
            onClick={() => act('target', { part: "groin" })} />
          <Button
            key="eyes"
            content="Глаза"
            onClick={() => act('target', { part: "eyes" })} />
          <Button
            key="mouth"
            content="Рот"
            onClick={() => act('target', { part: "mouth" })} />
        </Section>
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
      </Window>
    );
  } else if (data.mode === 2) {
    return (
      <Window>
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
      </Window>
    );
  } else {
    return (
      <NoticeBox textAlign="center">
        Нет доступа
      </NoticeBox>
    );
  }
};
