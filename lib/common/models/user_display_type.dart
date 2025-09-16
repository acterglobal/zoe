enum ZoeUserDisplayType {
  /// Shows only avatar in the row
  avatarOnly,
  
  /// Shows user name chip below
  nameChipBelow,
  
  /// Shows stacked avatars in the row (for multiple users)
  stackedAvatars,
  
  /// Shows user name chips in a wrap layout (for multiple users)
  nameChipsWrap;

  bool get showInRow => this == ZoeUserDisplayType.avatarOnly || 
                       this == ZoeUserDisplayType.stackedAvatars;
                       
  bool get showBelow => this == ZoeUserDisplayType.nameChipBelow || 
                       this == ZoeUserDisplayType.nameChipsWrap;
                       
  bool get isMultiUser => this == ZoeUserDisplayType.stackedAvatars || 
                         this == ZoeUserDisplayType.nameChipsWrap;
}
