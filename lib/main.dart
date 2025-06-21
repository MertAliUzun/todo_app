import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/data/models/isar_todo.dart';
import 'package:todo_app/data/repository/isar_todo_repo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_page.dart';
import 'package:todo_app/presentation/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //get directory path for storing
  final dir = await getApplicationDocumentsDirectory();
  //open isar db
  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);
  //initialize repo with isar db
  final isarTodoRepo = IsarTodoRepo(isar);

  //run app
  runApp(MyApp(todoRepo: isarTodoRepo));
}

class MyApp extends StatelessWidget {
  final TodoRepo todoRepo;

  const MyApp({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoCubit(todoRepo)),
        BlocProvider(create: (context) => ThemeCubit()..changeTheme(ThemeMode.dark)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: Colors.cyan,
                secondary: Colors.amber,
              ),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            home: const TodoPage(),
          );
        },
      ),
    );
  }
}