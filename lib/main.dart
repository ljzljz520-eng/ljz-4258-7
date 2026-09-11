import 'package:flutter/material.dart';

import 'app.dart';
import 'app_scope.dart';
import 'data/db/database.dart';
import 'data/demo_seed.dart';
import 'data/trace_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = CheeseTraceDatabase();
  final repo = TraceRepository(db);
  await seedDemoIfEmpty(repo);
  runApp(AppScope(repository: repo, child: const CheeseTraceApp()));
}
