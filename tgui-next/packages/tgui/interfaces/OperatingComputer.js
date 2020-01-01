import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Button, LabeledList, NoticeBox, ProgressBar, Section, Tabs } from '../components';

export const OperatingComputer = props => {
  const { act, data } = useBackend(props);
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
  const {
    table,
    surgeries = [],
    procedures = [],
    patient = {},
  } = data;
  return (
    <Tabs>
      <Tabs.Tab
        key="state"
        label="Статус пациента">
        {!table && (
          <NoticeBox>
            No Table Detected
          </NoticeBox>
        )}
        <Section>
          <Section
            title="Статус пациента"
            level={2}>
            {patient ? (
              <LabeledList>
                <LabeledList.Item
                  label="Статус"
                  color={patient.statstate}>
                  {patient.stat}
                </LabeledList.Item>
                <LabeledList.Item label="Группа крови">
                  {patient.blood_type}
                </LabeledList.Item>
                <LabeledList.Item label="Здоровье">
                  <ProgressBar
                    value={patient.health}
                    minValue={patient.minHealth}
                    maxValue={patient.maxHealth}
                    color={patient.health >= 0 ? 'good' : 'average'}
                    content={(
                      <AnimatedNumber value={patient.health} />
                    )} />
                </LabeledList.Item>
                {damageTypes.map(type => (
                  <LabeledList.Item key={type.type} label={type.label}>
                    <ProgressBar
                      value={patient[type.type] / patient.maxHealth}
                      color="bad"
                      content={(
                        <AnimatedNumber value={patient[type.type]} />
                      )} />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            ) : (
              'Не обнаружно пациента'
            )}
          </Section>
          <Section
            title="Процедуры"
            level={2}>
            {procedures.length ? (
              procedures.map(procedure => (
                <Section
                  key={procedure.name}
                  title={procedure.name}
                  level={3}>
                  <LabeledList>
                    <LabeledList.Item label="Следующий шаг">
                      {procedure.next_step}
                      {procedure.chems_needed && (
                        <Fragment>
                          <b>
                            Требуемые химикаты:
                          </b>
                          <br />
                          {procedure.chems_needed}
                        </Fragment>
                      )}
                    </LabeledList.Item>
                    {!!data.alternative_step && (
                      <LabeledList.Item label="Альтернативный шаг">
                        {procedure.alternative_step}
                        {procedure.alt_chems_needed && (
                          <Fragment>
                            <b>
                            Требуемые химикаты:
                            </b>
                            <br />
                            {procedure.alt_chems_needed}
                          </Fragment>
                        )}
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Section>
              ))
            ) : (
              'Нет активных операций'
            )}
          </Section>
        </Section>
      </Tabs.Tab>
      <Tabs.Tab
        key="procedures"
        label="Хирургические процедуры">
        <Section title="Продвинутые хирургические процедуры">
          <Button
            icon="download"
            content="Синхронизировать"
            onClick={() => act('sync')} />
          {surgeries.map(surgery => (
            <Section
              title={surgery.name}
              key={surgery.name}
              level={2}>
              {surgery.desc}
            </Section>
          ))}
        </Section>
      </Tabs.Tab>
    </Tabs>
  );
};
