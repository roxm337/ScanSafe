import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      'isUser': false,
      'text': 'Hello! I\'m your AI assistant. How can I help you with product safety today?',
      'time': '10:00 AM',
    },
    {
      'isUser': true,
      'text': 'Can you check if this product is safe for pregnant women?',
      'time': '10:01 AM',
    },
    {
      'isUser': false,
      'text': 'I\'d be happy to help! Can you scan or enter the product details? I can check for ingredients that may be concerning for pregnant women.',
      'time': '10:01 AM',
    },
    {
      'isUser': true,
      'text': 'What about parabens? Are they safe?',
      'time': '10:02 AM',
    },
    {
      'isUser': false,
      'text': 'Parabens are preservatives that some studies suggest may disrupt hormones. Many experts recommend avoiding them during pregnancy. Would you like me to suggest paraben-free alternatives?',
      'time': '10:02 AM',
    },
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Assistant',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.textColor,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.textColor,
            ),
            onPressed: () {},
          ),
        ]
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return _buildMessageBubble(context, message);
              },
            ),
          ),
          
          // Quick action suggestions
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickAction(context, 'Check alternatives'),
                const SizedBox(width: 10),
                _buildQuickAction(context, 'Scan product'),
                const SizedBox(width: 10),
                _buildQuickAction(context, 'Allergen check'),
                const SizedBox(width: 10),
                _buildQuickAction(context, 'Pregnancy safety'),
              ],
            ),
          ),
          
          // Input field
          _buildInputField(context),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Map<String, dynamic> message) {
    bool isUser = message['isUser'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: 
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
          if (!isUser) const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser 
                    ? AppTheme.primaryColor 
                    : AppTheme.pastelLavender,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20 : 0),
                  topRight: Radius.circular(isUser ? 0 : 20),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: GoogleFonts.poppins(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      message['time'],
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isUser ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        action,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                onSubmitted: (text) {
                  _sendMessage();
                },
                decoration: InputDecoration(
                  hintText: 'Ask about ingredients...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // Add the new message to the list
      setState(() {
        messages.add({
          'isUser': true,
          'text': _messageController.text,
          'time': _getCurrentTime(),
        });
        
        // Add a simulated response
        messages.add({
          'isUser': false,
          'text': 'I\'m still learning how to respond to your message, but I\'m here to help you check product safety for allergens and ingredients.',
          'time': _getCurrentTime(),
        });
      });
      
      // Scroll to the bottom to show the new message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      
      // Clear the input field
      _messageController.clear();
    }
  }

  String _getCurrentTime() {
    return DateTime.now().hour.toString().padLeft(2, '0') + 
           ':' + 
           DateTime.now().minute.toString().padLeft(2, '0');
  }
}