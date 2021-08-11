import { useBackend, useSharedState } from '../backend';
import { NtosWindow } from '../layouts';
import { AnimatedNumber, Button, LabeledList, NoticeBox, ProgressBar, Section, Tabs } from '../components';

const damageTypes = [
  {
    label: 'Физический',
    type: 'bruteLoss',
  },
  {
    label: 'Ожоги',
    type: 'fireLoss',
  },
  {
    label: 'Токсины',
    type: 'toxLoss',
  },
  {
    label: 'Кислород',
    type: 'oxyLoss',
  },
];

export const NtosOperating = (props, context) => {
  const [tab, setTab] = useSharedState(context, 'tab', 1);
  return (
    <NtosWindow
      width={350}
      height={470}>
      <NtosWindow.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tab === 1}
            onClick={() => setTab(1)}>
            Пациент
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Процедуры
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && (
          <PatientStateView />
        )}
        {tab === 2 && (
          <SurgeryProceduresView />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};


const PatientStateView = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    procedures = [],
    patient = {},
  } = data;
  return (
    <>
      <Section title="Статус пациента">
        {patient && (
          <LabeledList>
            <LabeledList.Item
              label="Состояние"
              color={patient.statstate}>
              {patient.stat}
            </LabeledList.Item>
            <LabeledList.Item label="Тип крови">
              {patient.blood_type}
            </LabeledList.Item>
            <LabeledList.Item label="Здоровье">
              <ProgressBar
                value={patient.health}
                minValue={patient.minHealth}
                maxValue={patient.maxHealth}
                color={patient.health >= 0 ? 'good' : 'average'}>
                <AnimatedNumber value={patient.health} />
              </ProgressBar>
            </LabeledList.Item>
            {damageTypes.map(type => (
              <LabeledList.Item key={type.type} label={type.label}>
                <ProgressBar
                  value={patient[type.type] / patient.maxHealth}
                  color="bad">
                  <AnimatedNumber value={patient[type.type]} />
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) || (
          'Пациент не обнаружен, выполните ручное сканирование или начните операцию.'
        )}
      </Section>
      {procedures.length === 0 && (
        <Section>
          Нет активных операций
        </Section>
      )}
      {procedures.map(procedure => (
        <Section
          key={procedure.name}
          title={procedure.name}>
          <LabeledList>
            <LabeledList.Item label="Следующий шаг">
              {procedure.next_step}
              {procedure.chems_needed && (
                <>
                  <b>Требуются химикаты:</b>
                  <br />
                  {procedure.chems_needed}
                </>
              )}
            </LabeledList.Item>
            {!!data.alternative_step && (
              <LabeledList.Item label="Альт">
                {procedure.alternative_step}
                {procedure.alt_chems_needed && (
                  <>
                    <b>Требуются химикаты:</b>
                    <br />
                    {procedure.alt_chems_needed}
                  </>
                )}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      ))}
    </>
  );
};

const SurgeryProceduresView = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    surgeries = [],
  } = data;
  return (
    <Section title="Продвинутые хирургические процедуры">
      {surgeries.map(surgery => (
        <Section
          title={surgery.name}
          key={surgery.name}
          level={2}>
          {surgery.desc}
        </Section>
      ))}
    </Section>
  );
};
