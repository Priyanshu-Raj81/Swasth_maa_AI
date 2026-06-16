import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _apiKey = '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';

  /// Sends a message to the AI and returns the response string.
  static Future<String> getResponse({
    required String message,
    String? localeId = 'hi-IN',
    String? languageName = 'Hindi',
    String? contextData = 'User is pregnant.',
  }) async {
    try {
      // Save user message to logs immediately
      await logChat('User', message);

      final systemPrompt = '''
You are a rural maternal and child healthcare assistant for Indian women.
Use very simple language.
Respond strictly in the $languageName language and dialect. 
Detected technical locale: $localeId.
Context: $contextData
Do not provide final medical diagnosis.
If symptoms seem serious, advise visiting nearest doctor.
Be calm, respectful and culturally sensitive.
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Or gpt-4 if preferred
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': message}
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiText = data['choices'][0]['message']['content'];
        await logChat('AI', aiText);
        return aiText;
      } else {
        return 'Maaf karein, server se sampark mein dikkat aayi. (Error: ${response.statusCode})';
      }
    } catch (e) {
      return 'Kripya apna internet connection check karein. (Error: $e)';
    }
  }

  /// Logs chat history locally into SharedPreferences
  static Future<void> logChat(String sender, String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> logs = prefs.getStringList('chat_logs') ?? [];
      final timestamp = DateTime.now().toIso8601String();
      logs.add('$timestamp|$sender|$message');
      await prefs.setStringList('chat_logs', logs);
    } catch (e) {
      // Ignore if shared_preferences fails
    }
  }

  /// Retrieves chat logs for the Admin Panel
  static Future<List<String>> getChatLogs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('chat_logs') ?? [];
  }
}

