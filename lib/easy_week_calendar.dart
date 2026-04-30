import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A customizable calendar widget that displays weeks and allows date selection.
///
/// The calendar shows a week view with Monday as the first day of the week.
/// Users can:
/// * Select any date by tapping on it
/// * Navigate between weeks using arrow buttons
/// * Change months using the month/year picker
/// * See today's date highlighted
/// * See the selected date highlighted
class EasyWeekCalendar extends StatefulWidget {
  /// The initially selected date. Defaults to current date.
  final DateTime? initialDate;

  /// Callback when a date is selected.
  final Function(DateTime)? onDateSelected;

  /// Whether to show the selected date info panel at the bottom.
  final bool showSelectedDateInfo;

  /// Custom header title. Defaults to 'Calendar'.
  final String? headerTitle;

  /// Custom colors for the calendar.
  final CalendarColors? colors;

  /// Optional border color for the calendar container. If not provided, defaults to a light grey.
  final Color? containerBorderColor;

  /// Optional color for the divider between header and calendar. If not provided, defaults to a light grey.
  final Color? separatedColor;

  /// Optional custom icon for the left arrow button. If not provided, defaults to a standard left chevron.
  final IconData? leftArrowIcon;

  /// Optional custom icon for the right arrow button. If not provided, defaults to a standard right chevron.
  final IconData? rightArrowIcon;

  /// Optional color for the icons in the calendar. If not provided, defaults to the primary color defined in [CalendarColors].
  final Color? iconColor;

  /// Optional text color for the month and year in the header. If not provided, defaults to a standard grey.
  final Color? monthYearTextColor;

  /// Optional text color for the activated day. If not provided, defaults to the selectedTextColor defined in [CalendarColors].
  final Color? activatedDayTextColor;

  /// Optional text color for the inactivated day. If not provided, defaults to a light grey.
  final Color? inactivatedDayTextColor;

  /// The first day of the week. Defaults to Monday.
  final StartDay firstDayOfWeek;

  /// Callback when the week changes (e.g., when navigating to a different week).
  final Function(DateTime, DateTime)? onWeekChanged;

  /// Optional map of event counts for each date. The key is the date and the value is the number of events on that date.
  final Map<DateTime, int>? eventCounts;

  /// Whether to show the month/year picker when tapping on the header. Defaults to true.
  final bool isShowYearPicker;

  const EasyWeekCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.showSelectedDateInfo = true,
    this.headerTitle,
    this.colors,
    this.containerBorderColor,
    this.separatedColor,
    this.leftArrowIcon,
    this.rightArrowIcon,
    this.iconColor,
    this.monthYearTextColor,
    this.activatedDayTextColor,
    this.inactivatedDayTextColor,
    this.firstDayOfWeek = StartDay.monday,
    this.onWeekChanged,
    this.eventCounts,
    this.isShowYearPicker = true,
  });

  @override
  State<EasyWeekCalendar> createState() => _EasyWeekCalendarState();
}

/// Custom colors for the calendar widget.
class CalendarColors {
  /// Primary color for selections and highlights.
  final Color primaryColor;

  /// Background color for selected date.
  final Color selectedBackgroundColor;

  /// Background color for today's date.
  final Color todayBackgroundColor;

  /// Border color for selected date.
  final Color selectedBorderColor;

  /// Text color for selected date.
  final Color selectedTextColor;

  /// Text color for today's date.
  final Color todayTextColor;

  const CalendarColors({
    this.primaryColor = Colors.blue,
    this.selectedBackgroundColor = Colors.blue,
    this.todayBackgroundColor = Colors.blue,
    this.selectedBorderColor = Colors.blue,
    this.selectedTextColor = Colors.white,
    this.todayTextColor = Colors.white,
  });
}

enum StartDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

extension StartDayExtension on StartDay {
  /// Maps our enum to DateTime weekday integers (1-7)
  int get value {
    switch (this) {
      case StartDay.monday:
        return 1;
      case StartDay.tuesday:
        return 2;
      case StartDay.wednesday:
        return 3;
      case StartDay.thursday:
        return 4;
      case StartDay.friday:
        return 5;
      case StartDay.saturday:
        return 6;
      case StartDay.sunday:
        return 7;
    }
  }
}

class _EasyWeekCalendarState extends State<EasyWeekCalendar> {
  late DateTime _currentDate;
  late DateTime _selectedWeekStart;
  late DateTime _selectedDate;
  //late DateTime _tempSelectedDate;

  DateTime get weekStartDate => _selectedWeekStart;

