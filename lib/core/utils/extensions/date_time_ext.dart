extension DateTimeExt on DateTime {
  bool isToday() {
    return day == DateTime.now().day;
  }

  bool isYesterday() {
    return day == DateTime.now().day - 1;
  }
}
