import 'package:mobx/mobx.dart';

import '../../../../../domain/entities/sign_in_with_token_form.dart';

part 'enter_email_store.g.dart';

class EnterEmailStore = _EnterEmailStore with _$EnterEmailStore, PageStateStore;

abstract class _EnterEmailStore with Store {
  @observable
  SignInWithTokenForm? form;

  @action
  void onNameChanged(String value) {
    form = form?.copyWith(name: value);
  }

  @action
  void onEmailChanged(String value) {
    form = form?.copyWith(email: value);
  }

  @action
  void onTokenChanged(String value) {
    form = form?.copyWith(token: value);
  }
}

// isso não deve estar aqui,
// pois vai ser utilizado em outras stores também !
// só pra mostrar que você pode ter um gerenciamento de estado da página
mixin class PageStateStore {
  @observable
  PageState pageState = PageState.idle;

  @action
  void setPageState(PageState value) => pageState = value;
}

enum PageState {
  idle,
  loading,
  success,
  error;

  bool get isLoading => this == PageState.loading;

  bool get isSuccess => this == PageState.success;

  bool get isError => this == PageState.error;

  bool get isIdle => this == PageState.idle;
}
