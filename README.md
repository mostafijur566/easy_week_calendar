# EasyWeekCalendar
A sleek and flexible week-view calendar for Flutter. Easily manage date selection, highlight events with badges, and fully customize the look and feel to match your app’s brand.

## Features
- **📅 Week View:** Interactive 7-day horizontal scroll/view.

- **🎨 Fully Customizable:** Tweak colors, icons, borders, and text styles to fit your theme.

- **🔢 Event Indicators:** Built-in support for displaying event counts on specific days.

- **🛠 Flexible Logic:** Choose any day (Monday–Sunday) as the start of the week.

- **🔍 Month/Year Picker:** Jump to any date quickly with the integrated dialog picker.

- **📱 Responsive:** Optimized for different screen widths using Expanded and GridView.

## Preview
![EasyWeekCalendar Demo](https://raw.githubusercontent.com/mostafijur566/easy_week_calendar/main/assets/demo.gif)
## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_week_calendar: ^1.0.3
```

Next, import the package

```
import 'package:easy_week_calendar/easy_week_calendar.dart';
```

```
import 'package:flutter/material.dart';
import 'package:easy_week_calendar/easy_week_calendar.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: SafeArea(child: WeekCalendarExample()))));
}

class WeekCalendarExample extends StatefulWidget {
  const WeekCalendarExample({super.key});

  @override
  State<WeekCalendarExample> createState() => _WeekCalendarExampleState();
}

class _WeekCalendarExampleState extends State<WeekCalendarExample> {
  @override
  Widget build(BuildContext context) {
    return WeekCalendar(
      headerTitle: "My Calendar",
      onDateSelected: (date) {
        print("Selected Date: $date");
      },
      onWeekChanged: (start, end) {
        print("Week changed: $start to $end");
      },
      // Example of event counts
      eventCounts: {
        DateTime.now(): 3,
        DateTime.now().add(const Duration(days: 1)): 5,
      },
    );
  }
}
```