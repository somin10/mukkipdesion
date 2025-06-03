import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock data for chat list
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': '김나눔',
      'rating': 4.8,
      'lastMessage': '30분 후에 버프 가능하실까요?',
      'time': '6일 전',
      'category': '뷰티/헬스',
      'unreadCount': 0,
      'isVerified': false,
      'hasNewMessage': false,
    },
    {
      'id': '2',
      'name': '이나눔',
      'rating': 3.2,
      'lastMessage': '야외 TT 그랬군요. 그럼 다음 사람에 드리는 것으로 일정해 주세요',
      'time': '1일 전',
      'category': '열리음',
      'unreadCount': 0,
      'isVerified': false,
      'hasNewMessage': false,
    },
    {
      'id': '3',
      'name': '먹킵리스트',
      'rating': 0.0,
      'lastMessage': '메세지를 길게 누르시면 저장하면 삭제할 수 있어요 식사하세요',
      'time': '2일 전',
      'category': '',
      'unreadCount': 0,
      'isVerified': true,
      'hasNewMessage': false,
    },
    {
      'id': '4',
      'name': '김요청',
      'rating': 4.9,
      'lastMessage': '냉장고에 있네주세요 있으시다면 200g만 되나요?',
      'time': '48시간 전',
      'category': '열리기',
      'unreadCount': 0,
      'isVerified': false,
      'hasNewMessage': true,
    },
    {
      'id': '5',
      'name': '김나눔',
      'rating': 5.0,
      'lastMessage': '네 맞았습니다.',
      'time': '60초 전',
      'category': '열리음',
      'unreadCount': 0,
      'isVerified': false,
      'hasNewMessage': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabButton('전체', 0),
                const SizedBox(width: 8),
                _buildTabButton('나눔', 1),
                const SizedBox(width: 8),
                _buildTabButton('요청', 2),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ChatPage(chatId: chat['id'], userName: chat['name']),
                ),
              );
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: _buildUserAvatar(chat),
            title: Row(
              children: [
                Text(
                  chat['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                if (chat['rating'] > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getRatingColor(chat['rating']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chat['rating']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  chat['time'],
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                chat['lastMessage'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF76BC1C) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> chat) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          child:
              chat['name'] == '먹킵리스트'
                  ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF76BC1C),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '먹',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  )
                  : Text(
                    chat['name'].substring(0, 1),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
        ),
        if (chat['isVerified'])
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 16,
              ),
            ),
          ),
        if (chat['hasNewMessage'])
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return const Color(0xFF4CAF50); // Green
    if (rating >= 4.0) return const Color(0xFF8BC34A); // Light Green
    if (rating >= 3.0) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFFF9800); // Orange
  }
}

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userName;

  const ChatPage({Key? key, required this.chatId, required this.userName})
    : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final String _currentUserId = 'user_123'; // Mock current user ID
  final double _rating = 4.8;
  final String _userId = 'real_jina1002';

  // Mock food share data
  final Map<String, dynamic> _sharedFood = {
    'title': '하젠다즈 블루베리&바닐라 파인트',
    'location': '경아싱',
    'label': '버프 드세요!',
    'imageUrl': 'assets/images/food_image.png',
  };

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock data for chat messages
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: _currentUserId,
          receiverId: widget.chatId,
          content: '안녕하세요',
          timestamp: DateTime(2025, 2, 13, 13, 29),
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          senderId: _currentUserId,
          receiverId: widget.chatId,
          content: '하젠다즈 블루베리만 나눔 되나요?',
          timestamp: DateTime(2025, 2, 13, 13, 29),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          senderId: widget.chatId,
          receiverId: _currentUserId,
          content: '안되네용...',
          timestamp: DateTime(2025, 2, 13, 13, 30),
          isRead: true,
        ),
        ChatMessage(
          id: '4',
          senderId: widget.chatId,
          receiverId: _currentUserId,
          content: '가져가기는 다 가져가세요',
          timestamp: DateTime(2025, 2, 13, 13, 31),
          isRead: true,
        ),
        ChatMessage(
          id: '5',
          senderId: _currentUserId,
          receiverId: widget.chatId,
          content: '새상이 감사하네요...',
          timestamp: DateTime(2025, 2, 13, 13, 34),
          isRead: true,
          isImage: false,
        ),
        ChatMessage(
          id: '6',
          senderId: _currentUserId,
          receiverId: widget.chatId,
          content: 'assets/images/meme.png',
          timestamp: DateTime(2025, 2, 13, 13, 34),
          isRead: true,
          isImage: true,
        ),
      ]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId,
      receiverId: widget.chatId,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.userName.substring(0, 1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(_rating),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_rating',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                Text(
                  _userId,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Food share card
          _buildFoodShareCard(),

          // Date separator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '2025년 2월 13일',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == _currentUserId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            widget.userName.substring(0, 1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Column(
                        crossAxisAlignment:
                            isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          if (message.isImage) ...[
                            // Image message
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  message.content,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ] else ...[
                            // Text message
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isMe
                                        ? const Color(0xFF9BE543)
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                message.content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            _formatAmPmTime(message.timestamp),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // System message
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '상대방이 대화를 종료했습니다.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {},
                    color: Colors.grey[600],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: '메세지 보내기',
                          hintStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
                    onPressed: () {},
                    color: Colors.grey[600],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9BE543),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      iconSize: 16,
                      onPressed: _sendMessage,
                      color: Colors.black,
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

  Widget _buildFoodShareCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/food_image.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sharedFood['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _sharedFood['location'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _sharedFood['label'],
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return const Color(0xFF4CAF50); // Green
    if (rating >= 4.0) return const Color(0xFF8BC34A); // Light Green
    if (rating >= 3.0) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFFF9800); // Orange
  }

  String _formatAmPmTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour < 12 ? '오전' : '오후';
    final formattedHour = hour <= 12 ? hour : hour - 12;
    return '$period ${formattedHour.toString()}:${minute.toString().padLeft(2, '0')}';
  }
}
