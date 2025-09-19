// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Metadata {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res, Metadata>;
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res, $Val extends Metadata>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$Metadata_GenericImplCopyWith<$Res> {
  factory _$$Metadata_GenericImplCopyWith(
    _$Metadata_GenericImpl value,
    $Res Function(_$Metadata_GenericImpl) then,
  ) = __$$Metadata_GenericImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String key, String value});
}

/// @nodoc
class __$$Metadata_GenericImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_GenericImpl>
    implements _$$Metadata_GenericImplCopyWith<$Res> {
  __$$Metadata_GenericImplCopyWithImpl(
    _$Metadata_GenericImpl _value,
    $Res Function(_$Metadata_GenericImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? value = null}) {
    return _then(
      _$Metadata_GenericImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_GenericImpl extends Metadata_Generic {
  const _$Metadata_GenericImpl({required this.key, required this.value})
    : super._();

  @override
  final String key;
  @override
  final String value;

  @override
  String toString() {
    return 'Metadata.generic(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_GenericImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_GenericImplCopyWith<_$Metadata_GenericImpl> get copyWith =>
      __$$Metadata_GenericImplCopyWithImpl<_$Metadata_GenericImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return generic(key, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return generic?.call(key, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(key, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return generic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return generic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (generic != null) {
      return generic(this);
    }
    return orElse();
  }
}

abstract class Metadata_Generic extends Metadata {
  const factory Metadata_Generic({
    required final String key,
    required final String value,
  }) = _$Metadata_GenericImpl;
  const Metadata_Generic._() : super._();

  String get key;
  String get value;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_GenericImplCopyWith<_$Metadata_GenericImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_DescriptionImplCopyWith<$Res> {
  factory _$$Metadata_DescriptionImplCopyWith(
    _$Metadata_DescriptionImpl value,
    $Res Function(_$Metadata_DescriptionImpl) then,
  ) = __$$Metadata_DescriptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Metadata_DescriptionImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_DescriptionImpl>
    implements _$$Metadata_DescriptionImplCopyWith<$Res> {
  __$$Metadata_DescriptionImplCopyWithImpl(
    _$Metadata_DescriptionImpl _value,
    $Res Function(_$Metadata_DescriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_DescriptionImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_DescriptionImpl extends Metadata_Description {
  const _$Metadata_DescriptionImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Metadata.description(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_DescriptionImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_DescriptionImplCopyWith<_$Metadata_DescriptionImpl>
  get copyWith =>
      __$$Metadata_DescriptionImplCopyWithImpl<_$Metadata_DescriptionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return description(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return description?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (description != null) {
      return description(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return description(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return description?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (description != null) {
      return description(this);
    }
    return orElse();
  }
}

abstract class Metadata_Description extends Metadata {
  const factory Metadata_Description(final String field0) =
      _$Metadata_DescriptionImpl;
  const Metadata_Description._() : super._();

  String get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_DescriptionImplCopyWith<_$Metadata_DescriptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_AvatarImplCopyWith<$Res> {
  factory _$$Metadata_AvatarImplCopyWith(
    _$Metadata_AvatarImpl value,
    $Res Function(_$Metadata_AvatarImpl) then,
  ) = __$$Metadata_AvatarImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Image field0});
}

/// @nodoc
class __$$Metadata_AvatarImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_AvatarImpl>
    implements _$$Metadata_AvatarImplCopyWith<$Res> {
  __$$Metadata_AvatarImplCopyWithImpl(
    _$Metadata_AvatarImpl _value,
    $Res Function(_$Metadata_AvatarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_AvatarImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Image,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_AvatarImpl extends Metadata_Avatar {
  const _$Metadata_AvatarImpl(this.field0) : super._();

  @override
  final Image field0;

  @override
  String toString() {
    return 'Metadata.avatar(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_AvatarImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_AvatarImplCopyWith<_$Metadata_AvatarImpl> get copyWith =>
      __$$Metadata_AvatarImplCopyWithImpl<_$Metadata_AvatarImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return avatar(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return avatar?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (avatar != null) {
      return avatar(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return avatar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return avatar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (avatar != null) {
      return avatar(this);
    }
    return orElse();
  }
}

abstract class Metadata_Avatar extends Metadata {
  const factory Metadata_Avatar(final Image field0) = _$Metadata_AvatarImpl;
  const Metadata_Avatar._() : super._();

  Image get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_AvatarImplCopyWith<_$Metadata_AvatarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_BackgroundImplCopyWith<$Res> {
  factory _$$Metadata_BackgroundImplCopyWith(
    _$Metadata_BackgroundImpl value,
    $Res Function(_$Metadata_BackgroundImpl) then,
  ) = __$$Metadata_BackgroundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Image field0});
}

/// @nodoc
class __$$Metadata_BackgroundImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_BackgroundImpl>
    implements _$$Metadata_BackgroundImplCopyWith<$Res> {
  __$$Metadata_BackgroundImplCopyWithImpl(
    _$Metadata_BackgroundImpl _value,
    $Res Function(_$Metadata_BackgroundImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_BackgroundImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Image,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_BackgroundImpl extends Metadata_Background {
  const _$Metadata_BackgroundImpl(this.field0) : super._();

  @override
  final Image field0;

  @override
  String toString() {
    return 'Metadata.background(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_BackgroundImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_BackgroundImplCopyWith<_$Metadata_BackgroundImpl> get copyWith =>
      __$$Metadata_BackgroundImplCopyWithImpl<_$Metadata_BackgroundImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return background(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return background?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (background != null) {
      return background(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return background(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return background?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (background != null) {
      return background(this);
    }
    return orElse();
  }
}

abstract class Metadata_Background extends Metadata {
  const factory Metadata_Background(final Image field0) =
      _$Metadata_BackgroundImpl;
  const Metadata_Background._() : super._();

  Image get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_BackgroundImplCopyWith<_$Metadata_BackgroundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_WebsiteImplCopyWith<$Res> {
  factory _$$Metadata_WebsiteImplCopyWith(
    _$Metadata_WebsiteImpl value,
    $Res Function(_$Metadata_WebsiteImpl) then,
  ) = __$$Metadata_WebsiteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Metadata_WebsiteImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_WebsiteImpl>
    implements _$$Metadata_WebsiteImplCopyWith<$Res> {
  __$$Metadata_WebsiteImplCopyWithImpl(
    _$Metadata_WebsiteImpl _value,
    $Res Function(_$Metadata_WebsiteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_WebsiteImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_WebsiteImpl extends Metadata_Website {
  const _$Metadata_WebsiteImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Metadata.website(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_WebsiteImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_WebsiteImplCopyWith<_$Metadata_WebsiteImpl> get copyWith =>
      __$$Metadata_WebsiteImplCopyWithImpl<_$Metadata_WebsiteImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return website(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return website?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (website != null) {
      return website(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return website(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return website?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (website != null) {
      return website(this);
    }
    return orElse();
  }
}

abstract class Metadata_Website extends Metadata {
  const factory Metadata_Website(final String field0) = _$Metadata_WebsiteImpl;
  const Metadata_Website._() : super._();

  String get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_WebsiteImplCopyWith<_$Metadata_WebsiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_EmailImplCopyWith<$Res> {
  factory _$$Metadata_EmailImplCopyWith(
    _$Metadata_EmailImpl value,
    $Res Function(_$Metadata_EmailImpl) then,
  ) = __$$Metadata_EmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Metadata_EmailImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_EmailImpl>
    implements _$$Metadata_EmailImplCopyWith<$Res> {
  __$$Metadata_EmailImplCopyWithImpl(
    _$Metadata_EmailImpl _value,
    $Res Function(_$Metadata_EmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_EmailImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_EmailImpl extends Metadata_Email {
  const _$Metadata_EmailImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Metadata.email(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_EmailImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_EmailImplCopyWith<_$Metadata_EmailImpl> get copyWith =>
      __$$Metadata_EmailImplCopyWithImpl<_$Metadata_EmailImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return email(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return email?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (email != null) {
      return email(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return email(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return email?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (email != null) {
      return email(this);
    }
    return orElse();
  }
}

abstract class Metadata_Email extends Metadata {
  const factory Metadata_Email(final String field0) = _$Metadata_EmailImpl;
  const Metadata_Email._() : super._();

  String get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_EmailImplCopyWith<_$Metadata_EmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_PhoneImplCopyWith<$Res> {
  factory _$$Metadata_PhoneImplCopyWith(
    _$Metadata_PhoneImpl value,
    $Res Function(_$Metadata_PhoneImpl) then,
  ) = __$$Metadata_PhoneImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Metadata_PhoneImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_PhoneImpl>
    implements _$$Metadata_PhoneImplCopyWith<$Res> {
  __$$Metadata_PhoneImplCopyWithImpl(
    _$Metadata_PhoneImpl _value,
    $Res Function(_$Metadata_PhoneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_PhoneImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_PhoneImpl extends Metadata_Phone {
  const _$Metadata_PhoneImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Metadata.phone(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_PhoneImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_PhoneImplCopyWith<_$Metadata_PhoneImpl> get copyWith =>
      __$$Metadata_PhoneImplCopyWithImpl<_$Metadata_PhoneImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return phone(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return phone?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return phone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return phone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(this);
    }
    return orElse();
  }
}

abstract class Metadata_Phone extends Metadata {
  const factory Metadata_Phone(final String field0) = _$Metadata_PhoneImpl;
  const Metadata_Phone._() : super._();

  String get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_PhoneImplCopyWith<_$Metadata_PhoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_AddressImplCopyWith<$Res> {
  factory _$$Metadata_AddressImplCopyWith(
    _$Metadata_AddressImpl value,
    $Res Function(_$Metadata_AddressImpl) then,
  ) = __$$Metadata_AddressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$Metadata_AddressImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_AddressImpl>
    implements _$$Metadata_AddressImplCopyWith<$Res> {
  __$$Metadata_AddressImplCopyWithImpl(
    _$Metadata_AddressImpl _value,
    $Res Function(_$Metadata_AddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$Metadata_AddressImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_AddressImpl extends Metadata_Address {
  const _$Metadata_AddressImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'Metadata.address(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_AddressImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_AddressImplCopyWith<_$Metadata_AddressImpl> get copyWith =>
      __$$Metadata_AddressImplCopyWithImpl<_$Metadata_AddressImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return address(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return address?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (address != null) {
      return address(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return address(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return address?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (address != null) {
      return address(this);
    }
    return orElse();
  }
}

abstract class Metadata_Address extends Metadata {
  const factory Metadata_Address(final String field0) = _$Metadata_AddressImpl;
  const Metadata_Address._() : super._();

  String get field0;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_AddressImplCopyWith<_$Metadata_AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_SocialImplCopyWith<$Res> {
  factory _$$Metadata_SocialImplCopyWith(
    _$Metadata_SocialImpl value,
    $Res Function(_$Metadata_SocialImpl) then,
  ) = __$$Metadata_SocialImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String platform, String handle});
}

/// @nodoc
class __$$Metadata_SocialImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_SocialImpl>
    implements _$$Metadata_SocialImplCopyWith<$Res> {
  __$$Metadata_SocialImplCopyWithImpl(
    _$Metadata_SocialImpl _value,
    $Res Function(_$Metadata_SocialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? platform = null, Object? handle = null}) {
    return _then(
      _$Metadata_SocialImpl(
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        handle: null == handle
            ? _value.handle
            : handle // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_SocialImpl extends Metadata_Social {
  const _$Metadata_SocialImpl({required this.platform, required this.handle})
    : super._();

  @override
  final String platform;
  @override
  final String handle;

  @override
  String toString() {
    return 'Metadata.social(platform: $platform, handle: $handle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_SocialImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.handle, handle) || other.handle == handle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, platform, handle);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_SocialImplCopyWith<_$Metadata_SocialImpl> get copyWith =>
      __$$Metadata_SocialImplCopyWithImpl<_$Metadata_SocialImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return social(platform, handle);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return social?.call(platform, handle);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (social != null) {
      return social(platform, handle);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return social(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return social?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (social != null) {
      return social(this);
    }
    return orElse();
  }
}

abstract class Metadata_Social extends Metadata {
  const factory Metadata_Social({
    required final String platform,
    required final String handle,
  }) = _$Metadata_SocialImpl;
  const Metadata_Social._() : super._();

  String get platform;
  String get handle;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_SocialImplCopyWith<_$Metadata_SocialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Metadata_UnknownImplCopyWith<$Res> {
  factory _$$Metadata_UnknownImplCopyWith(
    _$Metadata_UnknownImpl value,
    $Res Function(_$Metadata_UnknownImpl) then,
  ) = __$$Metadata_UnknownImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int discriminant, Uint8List data});
}

/// @nodoc
class __$$Metadata_UnknownImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$Metadata_UnknownImpl>
    implements _$$Metadata_UnknownImplCopyWith<$Res> {
  __$$Metadata_UnknownImplCopyWithImpl(
    _$Metadata_UnknownImpl _value,
    $Res Function(_$Metadata_UnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? discriminant = null, Object? data = null}) {
    return _then(
      _$Metadata_UnknownImpl(
        discriminant: null == discriminant
            ? _value.discriminant
            : discriminant // ignore: cast_nullable_to_non_nullable
                  as int,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$Metadata_UnknownImpl extends Metadata_Unknown {
  const _$Metadata_UnknownImpl({required this.discriminant, required this.data})
    : super._();

  @override
  final int discriminant;
  @override
  final Uint8List data;

  @override
  String toString() {
    return 'Metadata.unknown(discriminant: $discriminant, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Metadata_UnknownImpl &&
            (identical(other.discriminant, discriminant) ||
                other.discriminant == discriminant) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    discriminant,
    const DeepCollectionEquality().hash(data),
  );

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Metadata_UnknownImplCopyWith<_$Metadata_UnknownImpl> get copyWith =>
      __$$Metadata_UnknownImplCopyWithImpl<_$Metadata_UnknownImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String key, String value) generic,
    required TResult Function(String field0) description,
    required TResult Function(Image field0) avatar,
    required TResult Function(Image field0) background,
    required TResult Function(String field0) website,
    required TResult Function(String field0) email,
    required TResult Function(String field0) phone,
    required TResult Function(String field0) address,
    required TResult Function(String platform, String handle) social,
    required TResult Function(int discriminant, Uint8List data) unknown,
  }) {
    return unknown(discriminant, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String key, String value)? generic,
    TResult? Function(String field0)? description,
    TResult? Function(Image field0)? avatar,
    TResult? Function(Image field0)? background,
    TResult? Function(String field0)? website,
    TResult? Function(String field0)? email,
    TResult? Function(String field0)? phone,
    TResult? Function(String field0)? address,
    TResult? Function(String platform, String handle)? social,
    TResult? Function(int discriminant, Uint8List data)? unknown,
  }) {
    return unknown?.call(discriminant, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String key, String value)? generic,
    TResult Function(String field0)? description,
    TResult Function(Image field0)? avatar,
    TResult Function(Image field0)? background,
    TResult Function(String field0)? website,
    TResult Function(String field0)? email,
    TResult Function(String field0)? phone,
    TResult Function(String field0)? address,
    TResult Function(String platform, String handle)? social,
    TResult Function(int discriminant, Uint8List data)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(discriminant, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Metadata_Generic value) generic,
    required TResult Function(Metadata_Description value) description,
    required TResult Function(Metadata_Avatar value) avatar,
    required TResult Function(Metadata_Background value) background,
    required TResult Function(Metadata_Website value) website,
    required TResult Function(Metadata_Email value) email,
    required TResult Function(Metadata_Phone value) phone,
    required TResult Function(Metadata_Address value) address,
    required TResult Function(Metadata_Social value) social,
    required TResult Function(Metadata_Unknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Metadata_Generic value)? generic,
    TResult? Function(Metadata_Description value)? description,
    TResult? Function(Metadata_Avatar value)? avatar,
    TResult? Function(Metadata_Background value)? background,
    TResult? Function(Metadata_Website value)? website,
    TResult? Function(Metadata_Email value)? email,
    TResult? Function(Metadata_Phone value)? phone,
    TResult? Function(Metadata_Address value)? address,
    TResult? Function(Metadata_Social value)? social,
    TResult? Function(Metadata_Unknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Metadata_Generic value)? generic,
    TResult Function(Metadata_Description value)? description,
    TResult Function(Metadata_Avatar value)? avatar,
    TResult Function(Metadata_Background value)? background,
    TResult Function(Metadata_Website value)? website,
    TResult Function(Metadata_Email value)? email,
    TResult Function(Metadata_Phone value)? phone,
    TResult Function(Metadata_Address value)? address,
    TResult Function(Metadata_Social value)? social,
    TResult Function(Metadata_Unknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class Metadata_Unknown extends Metadata {
  const factory Metadata_Unknown({
    required final int discriminant,
    required final Uint8List data,
  }) = _$Metadata_UnknownImpl;
  const Metadata_Unknown._() : super._();

  int get discriminant;
  Uint8List get data;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Metadata_UnknownImplCopyWith<_$Metadata_UnknownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
