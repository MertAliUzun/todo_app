import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/data/models/isar_todo.dart';
import 'package:todo_app/data/repository/isar_todo_repo.dart';
import 'package:todo_app/domain/repository/todo_repo.dart';
import 'package:todo_app/presentation/todo_cubit.dart';
import 'package:todo_app/presentation/todo_page.dart';
import 'package:todo_app/presentation/theme_cubit.dart';
import 'package:todo_app/presentation/services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);
  final isarTodoRepo = IsarTodoRepo(isar);

  // Tema bilgisini oku
  final initialTheme = await ThemeCubit.getInitialTheme();

  runApp(MyApp(todoRepo: isarTodoRepo, initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final TodoRepo todoRepo;
  final AppTheme initialTheme;

  const MyApp({super.key, required this.todoRepo, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoCubit(todoRepo)),
        BlocProvider(create: (context) => ThemeCubit(initialTheme)),
        BlocProvider(create: (context) => AiTodoBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            theme: themeState.themeData,
            home: const TodoPage(),
          );
        },
      ),
    );
  }
}