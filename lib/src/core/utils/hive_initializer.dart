import 'package:hive_flutter/hive_flutter.dart';
import 'package:axis_task/src/features/popular_people/data/models/person_hive_model.dart';

class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register all Hive adapters
    Hive.registerAdapter(PersonHiveModelAdapter());
  }
} 