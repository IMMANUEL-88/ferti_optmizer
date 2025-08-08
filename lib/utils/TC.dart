import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 13),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.371,
                // Adjusted width
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Ash color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                padding: const EdgeInsets.all(8),
                // Adjust padding as needed
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                // Adjust margin as needed
                child: Center(
                  child: Text(
                    'User ID: ${task['Userid']}, Task: ${task['Task']}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
