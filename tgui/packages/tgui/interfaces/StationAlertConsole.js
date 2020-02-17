import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Section } from '../components';

export const StationAlertConsole = props => {
  const { data } = useBackend(props);
  const categories = data.alarms || [];
  const fire = categories['Fire'] || [];
  const atmos = categories['Atmosphere'] || [];
  const power = categories['Power'] || [];
  return (
    <Fragment>
      <Section title="Пожарные тревоги">
        <ul>
          {fire.length === 0 && (
            <li className="color-good">
              Системы в норме
            </li>
          )}
          {fire.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="Атмосферные тревоги">
        <ul>
          {atmos.length === 0 && (
            <li className="color-good">
              Системы в норме
            </li>
          )}
          {atmos.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="Энергетические тревоги">
        <ul>
          {power.length === 0 && (
            <li className="color-good">
              Системы в норме
            </li>
          )}
          {power.map(alert => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
    </Fragment>
  );
};
