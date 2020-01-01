import { multiline } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, ProgressBar, Section, Tabs } from '../components';

export const MedicalKiosk = props => {
  const { act, data } = useBackend(props);
  return (
    <Fragment>
      <Section title="Киоск здоровья"
        textAlign="center"
        icon="procedures">
        <Box my={1} textAlign="center">
          Приветствую, уважаемый сотрудник. Пожалуйста, выберите
          желаемую процедуру.
          Стоимость процедуры {data.kiosk_cost} кредитов.
          <Box mt={1} />
          <Box textAlign="center">
            Текущий пациент: {data.patient_name}
          </Box>
          <Box my={1} mx={4} />
          <Button
            icon="procedures"
            disabled={!data.active_status_1}
            tooltip={multiline`
             Читает обратно точные значения вашего общего сканирования здоровья.
            `}
            onClick={() => act('beginScan_1')}
            content="Общее сканирование здоровья" />
          <Button
            icon="heartbeat"
            disabled={!data.active_status_2}
            tooltip={multiline`
             Предоставляет информацию на основе различных неочевидных симптомов,
             как уровень крови или статус болезни.
            `}
            onClick={() => act('beginScan_2')}
            content="Проверка на основе симптомов" />
          <Button
            tooltip={multiline`
             Сбрасывает текущую цель сканирования, отменяя текущие сканирования.
            `}
            icon="sync"
            color="average"
            onClick={() => act('clearTarget')}
            content="Сбросить сканер" />
        </Box>
        <Box my={1} textAlign="center">
          <Button
            icon="radiation-alt"
            disabled={!data.active_status_3}
            tooltip={multiline`
             Предоставляет информацию о травме головного мозга и радиации.
            `}
            onClick={() => act('beginScan_3')}
            content="Невро/Радиологическое сканирование" />
          <Button
            icon="mortar-pestle"
            disabled={!data.active_status_4}
            tooltip={multiline`
             Предоставляет список потребляемых химических веществ,
             а также потенциальные побочные эффекты.
            `}
            onClick={() => act('beginScan_4')}
            content="Хим. анализ и психоактивное сканирование" />
        </Box>
      </Section>
      <Tabs>
        <Tabs.Tab
          key="tab_1"
          color="normal"
          label="Общее сканирование здоровья">
          {() => (
            <Box>
              {data.active_status_1 === 0 && (
                <Section title="Здоровье пациента"
                  textAlign="center">
                  <LabeledList>
                    <LabeledList.Item
                      label="Общее здоровье">
                      <ProgressBar
                        value={(data.patient_health)/100}>
                        <AnimatedNumber value={data.patient_health} />%
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Divider size={2} />
                    <LabeledList.Item
                      label="Физический урон">
                      <ProgressBar
                        value={data.brute_health/100}
                        color="bad">
                        <AnimatedNumber value={data.brute_health} />
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Ожоги">
                      <ProgressBar
                        value={data.burn_health/100}
                        color="bad">
                        <AnimatedNumber value={data.burn_health} />
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Кислородный урон">
                      <ProgressBar
                        value={data.suffocation_health/100}
                        color="bad">
                        <AnimatedNumber value={data.suffocation_health} />
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Интоксикация">
                      <ProgressBar
                        value={data.toxin_health/100}
                        color="bad">
                        <AnimatedNumber value={data.toxin_health} />
                      </ProgressBar>
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )}
            </Box>
          )}
        </Tabs.Tab>
        <Tabs.Tab
          key="tab_2"
          color="normal"
          label="Проверка на основе симптомов">
          {() => (
            <Box>
              {data.active_status_2 === 0 && (
                <Section title="Проверка на основе симптомов"
                  textAlign="center">
                  <LabeledList>
                    <LabeledList.Item
                      label="Состояние пациента"
                      color="good">
                      {data.patient_status}
                    </LabeledList.Item>
                    <LabeledList.Divider size={1} />
                    <LabeledList.Item
                      label="Состояние болезни">
                      {data.patient_illness}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Информация о болезни">
                      {data.illness_info}
                    </LabeledList.Item>
                    <LabeledList.Divider size={1} />
                    <LabeledList.Item
                      label="Уровень крови">
                      {data.bleed_status}
                      <LabeledList.Divider size={1} />
                      <ProgressBar
                        value={data.blood_levels/100}
                        color="bad">
                        <AnimatedNumber value={data.blood_levels} />
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Информация о крови">
                      {data.blood_status}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )}
            </Box>
          )}
        </Tabs.Tab>
        <Tabs.Tab
          key="tab_3"
          color="normal"
          label="Невро/Радиологическое сканирование">
          {() => (
            <Box>
              {data.active_status_3 === 0 && (
                <Section title="Невро/Радиологическое сканирование"
                  textAlign="center">
                  <LabeledList.Item
                    label="Клеточный урон">
                    <ProgressBar
                      value={data.clone_health/100}
                      color="good">
                      <AnimatedNumber value={data.clone_health} />
                    </ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Повреждения мозга">
                    <ProgressBar
                      value={data.brain_damage/100}
                      color="good">
                      <AnimatedNumber value={data.brain_damage} />
                    </ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Состояние мозга"
                    color="health-0">
                    {data.brain_health}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Радиация">
                    {data.rad_status}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Процент облучения">
                    {data.rad_value}%
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Травмы головного мозга">
                    {data.trauma_status}
                  </LabeledList.Item>
                </Section>
              )}
            </Box>
          )}
        </Tabs.Tab>
        <Tabs.Tab
          key="tab_4"
          color="normal"
          label="Хим. анализ и психоактивное сканирование">
          {() => (
            <Box>
              {data.active_status_4 === 0 && (
                <Section title="Хим. и психоактивный анализ"
                  textAlign="center">
                  <LabeledList.Item label="Химикаты в крови">
                    {data.are_chems_present ? (
                      data.chemical_list.length ? (
                        data.chemical_list.map(specificChem => (
                          <Box
                            key={specificChem.id}
                            color="good" >
                            {specificChem.volume} единиц {specificChem.name}
                          </Box>
                        ))
                      ) : (
                        <Box>
                          Не обнаружено реагентов.
                        </Box>
                      )
                    ) : (
                      <Box color="average">
                        Не обнаружено реагентов.
                      </Box>
                    )}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Состояние передозировки"
                    color="bad">
                    {data.are_overdoses_present ? (
                      data.overdose_status.length ? (
                        data.overdose_status.map(specificOD => (
                          <Box key={specificOD.id}>
                            Передозировка {specificOD.name}
                          </Box>
                        ))
                      ) : (
                        <Box>
                          Не обнаружено реагентов.
                        </Box>
                      )
                    ) : (
                      <Box color="good">
                        Нет передозировки
                      </Box>
                    )}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Состояние зависимостей"
                    color="bad">
                    {data.are_addictions_present ? (
                      data.addiction_status.length ? (
                        data.addiction_status.map(specificAddict => (
                          <Box key={specificAddict.id}>
                            Зависимость от {specificAddict.name}
                          </Box>
                        ))
                      ) : (
                        <Box>
                          Нет зависимостей.
                        </Box>
                      )
                    ) : (
                      <Box color="good">
                        Нет зависимостей.
                      </Box>
                    )}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Психоактивное состояние">
                    {data.hallucinating_status}
                  </LabeledList.Item>
                </Section>
              )}
            </Box>
          )}
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
