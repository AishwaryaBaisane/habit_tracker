import 'package:isar/isar.dart';

// command for generate the file: dart run build_runner build
part 'app_setting.g.dart';

@Collection()
class AppSettings{
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}