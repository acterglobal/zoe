import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/providers/app_state_provider.dart';
import '../../../common/models/zoe_sheet_model.dart';
import '../../../common/models/content_block.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/widgets/content_block_widget.dart';
import '../../../common/widgets/whatsapp_integration_bottomsheet.dart';

class SheetDetailScreen extends ConsumerStatefulWidget {
  final ZoeSheet? page;
  final bool isEmbedded;

  const SheetDetailScreen({super.key, this.page, this.isEmbedded = false});

  @override
  ConsumerState<SheetDetailScreen> createState() => _SheetDetailScreenState();
}

class _SheetDetailScreenState extends ConsumerState<SheetDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late ZoeSheet _currentPage;
  bool _showAddMenu = false;
  bool _isEditing = false; // Add editing state
  bool _hasBeenSaved = false; // Track if page has been saved

  @override
  void initState() {
    super.initState();
    _currentPage =
        widget.page ??
        ZoeSheet(title: 'Untitled', description: '', emoji: '📄');
    _titleController = TextEditingController(text: _currentPage.title);
    _descriptionController = TextEditingController(
      text: _currentPage.description,
    );
    // Start in edit mode for new pages, view mode for existing pages
    _isEditing = widget.page == null;
    // Existing pages are already saved
    _hasBeenSaved = widget.page != null;
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
          onPressed: () => context.go(AppRoutes.home.route),
        ),
        actions: [
          // Edit/Save button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    // Save the page and switch to view mode
                    _savePage();
                    _isEditing = false;
                    _showAddMenu =
                        false; // Hide add menu when switching to view mode
                  } else {
                    // Switch to edit mode
                    _isEditing = true;
                  }
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: _isEditing
                    ? const Color(0xFF3B82F6) // Blue background for Save
                    : AppTheme.getSurfaceVariant(
                        context,
                      ), // Subtle background for Edit
                foregroundColor: _isEditing
                    ? Colors
                          .white // White text for Save
                    : AppTheme.getTextPrimary(context), // Theme text for Edit
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(60, 36),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isEditing ? Icons.save_rounded : Icons.edit_rounded,
                    size: 16,
                    color: _isEditing
                        ? Colors.white
                        : AppTheme.getTextPrimary(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _isEditing
                          ? Colors.white
                          : AppTheme.getTextPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // WhatsApp Integration button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _showWhatsAppIntegration,
              style: IconButton.styleFrom(
                backgroundColor: _currentPage.isWhatsAppConnected
                    ? const Color(0xFF25D366).withValues(alpha: 0.1)
                    : AppTheme.getSurfaceVariant(context),
                foregroundColor: _currentPage.isWhatsAppConnected
                    ? const Color(0xFF25D366)
                    : AppTheme.getTextSecondary(context),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _buildWhatsAppIcon(),
              tooltip: _currentPage.isWhatsAppConnected
                  ? 'WhatsApp Connected'
                  : 'Connect to WhatsApp',
            ),
          ),
          // More menu (always visible)
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
              PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: AppTheme.getTextSecondary(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Duplicate',
                      style: TextStyle(color: AppTheme.getTextPrimary(context)),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      size: 16,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 8),
                    const Text(
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
              onTap: _isEditing ? _showEmojiPicker : null,
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
              child: _isEditing
                  ? TextField(
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
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _currentPage.title.isEmpty
                            ? 'Untitled'
                            : _currentPage.title,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getTextPrimary(context),
                          height: 1.2,
                        ),
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
                  color: AppTheme.getTextSecondary(context),
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a description...',
                  hintStyle: TextStyle(
                    color: AppTheme.getTextSecondary(
                      context,
                    ).withValues(alpha: 0.6),
                  ),
                ),
                maxLines: null,
                onChanged: (value) {
                  _currentPage = _currentPage.copyWith(description: value);
                },
              )
            : _currentPage.description.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _currentPage.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.getTextSecondary(context),
                    height: 1.5,
                  ),
                ),
              )
            : const SizedBox.shrink(),
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
      buildDefaultDragHandles: false, // Disable default drag handles
      onReorder: (oldIndex, newIndex) {
        setState(() {
          _currentPage.reorderContentBlocks(oldIndex, newIndex);
        });
      },
      itemBuilder: (context, index) {
        final block = _currentPage.contentBlocks[index];
        return Padding(
          key: ValueKey(block.id),
          padding: const EdgeInsets.only(bottom: 24),
          child: ContentBlockWidget(
            block: block,
            blockIndex: index,
            isEditing: _isEditing, // Use the current editing state
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
      },
    );
  }

  Widget _buildAddBlockArea() {
    // Only show add block area in editing mode
    if (!_isEditing) return const SizedBox.shrink();

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
  }

  void _savePage() {
    final updatedPage = _currentPage.copyWith(
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    final appStateNotifier = ref.read(appStateProvider.notifier);

    if (!_hasBeenSaved) {
      // New page - add to state
      appStateNotifier.addSheet(updatedPage);
      _hasBeenSaved = true;
    } else {
      // Update existing page
      appStateNotifier.updateSheet(updatedPage);
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
                final appStateNotifier = ref.read(appStateProvider.notifier);
                appStateNotifier.deleteSheet(widget.page!.id);
              }
              // For both new and existing pages, close dialog and page
              Navigator.of(context).pop(); // Close dialog

              // Navigate back to home
              context.go(AppRoutes.home.route);
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
    final duplicatedPage = ZoeSheet(
      title: '${_currentPage.title} (Copy)',
      description: _currentPage.description,
      emoji: _currentPage.emoji,
      contentBlocks: _currentPage.contentBlocks,
    );

    final appStateNotifier = ref.read(appStateProvider.notifier);
    appStateNotifier.addSheet(duplicatedPage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page duplicated successfully')),
    );
  }

  void _showWhatsAppIntegration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsAppIntegrationBottomSheet(
        currentSheet: _currentPage,
        onConnectionChanged: (isConnected) {
          setState(() {
            _currentPage = _currentPage.copyWith(
              isWhatsAppConnected: isConnected,
            );
          });

          // Update the page in app state if it has been saved
          if (_hasBeenSaved) {
            final appStateNotifier = ref.read(appStateProvider.notifier);
            appStateNotifier.updateSheet(_currentPage);
          }
        },
      ),
    );
  }

  Widget _buildWhatsAppIcon() {
    final color = _currentPage.isWhatsAppConnected
        ? const Color(0xFF25D366)
        : AppTheme.getTextSecondary(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle (WhatsApp green or gray)
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        // Phone icon in white
        Icon(Icons.phone_rounded, size: 12, color: Colors.white),
      ],
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
