import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, Flex, Input, Section, Box, Tabs, Icon, WdMap } from '../components';
import { Window } from '../layouts';

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
export const prevNextCamera = (cameras, activeCamera) => {
  if (!activeCamera) {
    return [];
  }
  const index = cameras.findIndex(
    (camera) => camera.name === activeCamera.name
  );
  return [cameras[index - 1]?.name, cameras[index + 1]?.name];
};

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
export const selectCameras = (cameras, searchText = '') => {
  const testSearch = createSearch(searchText, (camera) => camera.name);
  return flow([
    // Null camera filter
    filter((camera) => camera?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy((camera) => camera.name),
  ])(cameras);
};

export const CameraConsole = (props, context) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const decideTab = index => {
    switch (index) {
      case 0:
        return <CameraConsoleNewMapContent />;
      case 1:
        return <CameraConsoleOldMapContent />;
      default:
        return "WE SHOULDN'T BE HERE!";
    }
  };

  return (
    <Window width={1100} height={600}>
      <Window.Content>
        <Box fillPositionedParent overflow="hidden">
          <Tabs className="CameraConsole__header">
            <Tabs.Tab
              key="Map"
              selected={0 === tabIndex}
              onClick={() => setTabIndex(0)}>
              <Icon name="map-marked-alt" /> Карта
            </Tabs.Tab>
            <Tabs.Tab
              key="List"
              selected={1 === tabIndex}
              onClick={() => setTabIndex(1)}>
              <Icon name="table" /> Список
            </Tabs.Tab>
          </Tabs>
          {decideTab(tabIndex)}
        </Box>
      </Window.Content>
    </Window>
  );
};

export const CameraConsoleNewMapContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [prevCameraName, nextCameraName] = prevNextCamera(
    cameras,
    activeCamera
  );
  return (
    <Box>
      <div className="CameraConsole__left CameraConsole__left_long">
        <Window.Content>
          <WdMap>
            {cameras.map(cm => (
              <WdMap.WdButton
                activeCamera={activeCamera}
                key={cm.ref}
                x={cm.x}
                y={cm.y}
                context={context}
                icon="circle"
                tooltip={cm.name}
                name={cm.name}
                color={"#0000ff"}
                status={cm.status}
              />
            ))}
          </WdMap>
        </Window.Content>
      </div>
      <div className="CameraConsole__right CameraConsole__right_short">
        <div className="CameraConsole__toolbar">
          <b>Камера: </b>
          {(activeCamera && activeCamera.name) || '—'}
        </div>
        <div className="CameraConsole__toolbarRight">
          <Button
            icon="chevron-left"
            disabled={!prevCameraName}
            onClick={() =>
              act('switch_camera', {
                name: prevCameraName,
              })
            }
          />
          <Button
            icon="chevron-right"
            disabled={!nextCameraName}
            onClick={() =>
              act('switch_camera', {
                name: nextCameraName,
              })
            }
          />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </div>
    </Box>
  );
};

export const CameraConsoleOldMapContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [prevCameraName, nextCameraName] = prevNextCamera(
    cameras,
    activeCamera
  );
  return (
    <Box>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <CameraConsoleContent />
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <div className="CameraConsole__toolbar">
          <b>Камера: </b>
          {(activeCamera && activeCamera.name) || '—'}
        </div>
        <div className="CameraConsole__toolbarRight">
          <Button
            icon="chevron-left"
            disabled={!prevCameraName}
            onClick={() =>
              act('switch_camera', {
                name: prevCameraName,
              })
            }
          />
          <Button
            icon="chevron-right"
            disabled={!nextCameraName}
            onClick={() =>
              act('switch_camera', {
                name: nextCameraName,
              })
            }
          />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </div>
    </Box>
  );
};

export const CameraConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
  const { activeCamera } = data;
  const cameras = selectCameras(data.cameras, searchText);
  return (
    <Flex direction={'column'} height="100%">
      <Flex.Item>
        <Input
          autoFocus
          fluid
          mt={1}
          placeholder="Искать камеру"
          onInput={(e, value) => setSearchText(value)}
        />
      </Flex.Item>
      <Flex.Item height="100%">
        <Section fill scrollable>
          {cameras.map((camera) => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
              key={camera.name}
              title={camera.name}
              className={classes([
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
                activeCamera &&
                  camera.name === activeCamera.name &&
                  'Button--selected',
              ])}
              onClick={() =>
                act('switch_camera', {
                  name: camera.name,
                })
              }>
              {camera.name}
            </div>
          ))}
        </Section>
      </Flex.Item>
    </Flex>
  );
};
