import 'package:flutter/material.dart';
import 'package:habit_tracker/Models/app_setting.dart';
import 'package:habit_tracker/Models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDataBase extends ChangeNotifier {
  static late Isar isar;

// initialization

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

// save first date of app startup (for heatmap)

  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

// get first date of app startup (for heatmap)

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

/*
crud operations
 */

// List of habits
  final List<Habit> currentHabits = [];

// Create -> add a new habit

  Future<void> addhabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    //   save to database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //   re-read from database
    readHabits();
  }

// Read -> read saved habits from database
  Future<void> readHabits() async {
    // here we are fetching value from database
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //now give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    notifyListeners();
  }

// Update -> check habits on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add the  current date to the completed Days List
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          // add the current date if it's not already oin the list
          habit.completedDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        }
        // if habit is Not completed -> remove the current date from the list
        else {
          // remove the current date if the habit is marked as not completed

          habit.completedDays.removeWhere((date) =>
          date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }

        //   save the updated habits back to the database
        await isar.habits.put(habit);
      });
    }

    //   re-read from database
    readHabits();
  }

// Update -> edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      //   update name
      await isar.writeTxn(() async {
        habit.name = newName;
        //   save update habit back to the database
        await isar.habits.put(habit);
      });
    }

    //   re-read from database
    readHabits();
  }

// Delete -> delete habit
  Future<void> deleteHabit(int id) async {
    //   perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //   re-read from the database
    readHabits();
  }
}