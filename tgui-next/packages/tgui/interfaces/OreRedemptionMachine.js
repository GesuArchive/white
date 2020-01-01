import { toTitleCase } from 'common/string';
import { Component, Fragment } from 'inferno';
import { useBackend } from '../backend';
import { BlockQuote, Box, Button, NumberInput, Section, Table } from '../components';

export const OreRedemptionMachine = props => {
  const { act, data } = useBackend(props);
  const {
    unclaimedPoints,
    materials,
    alloys,
    diskDesigns,
    hasDisk,
  } = data;
  return (
    <Fragment>
      <Section>
        <BlockQuote mb={1}>
          Эта машина принимает только руду.<br />
          Гибтонит и шлак не принимаются.
        </BlockQuote>
        <Box>
          <Box inline color="label" mr={1}>
           Невостребованные очки:
          </Box>
          {unclaimedPoints}
          <Button
            ml={2}
            content="Claim"
            disabled={unclaimedPoints === 0}
            onClick={() => act('Claim')} />
        </Box>
      </Section>
      <Section>
        {hasDisk && (
          <Fragment>
            <Box mb={1}>
              <Button
                icon="eject"
                content="Изъять диск"
                onClick={() => act('diskEject')} />
            </Box>
            <Table>
              {diskDesigns.map(design => (
                <Table.Row key={design.index}>
                  <Table.Cell>
                    File {design.index}: {design.name}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      disabled={!design.canupload}
                      content="Загрузить"
                      onClick={() => act('diskUpload', {
                        design: design.index,
                      })} />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Fragment>
        ) || (
          <Button
            icon="save"
            content="Вставить диск"
            onClick={() => act('diskInsert')} />
        )}
      </Section>
      <Section title="Материалы">
        <Table>
          {materials.map(material => (
            <MaterialRow
              key={material.id}
              material={material}
              onRelease={amount => act('Release', {
                id: material.id,
                sheets: amount,
              })} />
          ))}
        </Table>
      </Section>
      <Section title="Сплавы">
        <Table>
          {alloys.map(material => (
            <MaterialRow
              key={material.id}
              material={material}
              onRelease={amount => act('Smelt', {
                id: material.id,
                sheets: amount,
              })} />
          ))}
        </Table>
      </Section>
    </Fragment>
  );
};

class MaterialRow extends Component {
  constructor() {
    super();
    this.state = {
      amount: 1,
    };
  }

  render() {
    const { amount } = this.state;
    const { material, onRelease } = this.props;
    const amountAvailable = Math.floor(material.amount);
    return (
      <Table.Row>
        <Table.Cell>
          {toTitleCase(material.name).replace('Alloy', '')}
        </Table.Cell>
        <Table.Cell collapsing textAlign="right">
          <Box mr={2} color="label" inline>
            {material.value && material.value + ' кр'}
          </Box>
        </Table.Cell>
        <Table.Cell collapsing textAlign="right">
          <Box mr={2} color="label" inline>
            {amountAvailable} листов
          </Box>
        </Table.Cell>
        <Table.Cell collapsing>
          <NumberInput
            width="32px"
            step={1}
            stepPixelSize={5}
            minValue={1}
            maxValue={50}
            value={amount}
            onChange={(e, value) => this.setState({
              amount: value,
            })} />
          <Button
            disabled={amountAvailable < 1}
            content="Выдать"
            onClick={() => onRelease(amount)} />
        </Table.Cell>
      </Table.Row>
    );
  }
}
