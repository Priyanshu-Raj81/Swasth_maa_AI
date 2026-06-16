import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../services/ai_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<ChatMessage> _messages = [
    ChatMessage('Namaste! Main Swasth Maa AI hoon. Aap bol kar ya likh kar sawal pooch sakti hain.', false),
  ];

  bool _isTyping = false;
  
  // Audio configuration
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _currentLocaleId = 'hi-IN'; // Default to Hindi
  String _currentLanguageName = 'Hindi'; // Set initial Dropdown item

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage(_currentLocaleId);
    await _flutterTts.setSpeechRate(0.5); // Slightly slower for clarity
    await _flutterTts.setPitch(1.0);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _msgController.text = val.recognizedWords;
          }),
          localeId: _currentLocaleId,
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage(_currentLocaleId);
    await _flutterTts.speak(text);
  }

  void _sendMessage() async {
    if (_msgController.text.trim().isEmpty) return;

    // Stop listening if sending
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }

    final userText = _msgController.text;
    setState(() {
      _messages.add(ChatMessage(userText, true));
      _msgController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Call real external service + passing pregnancy context
    final reply = await AiService.getResponse(
      message: userText, 
      localeId: _currentLocaleId, 
      languageName: _currentLanguageName,
      contextData: 'User is 24 weeks pregnant. Last recorded BP: 140/90. Risk: Medium.'
    );
    
    // Check for emergency keywords in the user prompt to show overlay
    final lowercaseInput = userText.toLowerCase();
    if (lowercaseInput.contains('tez') || 
        lowercaseInput.contains('heavy') || 
        lowercaseInput.contains('severe') ||
        lowercaseInput.contains('emergency') ||
        lowercaseInput.contains('khoon') || 
        lowercaseInput.contains('bleeding') ||
        lowercaseInput.contains('faint') ||
        lowercaseInput.contains('behoosh')) {
      _showEmergencyAlert();
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(reply, false));
      });
      _scrollToBottom();
      _speak(reply); // Auto-speak the response
    }
  }

  void _showEmergencyAlert() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.alertRed,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Emergency Khatra!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Yeh emergency ho sakta hai. Turant doctor se sampark karein.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                    Navigator.pushNamed(context, '/emergency'); // Go to Emergency
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.alertRed,
                  ),
                  child: const Text('Emergency Help Screen Pe Jayein'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final Map<String, String> _indianLanguages = {
    'Hindi': 'hi-IN',
    'Marathi': 'mr-IN',
    'Bengali': 'bn-IN',
    'Telugu': 'te-IN',
    'Tamil': 'ta-IN',
    'Gujarati': 'gu-IN',
    'Urdu': 'ur-IN',
    'Kannada': 'kn-IN',
    'Odia': 'or-IN',
    'Malayalam': 'ml-IN',
    'Punjabi': 'pa-IN',
    'Assamese': 'as-IN',
  };

  void _onLanguageChanged(String? newLanguageName) {
    if (newLanguageName != null) {
      setState(() {
        _currentLanguageName = newLanguageName;
        _currentLocaleId = _indianLanguages[newLanguageName]!;
      });
      _initTts(); // Re-initialize TTS with new locale
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bhasha badli gayi: $newLanguageName'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎤 Maa Se Baat Karein'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentLanguageName,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                onChanged: _onLanguageChanged,
                items: _indianLanguages.keys.map<DropdownMenuItem<String>>((String langName) {
                  return DropdownMenuItem<String>(
                    value: langName,
                    child: Text(langName),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bolt, color: Colors.purple, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '⚡ AI Powered (BharatGen Ready)',
                      style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.alertYellow.withOpacity(0.3),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: const Text(
                  'Yeh AI sirf salah deta hai. Doctor ki jagah nahi hai.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: msg.isUser ? AppColors.primaryLight : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(msg.isUser ? 20 : 0),
                  bottomRight: Radius.circular(msg.isUser ? 0 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: AppTypography.bodyMedium.copyWith(
                      color: msg.isUser ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (!msg.isUser) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _speak(msg.text),
                      child: const Icon(Icons.volume_up, size: 16, color: AppColors.primary),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (msg.isUser) const SizedBox(width: 32),
          if (!msg.isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Soch rahi hai...'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Aapka sawal...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: AppColors.primary,
                  mini: true,
                  elevation: 0,
                  tooltip: 'Bhejein',
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _listen,
              child: CircleAvatar(
                radius: 36,
                backgroundColor: _isListening ? AppColors.alertRed : AppColors.primary,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isListening ? 'Sun rahi hoon...' : 'Bolne ke liye dabayein',
              style: AppTypography.bodyMedium.copyWith(
                color: _isListening ? AppColors.alertRed : AppColors.textSecondary,
                fontWeight: _isListening ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

