String getNextEmoji(String currentEmoji) {
  const emojis = ['📄', '📝', '📅', '📌', '🎯', '🔍'];
  final currentIndex = emojis.indexOf(currentEmoji);
  final nextIndex = (currentIndex + 1) % emojis.length;
  return emojis[nextIndex];
}
