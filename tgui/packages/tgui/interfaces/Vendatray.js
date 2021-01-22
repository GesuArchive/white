import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export const Vendatray = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    product_name,
    product_cost,
    tray_open,
    registered,
    owner_name,
  } = data;
  return (
    <Window
      width={300}
      height={270}>
      <Window.Content>
        <Flex
          mb={1}>
          <Flex.Item
            mr={1}>
            {!!product_name && (
              <VendingImage />
            )}
          </Flex.Item>
          <Flex.Item
            grow={1}>
            <Section
              fontSize="18px"
              align="center">
              <b>{product_name ? product_name : "Пусто"}</b>
              <Box fontSize="16px">
                <i>{product_name ? product_cost : "N/A"} cr </i>
                <Button
                  icon="pen"
                  onClick={() => act('Adjust')} />
              </Box>
            </Section>
            <>
              <Button
                fluid
                icon="window-restore"
                content={tray_open ? 'Открыто' : 'Закрыто'}
                selected={tray_open}
                onClick={() => act('Open')} />
              <Button.Confirm
                fluid
                icon="money-bill-wave"
                content="Купить"
                disabled={!product_name}
                onClick={() => act('Buy')} />
            </>
          </Flex.Item>
        </Flex>
        {registered?(
          <Section italics>
            Платёж отправляется {owner_name}.
          </Section>
        ):(
          <>
            <Section>
              Не зарегистрировано.
            </Section>
            <Button
              fluid
              icon="cash-register"
              content="Зарегистрировать"
              disabled={registered}
              onClick={() => act('Register')} />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const VendingImage = (props, context) => {
  const { data } = useBackend(context);
  const {
    product_icon,
  } = data;
  return (
    <Section height="100%">
      <Box as="img"
        m={1}
        src={`data:image/jpeg;base64,${product_icon}`}
        height="96px"
        width="96px"
        style={{
          '-ms-interpolation-mode': 'nearest-neighbor',
          'vertical-align': 'middle',
        }} />
    </Section>
  );
};
