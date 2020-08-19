import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { CargoCatalog } from './Cargo';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const CargoExpress = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={600}
      height={700}
      resizable>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox
          accessText="ID-карта завхоза" />
        {!data.locked && (
          <CargoExpressContent />
        )}
      </Window.Content>
    </Window>
  );
};

const CargoExpressContent = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Fragment>
      <Section
        title="Снабжение экспресс"
        buttons={(
          <Box inline bold>
            <AnimatedNumber
              value={Math.round(data.points)} />
            {' кредитов'}
          </Box>
        )}>
        <LabeledList>
          <LabeledList.Item label="Точка приёма">
            <Button
              content="Отдел снабжения"
              selected={!data.usingBeacon}
              onClick={() => act('LZCargo')} />
            <Button
              selected={data.usingBeacon}
              disabled={!data.hasBeacon}
              onClick={() => act('LZBeacon')}>
              {data.beaconzone} ({data.beaconName})
            </Button>
            <Button
              content={data.printMsg}
              disabled={!data.canBuyBeacon}
              onClick={() => act('printBeacon')} />
          </LabeledList.Item>
          <LabeledList.Item label="Заметка">
            {data.message}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <CargoCatalog express />
    </Fragment>
  );
};
