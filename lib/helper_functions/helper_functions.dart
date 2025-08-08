import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EHelperFunctions {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  static Future<void> selectDate(
      BuildContext context,
      int index,
      List<Map<String, dynamic>> items,
      void Function(int index, String date) onDateSelected
      ) async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = items[index]['date'] != null
        ? DateTime.parse(items[index]['date'])
        : currentDate;

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Theme(
          data: theme.copyWith(
            textTheme: theme.textTheme.copyWith(
              bodyLarge: TextStyle(color: colorScheme.primary), // For larger text
              bodyMedium: TextStyle(color: colorScheme.primary), // For smaller text
            ),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogBackgroundColor: colorScheme.surfaceContainer,
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary, // Header color
              secondary: colorScheme.primary, // Color of the selected date
              onSurface: colorScheme.surfaceContainer, // Default text color
            ).copyWith(onSurface: colorScheme.primary), // Background color of the dialog
          ),
          child: AlertDialog(
            title: Text(
              'Select a date',
              style: GoogleFonts.poppins(color: colorScheme.primary),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: CalendarDatePicker(
                initialDate: initialDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                onDateChanged: (date) {
                  Navigator.of(context).pop(date);
                },
              ),
            ),
            backgroundColor: colorScheme.surface, // Background color of the dialog
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
    //For using date selector
    // DateSelector.selectDate(
    //   context,
    //   index,
    //   _items,
    //       (int index, String date) {
    //     setState(() {
    //       _items[index]['date'] = date;
    //     });
    //   },
    // );

    if (picked != null && picked != initialDate) {
      onDateSelected(index, picked.toLocal().toString().split(' ')[0]);
    }
  }


  static void showAlert(BuildContext context,String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ), // TextButton
          ],
        ); // AlertDialog
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)} ... ';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double spaceBetweenItems(BuildContext context) {
    return MediaQuery.of(context).size.height*.02;
  }
  static double spaceBetweenIcons(BuildContext context) {
    return MediaQuery.of(context).size.width*.02;
  }
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }

    return wrappedList;
  }
}
