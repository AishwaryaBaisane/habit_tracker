import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Components/my_habit_Title.dart';
import 'package:habit_tracker/Components/my_heat_map.dart';
import 'package:habit_tracker/DataBase/habit_database.dart';
import 'package:habit_tracker/Models/habit.dart';
import 'package:provider/provider.dart';

import '../Themes/Theme_Provider.dart';
import '../Utils/habit_utils.dart';

final TextEditingController textEditingController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // read  existing habits on app startup
    Provider.of<HabitDataBase>(context, listen: false).readHabits();
    super.initState();
  }

  // create  new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(
            hintText: "Create a new habit",
          ),
        ),
        actions: [
          //   save Button
          MaterialButton(
            onPressed: () {
              //   get the new habit name
              String newHabitName = textEditingController.text;
              //   Save to database
              context.read<HabitDataBase>().addhabit(newHabitName);
              //   pop box
              Navigator.pop(context);
              //   clear controller
              textEditingController.clear();
            },
            child: const Text('Save'),
          ),

          //   Cancel Button
          MaterialButton(
            onPressed: () {
              //   pop box
              Navigator.pop(context);
              //   clear controller
              textEditingController.clear();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  // check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDataBase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    // set controller for the text
    textEditingController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
        ),
        actions: [
          //   save button
          MaterialButton(
            onPressed: () {
              //   get the new habit name
              String newHabitName = textEditingController.text;
              //   Save to database
              context
                  .read<HabitDataBase>()
                  .updateHabitName(habit.id, newHabitName);
              //   pop box
              Navigator.pop(context);
              //   clear controller
              textEditingController.clear();
            },
            child: const Text('Save'),
          ),
          //   Cancel Button
          MaterialButton(
            onPressed: () {
              //   pop box
              Navigator.pop(context);
              //   clear controller
              textEditingController.clear();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  // delete habit box

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          //   delete button
          MaterialButton(
            onPressed: () {
              //   Save to database
              context.read<HabitDataBase>().deleteHabit(habit.id);
              //   pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          //   Cancel Button
          MaterialButton(
            onPressed: () {
              //   pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
        ),
        // backgroundColor: Colors.red,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Habit Tracker'),
        elevation: 0.9,
        // shadowColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      // drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade400,
        onPressed: createNewHabit,
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          //   HeatMap
          _buildHeatMap(),
          //   HabitList
          _buildHabitList()
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDataBase>();

    //   current habit
    List<Habit> currentHabit = habitDatabase.currentHabits;

    //   return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data  is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
              initDate: snapshot.data!,
              datasets: preHeatMapDataset(currentHabit));
        }

        //   handle case where no da ta is returned
        else {
          return Container();
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    final habitDataBase = context.watch<HabitDataBase>();

    // current habits
    List<Habit> currrentHabits = habitDataBase.currentHabits;

    return ListView.builder(
      itemCount: currrentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currrentHabits[index];

        // check if the habit is completed
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTitle(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
