import { range } from "../../common/collections";
import { BooleanLike } from "../../common/react";
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Button, Icon, Stack } from "../components";
import { Window } from "../layouts";

const ROWS = 6;
const COLUMNS = 8;

const BUTTON_DIMENSIONS = "50px";

type GridSpotKey = string;

// getGridSpotKey, переименовал потомушто смешной линт 80 символов на строку
const getGSK = (spot: [number, number]): GridSpotKey => {
  return `${spot[0]}/${spot[1]}`;
};

const CornerText = (props: {
  align: "left" | "right";
  children: string;
}): JSX.Element => {
  const { align, children } = props;

  return (
    <Box
      style={{
        position: "relative",
        left: align === "left" ? "2px" : "-2px",
        "text-align": align,
        "text-shadow": "1px 1px 1px #555",
      }}
    >
      {children}
    </Box>
  );
};

const SLOTS: Record<
  string,
  {
    dN: string; // displayName
    gS: GridSpotKey; // gridSpot
    i?: string; // image
    additionalComponent?: JSX.Element;
  }
> = {
  "8": { dN: "глаза", gS: getGSK([0, 0]), i: "glasses.png" },
  "64": { dN: "голова", gS: getGSK([0, 1]), i: "head.png" },
  "4096": { dN: "шея", gS: getGSK([1, 0]), i: "neck.png" },
  "32": { dN: "маска", gS: getGSK([1, 1]), i: "mask.png" },
  "16": { dN: "уши", gS: getGSK([1, 2]), i: "ears.png" },
  "2": { dN: "униформа", gS: getGSK([2, 0]), i: "uniform.png" },
  "1": { dN: "костюм", gS: getGSK([2, 1]), i: "suit.png" },
  "4": { dN: "перчатки", gS: getGSK([2, 2]), i: "gloves.png" },
  "128": { dN: "ботинки", gS: getGSK([3, 1]), i: "shoes.png" },
  "32768": { dN: "хранилище костюма", gS: getGSK([3, 2]), i: "suit_storage.png" },
  "256": { dN: "ID", gS: getGSK([4, 0]), i: "id.png" },
  "512": { dN: "пояс", gS: getGSK([4, 1]), i: "belt.png" },
  "1024": { dN: "спина", gS: getGSK([4, 2]), i: "back.png" },
  "65536": { dN: "левый карман", gS: getGSK([4, 3]), i: "pocket.png" },
  "131072": { dN: "правый карман", gS: getGSK([4, 4]), i: "pocket.png" },
  "-1": { dN: "левая рука", gS: getGSK([2, 4]), i: "hand_l.png",
    additionalComponent: <CornerText align="right">Л</CornerText> },
  "-2": { dN: "правая рука", gS: getGSK([2, 3]), i: "hand_r.png",
    additionalComponent: <CornerText align="left">П</CornerText> },
  // аыыыыыыыыыыыы я дыбиииииииил
  "-3": { dN: "пол", gS: getGSK([0, 6]), i: "pocket.png" },
  "-4": { dN: "пол", gS: getGSK([1, 6]), i: "pocket.png" },
  "-5": { dN: "пол", gS: getGSK([2, 6]), i: "pocket.png" },
  "-6": { dN: "пол", gS: getGSK([3, 6]), i: "pocket.png" },
  "-7": { dN: "пол", gS: getGSK([4, 6]), i: "pocket.png" },
};

