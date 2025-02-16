String capitalize(String normalText) {
  return normalText.isNotEmpty
      ? '${normalText[0].toUpperCase()}${normalText.substring(1)}'
      : normalText;
}
