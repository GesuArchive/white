import { resolveAsset } from '../assets';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

type PaintingAdminPanelData = {
  paintings: PaintingData[];
};

type PaintingData = {
  md5: string,
  title: string,
  creator_ckey: string,
  creator_name: string | null,
  creation_date: Date | null,
  creation_round_id: number | null,
  patron_ckey: string | null,
  patron_name: string | null,
  credit_value: number,
  width: number,
  height: number,
  ref: string,
  tags: string[] | null,
  medium: string | null
}

export const PaintingAdminPanel = (props, context) => {
  const { act, data } = useBackend<PaintingAdminPanelData>(context);
  const [chosenPaintingRef, setChosenPaintingRef] = useLocalState<string|null>(context, 'chosenPainting', null);
  const {
    paintings,
  } = data;
  const chosenPainting = paintings.find(p => p.ref === chosenPaintingRef);
  return (
    <Window
      title="Управление картинами"
      width={800}
      height={600}>
      <Window.Content scrollable>
        {chosenPainting && (
          <Section title="Информация о картине" buttons={<Button onClick={() => setChosenPaintingRef(null)}>Close</Button>}>
            <img
              src={resolveAsset(`paintings_${chosenPainting.md5}`)}
              height="96px"
              width="96px"
              style={{
                'vertical-align': 'middle',
                '-ms-interpolation-mode': 'nearest-neighbor',
              }} />
            <LabeledList>
              <LabeledList.Item label="md5" content={chosenPainting.md5} />
              <LabeledList.Item label="название">
                <Box inline>{chosenPainting.title}</Box>
                <Button onClick={() => act("rename", { ref: chosenPainting.ref })} icon="edit" />
              </LabeledList.Item>
              <LabeledList.Item label="сикей автора" content={chosenPainting.creator_ckey} />
              <LabeledList.Item label="имя автора">
                <Box inline>{chosenPainting.creator_name}</Box>
                <Button onClick={() => act("rename_author", { ref: chosenPainting.ref })} icon="edit" />
              </LabeledList.Item>
              <LabeledList.Item label="дата создания" content={chosenPainting.creation_date} />
              <LabeledList.Item label="раунд создания" content={chosenPainting.creation_round_id} />
              <LabeledList.Item label="медиум" content={chosenPainting.medium} />
              <LabeledList.Item label="теги">
                {chosenPainting.tags?.map((tag) => (
                  <Button
                    key={tag}
                    color="red"
                    icon="minus-circle"
                    iconPosition="right" content={tag}
                    onClick={() => act("remove_tag", { tag, ref: chosenPainting.ref })} />
                ))}
                <Button
                  color="green"
                  icon="plus-circle"
                  onClick={() => act("add_tag", { ref: chosenPainting.ref })} />
              </LabeledList.Item>
              <LabeledList.Item label="сикей спонсора" content={chosenPainting.patron_ckey} />
              <LabeledList.Item label="имя спонсора" content={chosenPainting.patron_name} />
              <LabeledList.Item label="стоимость" content={chosenPainting.credit_value} />
              <LabeledList.Item label="ширина" content={chosenPainting.width} />
              <LabeledList.Item label="высота" content={chosenPainting.height} />
            </LabeledList>
            <Section title="Действия">
              <Button.Confirm onClick={() => { setChosenPaintingRef(null); act("delete", { ref: chosenPainting.ref }); }}>Удалить</Button.Confirm>
              <Button onClick={() => act("dumpit", { ref: chosenPainting.ref })}>Сбросить спонсора</Button>
            </Section>
          </Section>
        )}
        {!chosenPainting && (
          <Table>
            <Table.Row>
              <Table.Cell color="label">Название</Table.Cell>
              <Table.Cell color="label">Автор</Table.Cell>
              <Table.Cell color="label">Превью</Table.Cell>
              <Table.Cell color="label">Действия</Table.Cell>
            </Table.Row>
            {paintings.map(painting => (
              <Table.Row
                key={painting.ref}
                className="candystripe">
                <Table.Cell>{painting.title}</Table.Cell>
                <Table.Cell>{painting.creator_ckey}</Table.Cell>
                <Table.Cell><img
                  src={resolveAsset(`paintings_${painting.md5}`)}
                  height="36px"
                  width="36px"
                  style={{
                    'vertical-align': 'middle',
                    '-ms-interpolation-mode': 'nearest-neighbor',
                  }} />
                </Table.Cell>
                <Table.Cell>
                  <Button onClick={() => setChosenPaintingRef(painting.ref)}>
                    Редактировать
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        )}
      </Window.Content>
    </Window>
  );
};
