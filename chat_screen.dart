import 'package:flutter/material.dart';
import 'package:demo/services/openai_service.dart'; // Make sure this path is correct

// This class holds the data for a single message
class ChatMessage {
  final String text;
  final bool isUser; // True if this message is from the user

  ChatMessage({required this.text, required this.isUser});
}

// ------------------------------------
// -- Your Chat Screen code
// ------------------------------------

class chatScreen extends StatefulWidget {
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  // 1. Controllers and state variables
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // 2. Create an instance of your Gemini Service
  final OpenAIService openAIService = OpenAIService();

  // 3. The list of all chat messages
  final List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();

    // 4. Initialize the API service
    openAIService.initialize();

    // 5. Add a welcome message
    messages.add(
      ChatMessage(
        text: "Hello! You can ask me anything. How can I help you today?",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    // 6. Dispose controllers
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 7. The main function to send a message
  Future<void> sendMessage() async {
    if (_textController.text.isEmpty) {
      return;
    }

    final userMessage = _textController.text;

    // Add the user's message to the list
    setState(() {
      messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true; // Set loading to true
    });

    // Clear the text field
    _textController.clear();
    _scrollToBottom();

    // Call the API
    try {
      final aiResponse = await openAIService.getChatResponse(userMessage);

      // Add the AI's response and stop loading
      setState(() {
        messages.add(ChatMessage(text: aiResponse, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();

    } catch (e) {
      // Handle errors
      setState(() {
        messages.add(ChatMessage(text: "Sorry, I ran into an error. Please try again.", isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // 8. Auto-scroll to the bottom of the chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ------------------------------------
  // -- The UI (Build Method)
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ------------------------------------
          // -- 1. The Chat List
          // ------------------------------------
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // ------------------------------------
          // -- 2. Loading Indicator
          // ------------------------------------
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text("Assistant is thinking..."),
                ],
              ),
            ),

          // ------------------------------------
          // -- 3. The Text Input Field
          // ------------------------------------
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (text) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  // -- Helper widget for chat bubbles
  // ------------------------------------
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? Colors.deepPurple[400] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 16),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}