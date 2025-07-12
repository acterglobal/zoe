import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/providers/app_state_provider.dart';
import '../common/models/page.dart';
import '../common/models/content_block.dart';
import '../widgets/content_block_widget.dart';

class PageDetailScreen extends StatefulWidget {
  final ZoePage? page;

  const PageDetailScreen({super.key, this.page});

  @override
  State<PageDetailScreen> createState() => _PageDetailScreenState();
}

class _PageDetailScreenState extends State<PageDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late ZoePage _currentPage;
  bool _showAddMenu = false;

  @override
  void initState() {
    super.initState();
    _currentPage =
        widget.page ?? ZoePage(title: 'Untitled', description: '', emoji: '📄');
    _titleController = TextEditingController(text: _currentPage.title);
    _descriptionController = TextEditingController(
      text: _currentPage.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white paper background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF374151)),
          onPressed: () {
            _autoSavePage();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF374151)),
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _deletePage();
                  break;
                case 'duplicate':
                  _duplicatePage();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 8),
                    Text('Duplicate'),
                  ],
                ),
              ),
              if (widget.page != null)
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        size: 16,
                        color: Color(0xFFEF4444),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Hide add menu when tapping outside
          if (_showAddMenu) {
            setState(() {
              _showAddMenu = false;
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            32,
            16,
            32,
            100,
          ), // Single sheet padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              _buildPageHeader(),
              const SizedBox(height: 48),

              // Content Blocks
              _buildContentBlocks(),

              // Add Block Area
              _buildAddBlockArea(),

              const SizedBox(height: 200), // Extra space for typing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emoji and Title Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji
            GestureDetector(
              onTap: _showEmojiPicker,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _currentPage.emoji ?? '📄',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  height: 1.2,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: null,
                onChanged: (value) {
                  _currentPage = _currentPage.copyWith(
                    title: value.trim().isEmpty ? 'Untitled' : value,
                  );
                },
                onEditingComplete: _autoSavePage,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Description
        TextField(
          controller: _descriptionController,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Add a description...',
            hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
          ),
          maxLines: null,
          onChanged: (value) {
            _currentPage = _currentPage.copyWith(description: value);
          },
          onEditingComplete: _autoSavePage,
        ),
      ],
    );
  }

  Widget _buildContentBlocks() {
    if (_currentPage.contentBlocks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _currentPage.contentBlocks.map((block) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ContentBlockWidget(
            block: block,
            isEditing: true, // Always in editing mode
            onUpdate: (updatedBlock) {
              setState(() {
                _currentPage.updateContentBlock(block.id, updatedBlock);
              });
              _autoSavePage();
            },
            onDelete: () {
              setState(() {
                _currentPage.removeContentBlock(block.id);
              });
              _autoSavePage();
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddBlockArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add block trigger
        GestureDetector(
          onTap: () {
            setState(() {
              _showAddMenu = !_showAddMenu;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Icon(
                  _showAddMenu ? Icons.close : Icons.add,
                  size: 20,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 8),
                Text(
                  _showAddMenu ? 'Cancel' : 'Add a block',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Add block menu
        if (_showAddMenu)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                _AddBlockOption(
                  icon: Icons.text_fields,
                  title: 'Text',
                  description: 'Start writing with plain text',
                  onTap: () => _addContentBlock(ContentBlockType.text),
                ),
                _AddBlockOption(
                  icon: Icons.check_box_outlined,
                  title: 'To-do list',
                  description: 'Track tasks with checkboxes',
                  onTap: () => _addContentBlock(ContentBlockType.todo),
                ),
                _AddBlockOption(
                  icon: Icons.event_outlined,
                  title: 'Event',
                  description: 'Schedule and track events',
                  onTap: () => _addContentBlock(ContentBlockType.event),
                ),
                _AddBlockOption(
                  icon: Icons.list,
                  title: 'Bulleted list',
                  description: 'Create a simple bulleted list',
                  onTap: () => _addContentBlock(ContentBlockType.list),
                  isLast: true,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _addContentBlock(ContentBlockType type) {
    ContentBlock newBlock;
    switch (type) {
      case ContentBlockType.todo:
        newBlock = TodoBlock(
          title: 'To-do',
          items: [TodoItem(text: '')],
        );
        break;
      case ContentBlockType.event:
        newBlock = EventBlock(
          title: 'Events',
          events: [EventItem(title: '', startTime: DateTime.now())],
        );
        break;
      case ContentBlockType.list:
        newBlock = ListBlock(title: 'List', items: ['']);
        break;
      case ContentBlockType.text:
        newBlock = TextBlock(content: '');
        break;
    }

    setState(() {
      _currentPage.addContentBlock(newBlock);
      _showAddMenu = false;
    });
    _autoSavePage();
  }

  void _showEmojiPicker() {
    const emojis = [
      '📄',
      '📝',
      '📋',
      '📊',
      '📈',
      '🎯',
      '💡',
      '🚀',
      '⭐',
      '🎉',
      '📚',
      '💼',
      '🏠',
      '🎨',
      '🔬',
    ];
    final currentIndex = emojis.indexOf(_currentPage.emoji ?? '📄');
    final nextIndex = (currentIndex + 1) % emojis.length;

    setState(() {
      _currentPage = _currentPage.copyWith(emoji: emojis[nextIndex]);
    });
    _autoSavePage();
  }

  void _autoSavePage() {
    final updatedPage = _currentPage.copyWith(
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    final appState = Provider.of<AppStateProvider>(context, listen: false);

    if (widget.page == null) {
      // New page
      appState.addPage(updatedPage);
    } else {
      // Update existing page
      appState.updatePage(updatedPage);
    }

    _currentPage = updatedPage;
  }

  void _deletePage() {
    if (widget.page == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Page'),
        content: const Text(
          'Are you sure you want to delete this page? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final appState = Provider.of<AppStateProvider>(
                context,
                listen: false,
              );
              appState.deletePage(widget.page!.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close page
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _duplicatePage() {
    final duplicatedPage = ZoePage(
      title: '${_currentPage.title} (Copy)',
      description: _currentPage.description,
      emoji: _currentPage.emoji,
      contentBlocks: _currentPage.contentBlocks,
    );

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.addPage(duplicatedPage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page duplicated successfully')),
    );
  }
}

class _AddBlockOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool isLast;

  const _AddBlockOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF6B7280)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
