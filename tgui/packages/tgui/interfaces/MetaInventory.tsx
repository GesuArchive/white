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
    displayName: string;
    gridSpot: GridSpotKey;
    image?: string;
    additionalComponent?: JSX.Element;
  }
> = {
  "8": { displayName: "глаза", gridSpot: getGSK([0, 0]), image: "glasses.png" },
  "64": { displayName: "голова", gridSpot: getGSK([0, 1]), image: "head.png" },
  "4096": { displayName: "шея", gridSpot: getGSK([1, 0]), image: "neck.png" },
  "32": { displayName: "маска", gridSpot: getGSK([1, 1]), image: "mask.png" },
  "16": { displayName: "уши", gridSpot: getGSK([1, 2]), image: "ears.png" },
  "2": { displayName: "униформа", gridSpot: getGSK([2, 0]), image: "uniform.png" },
  "1": { displayName: "костюм", gridSpot: getGSK([2, 1]), image: "suit.png" },
  "4": { displayName: "перчатки", gridSpot: getGSK([2, 2]), image: "gloves.png" },
  "128": { displayName: "ботинки", gridSpot: getGSK([3, 1]), image: "shoes.png" },
  "32768": { displayName: "хранилище костюма", gridSpot: getGSK([3, 2]), image: "suit_storage.png" },
  "256": { displayName: "ID", gridSpot: getGSK([4, 0]), image: "id.png" },
  "512": { displayName: "пояс", gridSpot: getGSK([4, 1]), image: "belt.png" },
  "1024": { displayName: "спина", gridSpot: getGSK([4, 2]), image: "back.png" },
  "65536": { displayName: "левый карман", gridSpot: getGSK([4, 3]), image: "pocket.png" },
  "131072": { displayName: "правый карман", gridSpot: getGSK([4, 4]), image: "pocket.png" },
  "-1": { displayName: "левая рука", gridSpot: getGSK([2, 4]), image: "hand_l.png", additionalComponent: <CornerText align="right">Л</CornerText> },
  "-2": { displayName: "правая рука", gridSpot: getGSK([2, 3]), image: "hand_r.png", additionalComponent: <CornerText align="left">П</CornerText> },
  // аыыыыыыыыыыыы я дыбиииииииил
  "-3": { displayName: "пол", gridSpot: getGSK([0, 6]), image: "pocket.png" },
  "-4": { displayName: "пол", gridSpot: getGSK([1, 6]), image: "pocket.png" },
  "-5": { displayName: "пол", gridSpot: getGSK([2, 6]), image: "pocket.png" },
  "-6": { displayName: "пол", gridSpot: getGSK([3, 6]), image: "pocket.png" },
  "-7": { displayName: "пол", gridSpot: getGSK([4, 6]), image: "pocket.png" },
};

type MetaInvObj = {
  name: string;
  icon: string;
};

type MetaInvData = {
  items: Record<string, MetaInvObj>;
  loadout: Record<string, string>;
  slots: number;
};

const MetaInvLoadout = (loadoutprops, loadoutcontext) => {
  const { act, data } = useBackend<MetaInvData>(loadoutcontext);
  const gridSpots = new Map<GridSpotKey, string>();

  for (const slotkey of Object.keys(data.loadout)) {
    if (SLOTS[slotkey]) {
      gridSpots.set(SLOTS[slotkey].gridSpot, slotkey);
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

              const item_uid = data.loadout[keyAtSpot];
              const item = (item_uid && item_uid !== "0") ? data.items[item_uid] : null;
              const slot = SLOTS[keyAtSpot];

              let content;
              let tooltip;

              if (item === null) {
                tooltip = slot.displayName;
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
                        act("use", {
                          key: keyAtSpot,
                        });
                      }}
                      fluid
                      tooltip={tooltip}
                      style={{
                        background: undefined,
                        position: "relative",
                        width: "100%",
                        height: "100%",
                        padding: 0,
                      }}
                    >
                      {slot.image && (
                        <Box
                          as="img"
                          src={resolveAsset("inventory-" + slot.image)}
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
  )
};

export const MetaInventory = (props, context) => {
  const { act, data } = useBackend<MetaInvData>(context);
  return (
    <Window title={`Инвентарь`} width={50*(COLUMNS+1)} height={50*(ROWS+1)}>
      <Window.Content>
        <MetaInvLoadout
          loadoutprops={props}
          loadoutcontext={context}
        />


      </Window.Content>
    </Window>
  );
};

