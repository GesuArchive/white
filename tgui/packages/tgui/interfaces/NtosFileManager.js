import { useBackend, useSharedState } from '../backend';
import { Button, Section, Table, Modal, Flex, Box } from '../components';
import { NtosWindow } from '../layouts';

export const NtosFileManager = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    usbconnected,
    files = [],
    usbfiles = [],
  } = data;
  const [openedFile, setOpenedFile] = useSharedState(
    context, "opened_file", null);
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
            onOpenfile={file => setOpenedFile(file)}
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
        {openedFile && <FileModal
          label={openedFile.name}
          sdata={openedFile.has_data}
          onBack={() => setOpenedFile(null)}
        />}
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
    onOpenfile
  } = props;
  return (
    <Table>
      <Table.Row header>
        <Table.Cell collapsing />
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
      {files.map(file => (
        <Table.Row key={file.name} className="candystripe">
          <Table.Cell>
            {!!file.has_data && (
              <Button
                icon="file"
                tooltip="Открыть"
                tooltipPosition="right"
                onClick={() => onOpenfile(file)} />
            )}
          </Table.Cell>
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
  const text_html = {
    __html: '<span class="paper-text">'
      + props.sdata
      + '</span>',
  };
  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}
        </Flex.Item>

        <Flex.Item mr={2} mb={2} mt={1}>
          <Box
              p={1}
              fluid
              overflowY="scroll"
              height="60vh"
              width="80vw"
              backgroundColor="black"
              textColor="green"
              dangerouslySetInnerHTML={text_html}
            />
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