  DateTime get weekEndDate => _selectedWeekStart.add(const Duration(days: 6));

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentDate = DateTime(now.year, now.month);
    _selectedDate = widget.initialDate ?? now;
    _selectedWeekStart = _getWeekStart(_selectedDate);
    //_tempSelectedDate = _currentDate;
  }

  DateTime _getWeekStart(DateTime date) {
    int startDayValue = widget.firstDayOfWeek.value;
    // Calculate how many days to go back to reach the start of the week
    int daysToSubtract = (date.weekday - startDayValue + 7) % 7;
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }

  List<DateTime> _getWeekDays() {
    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(_selectedWeekStart.add(Duration(days: i)));
    }
    return weekDays;
  }

  void _previousWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
      _currentDate = DateTime(
        _selectedWeekStart.year,
        _selectedWeekStart.month,
      );
      _autoSelectDateForNewWeek();
    });
    _notifyWeekChange();
  }

  void _nextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
      _currentDate = DateTime(
        _selectedWeekStart.year,
        _selectedWeekStart.month,
      );
      _autoSelectDateForNewWeek();
    });
    _notifyWeekChange();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedWeekStart = _getWeekStart(date);
      _currentDate = DateTime(date.year, date.month);
    });
    widget.onDateSelected?.call(date);
  }

  // Helper method to handle the selection logic
  void _autoSelectDateForNewWeek() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Define the range of the newly visible week
    DateTime newWeekEnd = _selectedWeekStart.add(const Duration(days: 6));

    // If today is within the new week range, select today
    if (!today.isBefore(_selectedWeekStart) && !today.isAfter(newWeekEnd)) {
      _selectedDate = today;
    } else {
      // Otherwise, default to the first day of that week (Monday)
      _selectedDate = _selectedWeekStart;
    }

    // Optional: trigger the callback so your parent widget filters the list
    widget.onDateSelected?.call(_selectedDate);
  }

  Future<void> _selectMonthYear() async {
    DateTime tempSelectedDate = _currentDate;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Select Month and Year'),
              content: SizedBox(
                width: 300,
                height: 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setDialogState(() {
                              tempSelectedDate = DateTime(
                                tempSelectedDate.year - 1,
                                tempSelectedDate.month,
                              );
                            });
                          },
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text(
                            tempSelectedDate.year.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setDialogState(() {
                              tempSelectedDate = DateTime(
                                tempSelectedDate.year + 1,
                                tempSelectedDate.month,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                            ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final month = index + 1;
                          final isSelected = month == tempSelectedDate.month;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                tempSelectedDate = DateTime(
                                  tempSelectedDate.year,
                                  month,
                                );
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? widget.colors?.primaryColor.withValues(
                                            alpha: 0.2,
                                          ) ??
                                          Colors.blue.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? widget.colors?.primaryColor ??
                                            Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat(
                                    'MMM',
                                  ).format(DateTime(2000, month)),
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? widget.colors?.primaryColor ??
                                              Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: const Text('Cancel'),
                // ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      widget.colors?.primaryColor ?? Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _currentDate = DateTime(
                        tempSelectedDate.year,
                        tempSelectedDate.month,
                      );
                      _selectedWeekStart = _getWeekStart(
                        DateTime(_currentDate.year, _currentDate.month, 1),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final primaryColor = widget.colors?.primaryColor ?? Colors.blue;
    final selectedBgColor =
        widget.colors?.selectedBackgroundColor ?? primaryColor;
    final todayBgColor = widget.colors?.todayBackgroundColor ?? primaryColor;
    final selectedBorderColor =
        widget.colors?.selectedBorderColor ?? primaryColor;
    final selectedTextColor = widget.colors?.selectedTextColor ?? Colors.white;
    final todayTextColor = widget.colors?.todayTextColor ?? Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headerTitle != null) ...[
          Text(
            widget.headerTitle ?? 'Calendar',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
        ],

        if (widget.isShowYearPicker) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _previousWeek,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.containerBorderColor ?? Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.leftArrowIcon ?? Icons.chevron_left,
                      color: widget.iconColor,
                    ),
                  ),
                ),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.containerBorderColor ?? Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: _selectMonthYear,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: Text(
                        DateFormat('MMMM yyyy').format(_currentDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.monthYearTextColor ?? Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _nextWeek,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.containerBorderColor ?? Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.rightArrowIcon ?? Icons.chevron_right,
                      color: widget.iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Divider(color: widget.separatedColor ?? Colors.grey, thickness: 1),

          const SizedBox(height: 8),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = weekDays[index];
            final isToday = _isToday(date);
            final isSelected = _isSelected(date);
            final isCurrentMonth = date.month == _currentDate.month;

            final lookupDate = DateTime(date.year, date.month, date.day);
            final eventCount = widget.eventCounts?[lookupDate] ?? 0;

            return Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(date),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? selectedBorderColor
                          : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isToday && !isSelected
                        ? todayBgColor.withValues(alpha: 0.1)
                        : (isSelected
                              ? selectedBgColor.withValues(alpha: 0.2)
                              : Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text(
                          _getWeekdayName(index),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? selectedBorderColor
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$eventCount',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? primaryColor : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? selectedBgColor
                                : (isToday && !isSelected
                                      ? todayBgColor
                                      : Colors.transparent),
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? selectedTextColor
                                    : (isToday && !isSelected
                                          ? todayTextColor
                                          : (isCurrentMonth
                                                ? Colors.black
                                                : Colors.grey.shade400)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        // if (widget.showSelectedDateInfo) ...[
        //   const Spacer(),
        //   Container(
        //     padding: const EdgeInsets.all(16),
        //     decoration: BoxDecoration(
        //       color: primaryColor.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         const Text(
        //           'Selected Date:',
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         Text(
        //           DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.bold,
        //             color: primaryColor,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   const SizedBox(height: 20),
        // ],
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  String _getWeekdayName(int index) {
    // The master list of labels
    const allWeekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

    // Calculate the correct index in the master list
    // (Start day index + current loop index) % 7
    int labelIndex = (widget.firstDayOfWeek.value - 1 + index) % 7;

    return allWeekdays[labelIndex];
  }

  void _notifyWeekChange() {
    widget.onWeekChanged?.call(weekStartDate, weekEndDate);
  }
}
