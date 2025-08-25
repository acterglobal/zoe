// Function to get search indices for text content
List<int> getTextSearchIndices(String content, String query) {
  if (query.isEmpty) return [];
  
  final lines = content.split('\n');
  final indices = <int>[];
  
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].toLowerCase().contains(query.toLowerCase())) {
      indices.add(i);
    }
  }
  
  return indices;
}