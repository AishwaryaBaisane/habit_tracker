import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTitle extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTitle({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          //   edit option
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey.shade500,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),
          ),

          //   delete option
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red.shade200,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),


        ]),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              // toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.red.shade400
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              // text
              title: Text(text,
                style: TextStyle(
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary
                  // color:  Theme.of(context).colorScheme.tertiary,
                ),),
              leading: Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.red.shade400,
                value: isCompleted,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}