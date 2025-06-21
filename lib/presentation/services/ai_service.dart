import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/models/subtask.dart';

// Events
abstract class AiTodoEvent {}

class GenerateTodoEvent extends AiTodoEvent {
  final String prompt;
  GenerateTodoEvent({required this.prompt});
}

// States
abstract class AiTodoState {}

class AiTodoInitial extends AiTodoState {}

class AiTodoLoading extends AiTodoState {}

class AiTodoSuccess extends AiTodoState {
  final Todo todo;
  AiTodoSuccess({required this.todo});
}

class AiTodoError extends AiTodoState {
  final String message;
  AiTodoError({required this.message});
}

// BLoC
class AiTodoBloc extends Bloc<AiTodoEvent, AiTodoState> {
  AiTodoBloc() : super(AiTodoInitial()) {
    on<GenerateTodoEvent>(_onGenerateTodo);
  }

  Future<void> _onGenerateTodo(
    GenerateTodoEvent event,
    Emitter<AiTodoState> emit,
  ) async {
    emit(AiTodoLoading());
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    try {
      // OpenAI API çağrısı
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // Bu kısmı kullanıcının API key'i ile değiştirin
        },
        body: jsonEncode({
          'model': 'gpt-4.1-nano',
          'messages': [
            {
              'role': 'user',
              'content': '''Sen bir todo uygulaması için görev oluşturan bir AI'sın. 
              Kullanıcının isteğine göre bir görev ve alt görevler oluştur.
              Kullanıcı şunu arıyor: ${event.prompt.toString()}
              Yanıtını şu JSON formatında ver:
              {
                "title": "Görev başlığı",
                "priority": 0-2 (0: düşük, 1: orta, 2: yüksek),
                "categories": ["kategori1", "kategori2"],
                "subtasks": [
                  {"text": "Alt görev 1", "order": 1},
                  {"text": "Alt görev 2", "order": 2}
                ]
              }
              
              Önemli kurallar:
              - Öncelik varsayılan olarak 1 (orta) olsun, sadece acil işler için 2 kullan
              - Kategorileri mevcut kategorilerden seç: İş, Okul, Kişisel, Alışveriş, Sağlık
              - Alt görevleri mantıklı sırada ver
              - Sadece JSON döndür, başka açıklama ekleme'''
            },
          ],
          'max_tokens': 1000,
        }),
      );
      //print(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)); //use utf8.decode(response.bodyBytes) instead of response.body to make sure every letter is correct
        final content = data['choices'][0]['message']['content'];
        
        // JSON'u parse et
        final todoData = jsonDecode(content);
        
        // Todo nesnesini oluştur
        final todo = Todo(
          id: DateTime.now().millisecondsSinceEpoch,
          text: todoData['title'],
          priority: todoData['priority'] ?? 1,
          createdAt: DateTime.now(),
          categories: todoData['categories'] != null 
              ? List<String>.from(todoData['categories'])
              : null,
          subtasks: todoData['subtasks'] != null
              ? (todoData['subtasks'] as List)
                  .map((subtask) => Subtask(
                        id: DateTime.now().millisecondsSinceEpoch + (subtask['order'] as int),
                        text: subtask['text'],
                        isCompleted: false,
                        orderNo: subtask['order'] as int,
                      ))
                  .toList()
              : null,
        );

        emit(AiTodoSuccess(todo: todo));
      } else {
        emit(AiTodoError(message: 'API çağrısı başarısız: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AiTodoError(message: 'Hata oluştu: $e'));
    }
  }
} 