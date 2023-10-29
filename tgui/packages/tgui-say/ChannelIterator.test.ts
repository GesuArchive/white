import { ChannelIterator } from './ChannelIterator';

describe('ChannelIterator', () => {
  let channelIterator: ChannelIterator;

  beforeEach(() => {
    channelIterator = new ChannelIterator();
  });

  it('should cycle through channels properly', () => {
    expect(channelIterator.current()).toBe('Сказать');
    expect(channelIterator.next()).toBe('Радио');
    expect(channelIterator.next()).toBe('Действие');
    expect(channelIterator.next()).toBe('OOC');
    expect(channelIterator.next()).toBe('Сказать'); // Admin is blacklisted so it should be skipped
  });

  it('should set a channel properly', () => {
    channelIterator.set('OOC');
    expect(channelIterator.current()).toBe('OOC');
  });

  it('should return true when current channel is "Сказать"', () => {
    channelIterator.set('Сказать');
    expect(channelIterator.isSay()).toBe(true);
  });

  it('should return false when current channel is not "Сказать"', () => {
    channelIterator.set('Радио');
    expect(channelIterator.isSay()).toBe(false);
  });

  it('should return true when current channel is visible', () => {
    channelIterator.set('Сказать');
    expect(channelIterator.isVisible()).toBe(true);
  });

  it('should return false when current channel is not visible', () => {
    channelIterator.set('OOC');
    expect(channelIterator.isVisible()).toBe(false);
  });

  it('should not leak a message from a blacklisted channel', () => {
    channelIterator.set('Админ');
    expect(channelIterator.next()).toBe('Админ');
  });
});
