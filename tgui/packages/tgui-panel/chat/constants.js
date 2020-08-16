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

export const MESSAGE_TYPES = [
  // Always-on types
  {
    type: 'system',
    name: 'Система',
    description: 'Сообщения клиента, всегда включены',
    selector: '.boldannounce, .filter_system',
    important: true,
  },
  // Basic types
  {
    type: 'localchat',
    name: 'Локальное',
    description: 'Местные IC сообщения',
    selector: '.filter_say, .say, .emote',
  },
  {
    type: 'radio',
    name: 'Радио',
    description: 'Все радиоканалы',
    selector: '.filter_radio, .alert, .syndradio, .centradio, .airadio, .entradio, .comradio, .secradio, .engradio, .medradio, .sciradio, .supradio, .srvradio, .expradio, .radio, .deptradio, .newscaster',
  },
  {
    type: 'info',
    name: 'Инфо',
    description: 'Не очень важные сообщения информации',
    selector: '.filter_notice, .notice:not(.pm), .adminnotice, .info, .sinister, .cult',
  },
  {
    type: 'warning',
    name: 'Предупреждения',
    description: 'Важные сообщения от внутриигровых и не только предметов',
    selector: '.filter_warning, .warning:not(.pm), .critical, .userdanger, .italics',
  },
  {
    type: 'deadchat',
    name: 'Дедчат',
    description: 'Всё из дедчата',
    selector: '.filter_deadsay, .deadsay',
  },
  {
    type: 'ooc',
    name: 'OOC',
    description: 'То, что выключено всегда',
    selector: '.filter_ooc, .ooc, .adminooc',
  },
  {
    type: 'adminpm',
    name: 'ПС',
    description: 'Сообщения от/для педалей',
    selector: '.filter_pm, .pm',
  },
  {
    type: 'combat',
    name: 'Бой',
    description: 'Все сообщения которые могут быть связаны с боем',
    selector: '.filter_combat, .danger',
  },
  {
    type: 'unknown',
    name: 'Нет описания',
    description: 'Всё остальное, всегда включено',
  },
  // Admin stuff
  {
    type: 'adminchat',
    name: 'АЧат',
    description: 'ASAY сообщения',
    selector: '.filter_ASAY, .admin_channel',
    admin: true,
  },
  {
    type: 'modchat',
    name: 'МЧат',
    description: 'MSAY сообщения',
    selector: '.filter_MSAY, .mod_channel',
    admin: true,
  },
  {
    type: 'eventchat',
    name: 'ИЧат',
    description: 'ESAY сообщения',
    selector: '.filter_ESAY, .event_channel',
    admin: true,
  },
  {
    type: 'adminlog',
    name: 'Admin Log',
    description: 'ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z',
    selector: '.filter_adminlog, .log_message',
    admin: true,
  },
  {
    type: 'attacklog',
    name: 'АЛог',
    description: 'Аттак-логи',
    selector: '.filter_attacklog',
    admin: true,
  },
  {
    type: 'debuglog',
    name: 'ДЛог',
    description: 'DEBUG: SSPlanets subsystem Recover().',
    selector: '.filter_debuglog',
    admin: true,
  },
];
