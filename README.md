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
![EasyWeekCalendar Demo](https://github.com/mostafijur566/easy_week_calendar/blob/main/assets/demo.gif)

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_week_calendar: ^1.0.0
```

Next, import the package

```
import 'package:modal_progress_hud/modal_progress_hud.dart';
```

```
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Adaptive Progress Hub Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WeekCalendar(
             onWeekChanged: notifier.onWeekChanged,
             separatedColor: context.theme.dividerColor,
             monthYearTextColor: titleTextColor,
             colors: CalendarColors(
               primaryColor: secondaryColor,
               selectedBackgroundColor: secondaryColor,
               todayBackgroundColor: secondaryColor,
               selectedBorderColor: secondaryColor,
               selectedTextColor: Colors.white,
               todayTextColor: Colors.white,
             ),
             eventCounts: notifier.eventCounts,
             onDateSelected: notifier.onDateSelected,
           );
  }
}
```