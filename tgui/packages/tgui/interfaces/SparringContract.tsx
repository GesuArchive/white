import { BooleanLike } from 'common/react';
import { multiline } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Button, Dropdown, Section, Stack } from '../components';
import { Window } from '../layouts';

// defined this so the code is more readable
const STAKES_HOLY_MATCH = 1;

const weaponlist = [
  "Кулачный Бой",
  "Церемониальное Оружие",
  "Только Ближний Бой",
  "Любое Оружие",
];

const stakelist = [
  "Нет Ставок",
  "Святой Матч",
  "Матч на Деньги",
  "Насмерть",
];

const weaponblurb = [
  "Вы будете драться только кулаками. Любое оружие является нарушением.",
  "Сражаться можно только церемониальными оружием. Без него вы окажетесь в невыгодном положении!",
  "Вы можете сражаться оружием ближнего боя или кулаками, если у вас его нет. Оружие дальнего боя является нарушением.",
  "Вы можете сражаться любым оружием, как вам заблагорассудится. Постарайся не убить его, ладно?",
];

const stakesblurb = [
  "Никаких ставок, только для удовольствия. Кто не любит развлекательные спарринги?",
  "Под стать божеству капеллана. Капеллан терпит большие последствия за неудачу, но продвигает свою секту, побеждая.",
  "Матч с деньгами на кону. Кто выиграет, тот заберет все деньги того, кто проиграет.",
  "Смертельный поединок, в котором душа проигравшего становится собственностью победителя.",
];

type Info = {
  set_weapon: number;
  set_area: string;
  set_stakes: number;
  left_sign: string;
  right_sign: string;
  in_area: BooleanLike;
  no_chaplains: BooleanLike;
  possible_areas: Array<string>;
};

export const SparringContract = (props, context) => {
  const { data, act } = useBackend<Info>(context);
  const {
    set_weapon,
    set_area,
    set_stakes,
    possible_areas,
    left_sign,
    right_sign,
    in_area,
    no_chaplains,
  } = data;
  const [weapon, setWeapon] = useLocalState(context, "оружие", set_weapon);
  const [area, setArea] = useLocalState(context, "арена", set_area);
  const [stakes, setStakes] = useLocalState(context, "ставка", set_stakes);
  return (
    <Window
      width={420}
      height={380}>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Stack vertical>
                <Stack.Item>
                  <Stack fill>
                    <Stack.Item grow fontSize="16px">
                      Оружие:
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        tooltip={multiline`
                        Божество капеллана желает доблестного боя.
                        Для этого, он использует контракты. Подписание
                        контракта вашем именем подтвердит условия битвы.
                        Затем человек, с которым вы намерены провести 
                        спарринг, должен подписать другую сторону.
                        Если правила, уже подписанного договора, изменятся,     
                        то подписи сотрутся и новые условия должны быть
                        повторно подписаны.
                        `}
                        icon="info">
                        Контракт?
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="100%"
                    selected={weaponlist[weapon-1]}
                    options={weaponlist}
                    onSelected={value =>
                      setWeapon(weaponlist.findIndex(title => (
                        title === value
                      ))+1)} />
                </Stack.Item>
                <Stack.Item>
                  <BlockQuote>
                    {weaponblurb[weapon-1]}
                  </BlockQuote>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical>
                <Stack.Item fontSize="16px">
                  Арена:
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="100%"
                    selected={area}
                    options={possible_areas}
                    onSelected={value => setArea(value)} />
                </Stack.Item>
                <Stack.Item>
                  <BlockQuote>
                    Этот бой состоится в {area}.
                    Покидание арены во время боя является нарушением.
                  </BlockQuote>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical>
                <Stack.Item fontSize="16px">
                  Ставки:
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="100%"
                    selected={stakelist[stakes-1]}
                    options={stakelist}
                    onSelected={value =>
                      setStakes(stakelist.findIndex(title => (
                        title === value
                      ))+1)} />
                </Stack.Item>
                <Stack.Item>
                  <BlockQuote>
                    {stakesblurb[stakes-1]}
                  </BlockQuote>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item grow>
              <Stack grow textAlign="center">
                <Stack.Item
                  fontSize={left_sign !== "none" && "14px"}
                  grow>
                  {left_sign === 'none' && (
                    <Button
                      icon="pen"
                      onClick={() => act('sign', {
                        "weapon": weapon,
                        "area": area,
                        "stakes": stakes,
                        "sign_position": "left",
                      })}>
                      Подпиши здесь
                    </Button>
                  ) || (
                    left_sign
                  )}
                </Stack.Item>
                <Stack.Item fontSize="16px">
                  VS
                </Stack.Item>
                <Stack.Item
                  fontSize={right_sign !== "none" && "14px"}
                  grow>
                  {right_sign === "none" && (
                    <Button
                      icon="pen"
                      onClick={() => act('sign', {
                        "weapon": weapon,
                        "area": area,
                        "stakes": stakes,
                      })}>
                      Подпиши здесь
                    </Button>
                  ) || (
                    right_sign
                  )}
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item mb={-0.5}>
              <Stack fill>
                <Stack.Item grow>
                  <Button
                    disabled={
                      !in_area
                      || (no_chaplains && set_stakes === STAKES_HOLY_MATCH)
                    }
                    icon="fist-raised"
                    onClick={() => act('fight')} >
                    БОЙ!
                  </Button>
                  <Button
                    tooltip={multiline`
                    Если вы уже подписали, но хотите пересмотреть
                    условия, вы можете очистить подписи с помощью
                    этой кнопки.
                    `}
                    icon="door-open"
                    onClick={() => act('clear')} >
                    Очистить
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    tooltip={in_area
                      && "Оба участника присутствуют в "+ area + "."
                      || "Оба участника должны быть на арене!"}
                    color={in_area && "green" || "red"}
                    icon="ring" >
                    Арена
                  </Button>
                  <Button
                    tooltip={(left_sign !== "none" && right_sign !== "none")
                      && "Обе подписи присутствуют, условия согласованы."
                      || "Нужны подписи обоих бойцов на условиях!"}
                    color={(left_sign !== "none" && right_sign !== "none")
                      && "green"
                      || "red"}
                    icon="file-signature" >
                    Подписи
                  </Button>
                  <Button
                    tooltip={!no_chaplains
                      && "Капеллан присутствует. Святые матчи разрешены."
                      || "В этом бою нет капеллана. Святые матчи запрещены!"}
                    color={!no_chaplains && "green" || "yellow"}
                    icon="cross" >
                    Капеллан
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
