enum ZoeUserChipType {
  /// Shows only user name in a chip
  userNameChip,
  
  /// Shows user name with avatar in a chip
  userNameWithAvatarChip;

  bool get showAvatar => this == ZoeUserChipType.userNameWithAvatarChip;
}
