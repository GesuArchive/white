/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const MAX_VISIBLE_MESSAGES = 2500;
export const MAX_PERSISTED_MESSAGES = 1000;
export const MESSAGE_SAVE_INTERVAL = 10000;
export const MESSAGE_PRUNE_INTERVAL = 60000;
export const COMBINE_MAX_MESSAGES = 5;
export const COMBINE_MAX_TIME_WINDOW = 5000;
export const IMAGE_RETRY_DELAY = 250;
export const IMAGE_RETRY_LIMIT = 10;
export const IMAGE_RETRY_MESSAGE_AGE = 60000;

// Default message type
export const MESSAGE_TYPE_UNKNOWN = 'unknown';

// Internal message type
export const MESSAGE_TYPE_INTERNAL = 'internal';

// Must match the set of defines in code/__DEFINES/chat.dm
export const MESSAGE_TYPE_SYSTEM = 'system';
export const MESSAGE_TYPE_LOCALCHAT = 'localchat';
export const MESSAGE_TYPE_RADIO = 'radio';
export const MESSAGE_TYPE_INFO = 'info';
export const MESSAGE_TYPE_WARNING = 'warning';
export const MESSAGE_TYPE_DEADCHAT = 'deadchat';
export const MESSAGE_TYPE_OOC = 'ooc';
export const MESSAGE_TYPE_ADMINPM = 'adminpm';
export const MESSAGE_TYPE_COMBAT = 'combat';
export const MESSAGE_TYPE_ADMINCHAT = 'adminchat';
export const MESSAGE_TYPE_MODCHAT = 'modchat';
export const MESSAGE_TYPE_EVENTCHAT = 'eventchat';
export const MESSAGE_TYPE_ADMINLOG = 'adminlog';
export const MESSAGE_TYPE_ATTACKLOG = 'attacklog';
export const MESSAGE_TYPE_DEBUG = 'debug';

// Metadata for each message type
export const MESSAGE_TYPES = [
  // Always-on types
  {
    type: MESSAGE_TYPE_SYSTEM,
    name: 'Система',
    description: 'Сообщения клиента, всегда включены',
    selector: '.boldannounce',
    important: true,
  },
  // Basic types
  {
    type: MESSAGE_TYPE_LOCALCHAT,
    name: 'Локальное',
    description: 'Местные IC сообщения',
    selector: '.say, .emote',
  },
  {
    type: MESSAGE_TYPE_RADIO,
    name: 'Радио',
    description: 'Все радиоканалы',
    selector: '.alert, .syndradio, .centradio, .airadio, .entradio, .comradio, .secradio, .engradio, .medradio, .sciradio, .supradio, .srvradio, .expradio, .radio, .deptradio, .newscaster',
  },
  {
    type: MESSAGE_TYPE_INFO,
    name: 'Инфо',
    description: 'Не очень важные сообщения информации',
    selector: '.notice:not(.pm), .adminnotice, .info, .sinister, .cult',
  },
  {
    type: MESSAGE_TYPE_WARNING,
    name: 'Предупреждения',
    description: 'Важные сообщения от внутриигровых и не только предметов',
    selector: '.warning:not(.pm), .critical, .userdanger, .italics',
  },
  {
    type: MESSAGE_TYPE_DEADCHAT,
    name: 'Дедчат',
    description: 'Всё из дедчата',
    selector: '.deadsay',
  },
  {
    type: MESSAGE_TYPE_OOC,
    name: 'OOC',
    description: 'То, что выключено всегда',
    selector: '.ooc, .adminooc',
  },
  {
    type: MESSAGE_TYPE_ADMINPM,
    name: 'ПС',
    description: 'Сообщения от/для педалей',
    selector: '.pm, .adminhelp',
  },
  {
    type: MESSAGE_TYPE_COMBAT,
    name: 'Бой',
    description: 'Все сообщения которые могут быть связаны с боем',
    selector: '.danger',
  },
  {
    type: MESSAGE_TYPE_UNKNOWN,
    name: 'Неизвестное',
    description: 'Всё, что не сортируется, будет включено',
  },
  // Admin stuff
  {
    type: MESSAGE_TYPE_ADMINCHAT,
    name: 'АЧат',
    description: 'ASAY сообщения',
    selector: '.admin_channel, .adminsay',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_MODCHAT,
    name: 'МЧат',
    description: 'MSAY сообщения',
    selector: '.mod_channel',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ADMINLOG,
    name: 'АЛог',
    description: 'ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z',
    selector: '.log_message',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ATTACKLOG,
    name: 'Аттак-логи',
    description: 'Urist McTraitor has shot John Doe',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_DEBUG,
    name: 'Debug Log',
    description: 'DEBUG: SSPlanets subsystem Recover().',
    admin: true,
  },
];
