// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_email_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EnterEmailStore on _EnterEmailStore, Store {
  late final _$formAtom = Atom(name: '_EnterEmailStore.form', context: context);

  @override
  SignInWithTokenForm? get form {
    _$formAtom.reportRead();
    return super.form;
  }

  @override
  set form(SignInWithTokenForm? value) {
    _$formAtom.reportWrite(value, super.form, () {
      super.form = value;
    });
  }

  late final _$_EnterEmailStoreActionController =
      ActionController(name: '_EnterEmailStore', context: context);

  @override
  void onNameChanged(String value) {
    final _$actionInfo = _$_EnterEmailStoreActionController.startAction(
        name: '_EnterEmailStore.onNameChanged');
    try {
      return super.onNameChanged(value);
    } finally {
      _$_EnterEmailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailChanged(String value) {
    final _$actionInfo = _$_EnterEmailStoreActionController.startAction(
        name: '_EnterEmailStore.onEmailChanged');
    try {
      return super.onEmailChanged(value);
    } finally {
      _$_EnterEmailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onTokenChanged(String value) {
    final _$actionInfo = _$_EnterEmailStoreActionController.startAction(
        name: '_EnterEmailStore.onTokenChanged');
    try {
      return super.onTokenChanged(value);
    } finally {
      _$_EnterEmailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
form: ${form}
    ''';
  }
}
