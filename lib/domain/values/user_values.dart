import 'dart:ui';

import 'package:tasky/core/either.dart';
import 'package:tasky/core/value_object.dart';

/// Class representing a valid user name.
class UserName extends ValueObject<String> {
  static const int maxLength = 256;

  @override
  final Either<ValueFailure<String>, String> value;

  const UserName._(this.value);

  /// Creates a [UserName] from an input [String] that has
  /// at most [maxLength] characters.
  /// If the input is null [AssertionError] will be thrown.
  factory UserName(String input) {
    if (input == null || input.isEmpty)
      return UserName._(Either.left(ValueFailure.empty(input)));
    if (input.length > maxLength)
      return UserName._(Either.left(ValueFailure.tooLong(input)));
    return UserName._(Either.right(input));
  }

  @override
  String toString() =>
      "UserName(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid email address.
class EmailAddress extends ValueObject<String> {
  static const String _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

  @override
  final Either<ValueFailure<String>, String> value;

  const EmailAddress._(this.value);

  /// Creates an [EmailAddress] from a [String] email.
  /// If the email is invalid this will have a value
  /// of type [ValueFailure].
  factory EmailAddress(String email) {
    if (email == null || !RegExp(_emailRegex).hasMatch(email))
      return EmailAddress._(Either.left(ValueFailure.invalidEmail(email)));
    else
      return EmailAddress._(Either.right(email));
  }

  @override
  String toString() =>
      "EmailAddress(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a valid password.
class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  const Password._(this.value);

  /// Creates a [Password] from a [String]
  /// password.
  /// The password can't be null or empty.
  factory Password(String pwd) {
    if (pwd == null || pwd.isEmpty)
      return Password._(Either.left(ValueFailure.invalidPassword(pwd)));
    else
      return Password._(Either.right(pwd));
  }

  @override
  String toString() =>
      "Password(${value.fold((left) => left, (right) => right)})";
}

/// Class representing a user's profile color.
class ProfileColor extends ValueObject<Color> {
  @override
  final Either<ValueFailure<Color>, Color> value;

  ProfileColor._(this.value);

  /// Create a [ProfileColor] from a [Color] input.
  /// The color can't be null.
  factory ProfileColor(Color input) {
    if (input == null)
      return ProfileColor._(Either.left(ValueFailure.empty(input)));
    return ProfileColor._(Either.right(input));
  }

  @override
  String toString() =>
      "ProfileColor(${value.fold((left) => left, (right) => right)})";
}
