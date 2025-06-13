part of 'extensions.dart';

extension StringExtension on String {
  String truncateString({int maxLength = 30}) {
    if (length <= maxLength) {
      return this;
    } else {
      return "${substring(0, maxLength)}...";
    }
  }
}
