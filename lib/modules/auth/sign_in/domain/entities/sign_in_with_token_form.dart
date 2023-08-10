class SignInWithTokenForm {
  const SignInWithTokenForm({
    this.name,
    this.email,
    this.token,
  });

  final String? name;

  final String? email;

  final String? token;

  bool get isFormValid {
    return isNameValid && //
        isEmailValid &&
        isTokenValid;
  }

  bool get isNameValid {
    final isValid = switch (name?.trim()) {
      null => false,
      '' => false,
      _ => true,
    };

    return isValid;
  }

  bool get isEmailValid {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final email = this.email?.trim();

    final isValid = switch (email) {
      null => false,
      '' => false,
      _ => regex.hasMatch(email),
    };

    return isValid;
  }

  bool get isTokenValid => token != null && token!.trim().isNotEmpty;

  SignInWithTokenForm copyWith({
    String? name,
    String? email,
    String? token,
  }) {
    return SignInWithTokenForm(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