// ебал линтер
const MetaInvLoadout=(
  act,
  loadout:MetaInvLoadoutData,
  objects:Array<MetaInvObj>
) => {

  const ID2ObjAssoc = new Map(objects.map(
    obj => [obj.id, obj] as [string, MetaInvObj]
  ));

  const gridSpots = new Map<GridSpotKey, string>();

  for (const slotkey of Object.keys(loadout)) {
    if (SLOTS[slotkey]) {
      gridSpots.set(SLOTS[slotkey].gS, slotkey);
    }
  }

  return (
    <Stack fill vertical>
      {range(0, ROWS).map(row => (
        <Stack.Item key={row}>
          <Stack fill>
            {range(0, COLUMNS).map(column => {
              const key = getGSK([row, column]);
              const keyAtSpot = gridSpots.get(key);

              if (!keyAtSpot) {
                return (
                  <Stack.Item
                    key={key}
                    style={{
                      width: BUTTON_DIMENSIONS,
                      height: BUTTON_DIMENSIONS,
                    }}
                  />
                );
              }

              const item_id = loadout[keyAtSpot];
              const item:MetaInvObj
                = (item_id && item_id !== "0")
                  ? ID2ObjAssoc.get(item_id)
                  : null;
              const slot = SLOTS[keyAtSpot];

              let content;
              let tooltip;

              if (item === null || item === undefined) {
                tooltip = slot.dN;
              } else if ("name" in item) {
                content = (
                  <Box
                    as="img"
                    src={`data:image/jpeg;base64,${item.icon}`}
                    height="100%"
                    width="100%"
                    style={{
                      "-ms-interpolation-mode": "nearest-neighbor",
                      "vertical-align": "middle",
                    }}
                  />
                );
                tooltip = item.name;
              }


              return (
                <Stack.Item
                  key={key}
                  style={{
                    width: BUTTON_DIMENSIONS,
                    height: BUTTON_DIMENSIONS,
                  }}
                >
                  <Box
                    style={{
                      position: "relative",
                      width: "100%",
                      height: "100%",
                    }}
                  >
                    <Button
                      onClick={() => {
                        act("loadoutSlotClick", {
                          key: keyAtSpot,
                        });
                      }}
                      flid
                      tooltip={tooltip}
                      style={{
                        background: undefined,
                        position: "relative",
                        width: "100%",
                        height: "100%",
                        padding: 0,
                      }}
                    >
                      {slot.i && (
                        <Box
                          as="img"
                          src={resolveAsset("inventory-" + slot.i)}
                          opacity={0.7}
                          style={{
                            position: "absolute",
                            width: "32px",
                            height: "32px",
                            left: "50%",
                            top: "50%",
                            transform:
                              "translateX(-50%) translateY(-50%) scale(0.8)",
                          }}
                        />
                      )}

                      <Box style={{ position: "relative" }}>
                        {content}
                      </Box>

                      {slot.additionalComponent}
                    </Button>
                  </Box>
                </Stack.Item>
              );
            })}
          </Stack>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ItemSlot = (act, slotID, item:MetaInvObj, active_slot) => {
  let content;
  let tooltip;

  if (item !== null && typeof(item) !== 'undefined') {
    content = (
      <Box
        as="img"
        src={`data:image/jpeg;base64,${item.icon}`}
        height="100%"
        width="100%"
        style={{
          "-ms-interpolation-mode": "nearest-neighbor",
          "vertical-align": "middle",
        }}
      />
    );
    tooltip = item.name;
  }

  return (
    <Box
      style={{
        position: "relative",
        width: "100%",
        height: "100%",
      }}
    >
      <Button
        onClick={() => {
          act("invSlotClick", {
            key: slotID,
          });
        }}
        flid
        tooltip={tooltip}
        style={{
          background: slotID === active_slot
            ? "hsl(39, 73%, 30%)"
            : undefined,
          position: "relative",
          width: "100%",
          height: "100%",
          padding: 0,
        }}
      >
        <Box
          as="img"
          src={resolveAsset("inventory-pocket.png")}
          opacity={0.7}
          style={{
            position: "absolute",
            width: "32px",
            height: "32px",
            left: "50%",
            top: "50%",
            transform:
                "translateX(-50%) translateY(-50%) scale(0.8)",
          }}
        />
        <Box style={{ position: "relative" }}>
          {content}
        </Box>
      </Button>
    </Box>
  );
};

const MetaInvItems = (act, objects:Array<MetaInvObj>, slots, active_slot) => {
  const slotRows = Math.ceil(slots/COLUMNS);
  return (
    <Stack fill vertical>
      {range(0, slotRows).map(row => (
        <Stack.Item key={row}>
          <Stack fill>
            {range(0, COLUMNS).map(column => {
              const cur_num = row * COLUMNS + column + 1;
              const curItem: MetaInvObj = objects[cur_num-1];
              return (
                <Stack.Item
                  key={column}
                  style={{
                    width: BUTTON_DIMENSIONS,
                    height: BUTTON_DIMENSIONS,
                  }}
                >
                  {
                    (cur_num <= slots)
                      ? ItemSlot(act, cur_num, curItem, active_slot)
                      : null
                  }
                </Stack.Item>
              );
            })}
          </Stack>
        </Stack.Item>
      ))}
    </Stack>);


};

type MetaInvData = {
  objects: Array<MetaInvObj>;
  loadout: MetaInvLoadoutData;
  slots: number;
  active_slot: number;
};

type MetaInvObj = {
  id: string;
  name: string;
  icon: string;
};

type MetaInvLoadoutData = Record<string, string>;

export const MetaInventory = (props, context) => {
  const { act, data } = useBackend<MetaInvData>(context);

  const slotRows = Math.ceil(data.slots/COLUMNS);
  return (
    <Window
      title={`Инвентарь (не забудь сохранить в меню)`}
      width={50*(COLUMNS+1) + 5}
      height={50*(ROWS+1) + 50*(slotRows+1)}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {MetaInvLoadout(act, data.loadout, data.objects)}
          </Stack.Item>
          <Stack.Item>
            {MetaInvItems(act, data.objects, data.slots, data.active_slot)}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

