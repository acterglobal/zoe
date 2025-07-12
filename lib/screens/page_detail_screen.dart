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
  bool _isEditing = false;

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
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check_rounded : Icons.edit_rounded,
              color: const Color(0xFF1F2937),
            ),
            onPressed: () {
              if (_isEditing) {
                _savePage();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1F2937)),
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
                    Icon(Icons.copy_rounded, size: 16),
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
                      Icon(Icons.delete_rounded, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            _buildPageHeader(),
            const SizedBox(height: 32),

            // Content Blocks
            _buildContentBlocks(),
            const SizedBox(height: 24),

            // Add Block Button
            if (_isEditing) _buildAddBlockButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emoji and Title
        Row(
          children: [
            GestureDetector(
              onTap: _isEditing ? _showEmojiPicker : null,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _currentPage.emoji ?? '📄',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Page title',
                      ),
                    )
                  : Text(
                      _currentPage.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        _isEditing
            ? TextField(
                controller: _descriptionController,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF6B7280),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a description...',
                ),
                maxLines: null,
              )
            : _currentPage.description.isNotEmpty
            ? Text(
                _currentPage.description,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF6B7280),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildContentBlocks() {
    return Column(
      children: _currentPage.contentBlocks.map((block) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ContentBlockWidget(
            block: block,
            isEditing: _isEditing,
            onUpdate: (updatedBlock) {
              setState(() {
                _currentPage.updateContentBlock(block.id, updatedBlock);
              });
            },
            onDelete: () {
              setState(() {
                _currentPage.removeContentBlock(block.id);
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddBlockButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _AddBlockOption(
            icon: Icons.check_box_rounded,
            title: 'To-do list',
            description: 'Track tasks with checkboxes',
            onTap: () => _addContentBlock(ContentBlockType.todo),
          ),
          _AddBlockOption(
            icon: Icons.event_rounded,
            title: 'Event',
            description: 'Schedule and track events',
            onTap: () => _addContentBlock(ContentBlockType.event),
          ),
          _AddBlockOption(
            icon: Icons.list_rounded,
            title: 'List',
            description: 'Create a simple list',
            onTap: () => _addContentBlock(ContentBlockType.list),
          ),
          _AddBlockOption(
            icon: Icons.text_fields_rounded,
            title: 'Text',
            description: 'Add some text content',
            onTap: () => _addContentBlock(ContentBlockType.text),
            isLast: true,
          ),
        ],
      ),
    );
  }

  void _addContentBlock(ContentBlockType type) {
    ContentBlock newBlock;
    switch (type) {
      case ContentBlockType.todo:
        newBlock = TodoBlock(
          title: 'New To-do List',
          items: [TodoItem(text: 'New task')],
        );
        break;
      case ContentBlockType.event:
        newBlock = EventBlock(
          title: 'New Events',
          events: [EventItem(title: 'New event', startTime: DateTime.now())],
        );
        break;
      case ContentBlockType.list:
        newBlock = ListBlock(title: 'New List', items: ['Item 1']);
        break;
      case ContentBlockType.text:
        newBlock = TextBlock(content: 'Type something...');
        break;
    }

    setState(() {
      _currentPage.addContentBlock(newBlock);
    });
  }

  void _showEmojiPicker() {
    // TODO: Implement emoji picker
    // For now, just cycle through some emojis
    const emojis = ['📄', '📝', '📋', '📊', '📈', '🎯', '💡', '🚀', '⭐', '🎉'];
    final currentIndex = emojis.indexOf(_currentPage.emoji ?? '📄');
    final nextIndex = (currentIndex + 1) % emojis.length;

    setState(() {
      _currentPage = _currentPage.copyWith(emoji: emojis[nextIndex]);
    });
  }

  void _savePage() {
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

    setState(() {
      _currentPage = updatedPage;
      _isEditing = false;
    });
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
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: const Color(0xFF6B7280).withOpacity(0.1),
                  ),
                ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6366F1)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
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
