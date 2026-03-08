import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabvault/core/utils/database_helper.dart';
import 'package:vocabvault/presentation/bloc/vocabulary_bloc.dart';
import 'package:vocabvault/presentation/screens/camera_screen.dart';
import 'package:vocabvault/presentation/screens/flashcard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();

    // Load vocabulary cards on init
    context.read<VocabularyBloc>().add(const GetAllVocabularyCardsEvent());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _resetDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Reset Database'),
        content: const Text(
          'ข้อมูลคำศัพท์ทั้งหมดจะถูกลบและไม่สามารถกู้คืนได้\n\n'
          'คุณแน่ใจหรือไม่ว่าต้องการดำเนินการต่อ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ลบข้อมูล'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await DatabaseHelper.instance.resetDatabase();
        if (mounted) {
          context.read<VocabularyBloc>().add(const GetAllVocabularyCardsEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ ฐานข้อมูลถูกรีเซ็ตเรียบร้อยแล้ว'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VocabVault'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6366F1),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset_db':
                  _resetDatabase();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'reset_db',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Reset Database'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildVocabularySection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        tooltip: 'Scan Text',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to VocabVault!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn vocabulary from real-world text using AI-powered translations',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Scan Text',
            icon: Icons.qr_code_scanner,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            title: 'Flashcards',
            icon: Icons.collections,
            onTap: () {
              final state = context.read<VocabularyBloc>().state;
              if (state is VocabularyLoaded && state.cards.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardScreen(cards: state.cards),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No vocabulary cards available')),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF6366F1), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF6366F1), size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVocabularySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Vocabulary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<VocabularyBloc, VocabularyState>(
          builder: (context, state) {
            // Debug info
            String debugInfo = '';
            if (state is VocabularyInitial) debugInfo = 'Initial state';
            else if (state is VocabularyLoading) debugInfo = 'Loading...';
            else if (state is VocabularyLoaded) debugInfo = 'Loaded: ${state.cards.length} cards';
            else if (state is VocabularyError) debugInfo = 'Error: ${state.message}';
            else debugInfo = 'Unknown state: ${state.runtimeType}';

            // print('HomeScreen: Current state: $debugInfo');

            Widget content;
            if (state is VocabularyLoading) {
              content = const Center(child: CircularProgressIndicator());
            } else if (state is VocabularyLoaded) {
              if (state.cards.isEmpty) {
                content = Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(Icons.book_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No vocabulary cards yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<VocabularyBloc>().add(const GetAllVocabularyCardsEvent());
                        },
                        child: const Text('Reload Data'),
                      ),
                      // const SizedBox(height: 8),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Add a test card
                      //     final testCard = VocabularyCard(
                      //       id: const Uuid().v4(),
                      //       word: 'Test Word',
                      //       pronunciation: '/tɛst wɜːrd/',
                      //       meaning: 'A word used for testing',
                      //       contextMeaning: 'Used to verify functionality',
                      //       exampleSentences: ['This is a test sentence.', 'Another test example.'],
                      //       category: WordCategory.noun,
                      //       originalImagePath: '',
                      //       createdAt: DateTime.now(),
                      //       updatedAt: DateTime.now(),
                      //     );
                      //     context.read<VocabularyBloc>().add(AddVocabularyCardEvent(testCard));
                      //   },
                      //   child: const Text('Add Test Card'),
                      // ),
                    ],
                  ),
                );
              } else {
                content = ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.cards.length,
                  itemBuilder: (context, index) {
                    final card = state.cards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(card.word),
                        subtitle: Text(card.meaning),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
              }
            } else if (state is VocabularyError) {
              content = Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              content = const SizedBox.shrink();
            }

            return Column(
              children: [
                // Debug info (แสดงเฉพาะใน debug mode)
                if (debugInfo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Debug: $debugInfo',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                content,
              ],
            );
          },
        ),
      ],
    );
  }
}
