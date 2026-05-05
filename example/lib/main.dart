import 'package:easy_week_calendar/easy_week_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: EasyWeekCalendar(
        // Optional header title
        headerTitle: "My Calendar",
        onDateSelected: (date) {
          print(date);
        },
        // Optional: Set the first day of the week (default is Sunday)
        firstDayOfWeek: StartDay.sunday,
        // Optional: Customize the appearance of the calendar
        onWeekChanged: (firstDate, lastDate) {
          print("First date: $firstDate, Last date: $lastDate");
        },
        colors: CalendarColors(
          primaryColor: Colors.deepPurple,
          selectedBackgroundColor: Colors.deepPurpleAccent,
          todayBackgroundColor: Colors.deepPurple[100]!,
          selectedBorderColor: Colors.deepPurpleAccent,
          selectedTextColor: Colors.white,
          todayTextColor: Colors.deepPurple,
        ),
        // Optional: Provide event counts for specific dates
        eventCounts: {
          DateTime(2024, 6, 10): 3,
          DateTime(2024, 6, 12): 1,
          DateTime(2024, 6, 15): 2,
        },
      ),
    );
  }
}
