import { range } from "../../common/collections";
import { BooleanLike } from "../../common/react";
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Button, Icon, Stack } from "../components";
import { Window } from "../layouts";

const ROWS = 5;
const COLUMNS = 6;

const BUTTON_DIMENSIONS = "50px";

type GridSpotKey = string;

const getGridSpotKey = (spot: [number, number]): GridSpotKey => {
  return `${spot[0]}/${spot[1]}`;
};

const CornerText = (props: {
  align: "left" | "right";
  children: string;
}): Element => {
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
    additionalComponent?: Element;
  }
> = {
  "8": {
    displayName: "глаза",
    gridSpot: getGridSpotKey([0, 1]),
    image: "inventory-glasses.png",
  },

  "64": {
    displayName: "голова",
    gridSpot: getGridSpotKey([0, 2]),
    image: "inventory-head.png",
  },

  "4096": {
    displayName: "шея",
    gridSpot: getGridSpotKey([1, 1]),
    image: "inventory-neck.png",
  },

  "32": {
    displayName: "маска",
    gridSpot: getGridSpotKey([1, 2]),
    image: "inventory-mask.png",
  },

  "16": {
    displayName: "уши",
    gridSpot: getGridSpotKey([1, 3]),
    image: "inventory-ears.png",
  },

  "2": {
    displayName: "униформа",
    gridSpot: getGridSpotKey([2, 1]),
    image: "inventory-uniform.png",
  },

  "1": {
    displayName: "костюм",
    gridSpot: getGridSpotKey([2, 2]),
    image: "inventory-suit.png",
  },

  "4": {
    displayName: "перчатки",
    gridSpot: getGridSpotKey([2, 3]),
    image: "inventory-gloves.png",
  },

  "-4": {
    displayName: "правая рука",
    gridSpot: getGridSpotKey([2, 4]),
    image: "inventory-hand_r.png",
    additionalComponent: <CornerText align="left" children={""}>П</CornerText>,
  },

  "-3": {
    displayName: "левая рука",
    gridSpot: getGridSpotKey([2, 5]),
    image: "inventory-hand_l.png",
    additionalComponent: <CornerText align="right" children={""}>Л</CornerText>,
  },

  "128": {
    displayName: "ботинки",
    gridSpot: getGridSpotKey([3, 2]),
    image: "inventory-shoes.png",
  },

  "": {
    displayName: "хранилище костюма",
    gridSpot: getGridSpotKey([4, 0]),
    image: "inventory-suit_storage.png",
  },

  "256": {
    displayName: "ID",
    gridSpot: getGridSpotKey([4, 1]),
    image: "inventory-id.png",
  },

  "512": {
    displayName: "пояс",
    gridSpot: getGridSpotKey([4, 2]),
    image: "inventory-belt.png",
  },

  "1024": {
    displayName: "спина",
    gridSpot: getGridSpotKey([4, 3]),
    image: "inventory-back.png",
  },

  "65536": {
    displayName: "левый карман",
    gridSpot: getGridSpotKey([4, 4]),
    image: "inventory-pocket.png",
  },

  "131072": {
    displayName: "правый карман",
    gridSpot: getGridSpotKey([4, 5]),
    image: "inventory-pocket.png",
  },
/*
  "-2": {
    displayName: "пол",
    gridSpot: getGridSpotKey([4, 6]),
    image: "inventory-pocket.png",
  },

  "-1": {
    displayName: "курсор",
    gridSpot: getGridSpotKey([4, 7]),
    image: "inventory-pocket.png",
  },

  "0": {
    displayName: "инвентарь",
    gridSpot: getGridSpotKey([4, 8]),
    image: "inventory-pocket.png",
  },
*/
};

type MetaInvObj = {
  icon: string;
  name: string;
};

type MetaInvData = {
  items: Record<string, MetaInvObj>;
  loadout: Record<string, string>;
  slots: number;
};

export const MetaInventory = (props, context) => {
  const { act, data } = useBackend<MetaInvData>(context);

  const gridSpots = new Map<GridSpotKey, string>();

  for (const slotkey of Object.keys(data.loadout)) {
    if(SLOTS[slotkey]){
      gridSpots.set(SLOTS[slotkey].gridSpot, data.loadout[slotkey]);
    }
  }


  return (
    <Window title={`Инвентарь`} width={340} height={350}>
      <Window.Content>
        <Stack fill vertical>
          {range(0, ROWS).map(row => (
            <Stack.Item key={row}>
              <Stack fill>
                {range(0, COLUMNS).map(column => {
                  const key = getGridSpotKey([row, column]);
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

                  //const item = data.items[keyAtSpot][1];
                  const slot = SLOTS[keyAtSpot];

                  let content;
                  let tooltip;
                  /*
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
                  */

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
                            /*
                            background: item?.interacting
                              ? "hsl(39, 73%, 30%)"
                              : undefined,
                            */
                            position: "relative",
                            width: "100%",
                            height: "100%",
                            padding: 0,
                          }}
                        >
                          {slot.image && (
                            <Box
                              as="img"
                              src={resolveAsset(slot.image)}
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
      </Window.Content>
    </Window>
  );
};

