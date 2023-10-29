/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 30,
  medium = 50,
  large = 70,
  width = 231,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 22,
  medium = 45,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  ':a ': 'Рой',
  ':b ': 'Бот',
  ':c ': 'Кмд',
  ':e ': 'Энж',
  ':m ': 'Мед',
  ':n ': 'Науч',
  ':o ': 'ИИ',
  ':s ': 'Охр',
  ':t ': 'Синд',
  ':u ': 'Снаб',
  ':v ': 'Серв',
  ':y ': 'ЦК',
  ':q ': 'Рейн',
  ':f ': 'Фрак',
} as const;
