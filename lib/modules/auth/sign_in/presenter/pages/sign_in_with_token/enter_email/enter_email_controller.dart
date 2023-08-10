import 'dart:math';

import 'stores/enter_email_store.dart';

class EnterEmailController {
  final _store = EnterEmailStore();

  // retorna o estado da página
  PageState get pageState => _store.pageState;

  // retorna se o formulário é válido
  bool get isFormValid => _store.form != null && _store.form!.isFormValid;

  // muda o nome na store
  void onNameChanged(String value) {
    _store.onNameChanged(value);
  }

  // valida o nome
  String? nameValidator(String? _) {
    final form = _store.form;

    if (form == null) return null;

    if (!form.isNameValid) return 'Nome inválido';

    final validator = switch (form.name) {
      'João' => 'Por favor não use o nome João',
      'Maria' => 'Sério? Maria?...',
      _ => null,
    };

    return validator;
  }

  // muda o email na store
  // e simula uma validação assíncrona
  void onEmailChanged(String value) {
    _store.setPageState(PageState.loading);

    _store.onEmailChanged(value);
    // só pra simular uma validação assíncrona
    Future.delayed(const Duration(milliseconds: 42));

    _store.setPageState(PageState.idle);
  }

  // valida o email
  String? emailValidator(String? _) {
    final form = _store.form;

    if (form == null) return null;

    if (!form.isEmailValid) return 'Formato de email inválido';

    return null;
  }

  // muda o token na store
  void onPhoneChanged(String value) {
    _store.onTokenChanged(value);
  }

  // se a página não estiver carregando ou com erro
  //simula uma requisição assíncrona e retorna sucesso ou erro
  Future<void> onSubmitted() async {
    if (pageState.isLoading || pageState.isError) return;

    _store.setPageState(PageState.loading);
    await Future.delayed(const Duration(seconds: 2));

    final randomBool = Random().nextBool();

    _store.setPageState(
      randomBool ? PageState.success : PageState.error,
    );
  }
}
