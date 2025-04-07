extension StringExtension on String {
  /// Capitalizes the first letter of each word in a string
  String capitalize() {
    return split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }
}
