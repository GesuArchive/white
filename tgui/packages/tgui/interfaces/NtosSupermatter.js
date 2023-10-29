import { NtosWindow } from '../layouts';
import { SupermatterMonitorContent } from './SupermatterMonitor';

export const NtosSupermatter = (props, context) => {
  return (
    <NtosWindow width={600} height={350}>
      <NtosWindow.Content scrollable>
        <SupermatterMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
