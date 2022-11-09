String removeString(String str) {
  str = str.replaceAll('image_picker', '');
  str = str.replaceAll('\\', '');

  return str;
}
