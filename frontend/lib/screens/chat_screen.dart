import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Assistant',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
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
                    Color(0xFF8A2BE2), // Purple
                    Color(0xFF40E0D0), // Turquoise
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
                    ? const Color(0xFF8A2BE2) 
                    : const Color(0xFFF8F7FF),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser 
                      ? const Radius.circular(20) 
                      : const Radius.circular(0),
                  bottomRight: isUser 
                      ? const Radius.circular(0) 
                      : const Radius.circular(20),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8A2BE2),
        ),
      ),
      child: Text(
        action,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF8A2BE2),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                color: const Color(0xFFF8F7FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ask about ingredients...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8A2BE2), // Purple
                  Color(0xFF40E0D0), // Turquoise
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}