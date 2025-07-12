import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/providers/app_state_provider.dart';
import '../common/models/page.dart';
import '../common/models/content_block.dart';
import '../common/theme/app_theme.dart';
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
      backgroundColor: AppTheme.getSurface(context),
      appBar: AppBar(
        backgroundColor: AppTheme.getSurface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.getTextPrimary(context),
          ),
          onPressed: () {
            _autoSavePage();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppTheme.getTextPrimary(context),
            ),
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
                    Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
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
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width > 600
                ? 32
                : 16, // Less padding on mobile
            16,
            MediaQuery.of(context).size.width > 600
                ? 32
                : 16, // Less padding on mobile
            100,
          ), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              _buildPageHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.width > 600 ? 48 : 32,
              ), // Less spacing on mobile
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
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextPrimary(context),
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    color: AppTheme.getTextSecondary(context),
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
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.getTextSecondary(context),
            height: 1.5,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Add a description...',
            hintStyle: TextStyle(
              color: AppTheme.getTextSecondary(context).withOpacity(0.6),
            ),
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

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _currentPage.contentBlocks.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          _currentPage.reorderContentBlocks(oldIndex, newIndex);
        });
        _autoSavePage();
      },
      itemBuilder: (context, index) {
        final block = _currentPage.contentBlocks[index];
        return Padding(
          key: ValueKey(block.id),
          padding: const EdgeInsets.only(bottom: 24),
          child: ContentBlockWidget(
            block: block,
            blockIndex: index,
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
      },
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
                  color: AppTheme.getTextSecondary(context),
                ),
                const SizedBox(width: 8),
                Text(
                  _showAddMenu ? 'Cancel' : 'Add a block',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getTextSecondary(context),
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
              color: AppTheme.getSurface(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.getBorder(context)),
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
        newBlock = TextBlock(title: 'Text Block', content: '');
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.page == null ? 'Discard Page' : 'Delete Page'),
        content: Text(
          widget.page == null
              ? 'Are you sure you want to discard this page? Any unsaved changes will be lost.'
              : 'Are you sure you want to delete this page? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (widget.page != null) {
                // Delete existing page
                final appState = Provider.of<AppStateProvider>(
                  context,
                  listen: false,
                );
                appState.deletePage(widget.page!.id);
              }
              // For both new and existing pages, close dialog and page
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close page
            },
            child: Text(
              widget.page == null ? 'Discard' : 'Delete',
              style: const TextStyle(color: Color(0xFFEF4444)),
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
            Icon(icon, size: 18, color: AppTheme.getTextSecondary(context)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.getTextSecondary(context),
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
