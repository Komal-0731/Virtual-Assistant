import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {


  final List<OpenAIChatCompletionChoiceMessageModel> _messages = [];


  void initialize() {

    OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;


    _messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "You are a friendly and helpful assistant.",
          ),
        ],
      ),
    );

  }


  Future<String> getChatResponse(String userMessage) async {
    try {

      _messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(userMessage),
          ],
        ),
      );


      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini", // This is the OpenAI model
        messages: _messages,
      );


      final aiResponse = chatCompletion.choices.first.message.content?.first.text;

      if (aiResponse != null) {

        _messages.add(
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.assistant,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(aiResponse),
            ],
          ),
        );
        return aiResponse;
      }

      return "Error: Could not get a response.";

    } catch (e) {

      print("An error occurred: $e");
      return "An error occurred. Please try again.";
    }
  }
}