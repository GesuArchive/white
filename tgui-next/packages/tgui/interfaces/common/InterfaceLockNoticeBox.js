import { Button, Flex, NoticeBox } from '../../components';

export const InterfaceLockNoticeBox = props => {
  const {
    siliconUser,
    locked,
    onLockStatusChange,
    accessText,
  } = props;
  // For silicon users
  if (siliconUser) {
    return (
      <NoticeBox>
        <Flex align="center">
          <Flex.Item>
            Состояние блокировки интерфейса:
          </Flex.Item>
          <Flex.Item grow={1} />
          <Flex.Item>
            <Button
              m={0}
              color="gray"
              icon={locked ? 'lock' : 'unlock'}
              content={locked ? 'Заблокирован' : 'Разблокирован'}
              onClick={() => {
                if (onLockStatusChange) {
                  onLockStatusChange(!locked);
                }
              }} />
          </Flex.Item>
        </Flex>
      </NoticeBox>
    );
  }
  // For everyone else
  return (
    <NoticeBox>
      Проведите {accessText || 'картой'}{' '}
      для {locked ? 'разблокировки' : 'блокировки'} этого интерфейса.
    </NoticeBox>
  );
};
