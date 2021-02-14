import { useBackend, useSharedState } from '../backend';
import { Button, Section, Table, Modal, Flex } from '../components';
import { NtosWindow } from '../layouts';

export const NtosFileManager = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    usbconnected,
    files = [],
    usbfiles = [],
  } = data;
  return (
    <NtosWindow resizable theme={PC_device_theme}>
      <NtosWindow.Content scrollable>
        <Section>
          <FileTable
            files={files}
            usbconnected={usbconnected}
            onUpload={file => act('PRG_copytousb', { name: file })}
            onDelete={file => act('PRG_deletefile', { name: file })}
            onRename={(file, newName) => act('PRG_rename', {
              name: file,
              new_name: newName,
            })}
            onDuplicate={file => act('PRG_clone', { file: file })}
            onToggleSilence={file => act('PRG_togglesilence', { name: file })} />
        </Section>
        {usbconnected && (
          <Section title="Диск с данными">
            <FileTable
              usbmode
              files={usbfiles}
              usbconnected={usbconnected}
              onUpload={file => act('PRG_copyfromusb', { name: file })}
              onDelete={file => act('PRG_deletefile', { name: file })}
              onRename={(file, newName) => act('PRG_rename', {
                name: file,
                new_name: newName,
              })}
              onDuplicate={file => act('PRG_clone', { file: file })} />
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const FileTable = (props, context) => {
  const {
    files = [],
    usbconnected,
    usbmode,
    onUpload,
    onDelete,
    onRename,
    onToggleSilence,
  } = props;
  const [openedFile, setOpenedFile] = useSharedState(
    context, "opened_file", null);
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>
          Файл
        </Table.Cell>
        <Table.Cell collapsing>
          Тип
        </Table.Cell>
        <Table.Cell collapsing>
          Размер
        </Table.Cell>
      </Table.Row>
      {openedFile && <FileModal
        label={openedFile.name}
        sdata={openedFile.has_data}
        onBack={() => setOpenedFile(null)}
      />}
      {files.map(file => (
        <Table.Row key={file.name} className="candystripe">
          <Table.Cell>
            {!file.undeletable ? (
              <Button.Input
                fluid
                content={file.name}
                currentValue={file.name}
                tooltip="Переименовать"
                onCommit={(e, value) => onRename(file.name, value)} />
            ) : (
              file.name
            )}
          </Table.Cell>
          <Table.Cell>
            {file.type}
          </Table.Cell>
          <Table.Cell>
            {file.size}
          </Table.Cell>
          <Table.Cell collapsing>
            {!!file.has_data && (
              <Button
                icon="file"
                tooltip="Открыть"
                onClick={() => setOpenedFile(file)} />
            )}
            {!!file.alert_able && (
              <Button
                icon={file.alert_silenced ? 'bell-slash' : 'bell'}
                color={file.alert_silenced ? 'red' : 'default'}
                tooltip={file.alert_silenced ? 'Разоткнуть' : 'Заткнуть'}
                onClick={() => onToggleSilence(file.name)} />
            )}
            {!file.undeletable && (
              <>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="times"
                  confirmContent=""
                  tooltip="Удалить"
                  onClick={() => onDelete(file.name)} />
                {!!usbconnected && (
                  usbmode ? (
                    <Button
                      icon="download"
                      tooltip="Загрузить"
                      onClick={() => onUpload(file.name)} />
                  ) : (
                    <Button
                      icon="upload"
                      tooltip="Выгрузить"
                      onClick={() => onUpload(file.name)} />
                  )
                )}
              </>
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

const FileModal = props => {
  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}
        </Flex.Item>

        <Flex.Item mr={2} mb={1}>
          {props.sdata}
        </Flex.Item>

        <Flex.Item>
          <Button
            icon="times"
            content="Закрыть"
            color="bad"
            onClick={props.onBack}
          />
        </Flex.Item>
      </Flex>
    </Modal>
  );
};
