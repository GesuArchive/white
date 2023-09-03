import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';
import { useBackend } from '../../backend';
import { Button, LabeledList, NumberInput, Section } from '../../components';
import { getGasLabel } from '../../constants';

export type VentProps = {
  refID: string;
  long_name: string;
  power: BooleanLike;
  checks: number;
  excheck: BooleanLike;
  incheck: BooleanLike;
  direction: number;
  external: number;
  internal: number;
  extdefault: number;
  intdefault: number;
};

export type ScrubberProps = {
  refID: string;
  long_name: string;
  power: BooleanLike;
  scrubbing: BooleanLike;
  widenet: BooleanLike;
  filter_types: {
    gas_id: string;
    gas_name: string;
    enabled: BooleanLike;
  }[];
};

export const Vent = (props: VentProps, context) => {
  const { act } = useBackend(context);
  const {
    refID,
    long_name,
    power,
    checks,
    excheck,
    incheck,
    direction,
    external,
    internal,
    extdefault,
    intdefault,
  } = props;
  return (
    <Section
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          selected={power}
          content={power ? 'Вкл' : 'Выкл'}
          onClick={() =>
            act('power', {
              ref: refID,
              val: Number(!power),
            })
          }
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Режим">
          <Button
            icon="sign-in-alt"
            content={direction ? 'Выдув' : 'Вдув'}
            color={!direction && 'danger'}
            onClick={() =>
              act('direction', {
                ref: refID,
                val: Number(!direction),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Регулятор давления">
          <Button
            icon="sign-in-alt"
            content="Внутреннее"
            selected={incheck}
            onClick={() =>
              act('incheck', {
                ref: refID,
                val: checks,
              })
            }
          />
          <Button
            icon="sign-out-alt"
            content="Внешнее"
            selected={excheck}
            onClick={() =>
              act('excheck', {
                ref: refID,
                val: checks,
              })
            }
          />
        </LabeledList.Item>
        {!!incheck && (
          <LabeledList.Item label="Внутреннее целевое">
            <NumberInput
              value={Math.round(internal)}
              unit="кПа"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) =>
                act('set_internal_pressure', {
                  ref: refID,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={intdefault}
              content="Сброс"
              onClick={() =>
                act('reset_internal_pressure', {
                  ref: refID,
                })
              }
            />
          </LabeledList.Item>
        )}
        {!!excheck && (
          <LabeledList.Item label="Внешнее целевое">
            <NumberInput
              value={Math.round(external)}
              unit="кПа"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(e, value) =>
                act('set_external_pressure', {
                  ref: refID,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={extdefault}
              content="Сброс"
              onClick={() =>
                act('reset_external_pressure', {
                  ref: refID,
                })
              }
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const Scrubber = (props: ScrubberProps, context) => {
  const { act } = useBackend(context);
  const { long_name, power, scrubbing, refID, widenet, filter_types } = props;
  return (
    <Section
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          content={power ? 'Вкл' : 'Выкл'}
          selected={power}
          onClick={() =>
            act('power', {
              ref: refID,
              val: Number(!power),
            })
          }
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            content={scrubbing ? 'Фильтрация' : 'Выкачивание'}
            onClick={() =>
              act('scrubbing', {
                ref: refID,
                val: Number(!scrubbing),
              })
            }
          />
          <Button
            icon={widenet ? 'expand' : 'compress'}
            selected={widenet}
            content={widenet ? 'Расширенный радиус' : 'Нормальный радиус'}
            onClick={() =>
              act('widenet', {
                ref: refID,
                val: Number(!widenet),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Фильтры">
          {(scrubbing &&
            filter_types.map((filter) => (
              <Button
                key={filter.gas_id}
                icon={filter.enabled ? 'check-square-o' : 'square-o'}
                content={getGasLabel(filter.gas_id, filter.gas_name)}
                title={filter.gas_name}
                selected={filter.enabled}
                onClick={() =>
                  act('toggle_filter', {
                    ref: refID,
                    val: filter.gas_id,
                  })
                }
              />
            ))) ||
            'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
