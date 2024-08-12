import 'package:isar/isar.dart';

// command for generate the file: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
// habit id
  Id id = Isar.autoIncrement;

// habit name
  late String name;

// complete days
  List<DateTime> completedDays = [
    //   dateTime(years, months, day),
  ];

}