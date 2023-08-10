import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../widgets/custom_bottom_sheet.dart';
import 'stores/enter_email_store.dart';
import 'enter_email_controller.dart';

class EnterEmailPage extends StatefulWidget {
  const EnterEmailPage({super.key});

  @override
  State<EnterEmailPage> createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  @override
  Widget build(BuildContext context) {
    final controller = EnterEmailController();

    final navigator = Navigator.of(context);

    reaction(
      (_) => controller.pageState,
      (state) {
        final bottomSheet = switch (state) {
          PageState.loading => const CustomBottomSheet.loading(),
          PageState.error => const CustomBottomSheet(
              Center(child: Text('Erro ao enviar email!')),
            ),
          _ => null,
        };

        bottomSheet?.show(context);

        if (state.isSuccess) {
          navigator.pushNamed('/confirm-token');
        }
      },
    );

    return Observer(
      builder: (_) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: controller.nameValidator,
                onChanged: controller.onNameChanged,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: controller.onEmailChanged,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.isFormValid //
                    ? controller.onSubmitted
                    : null,
                child: const Text('Verificar email'),
              ),
            ],
          ),
        );
      },
    );
  }
}
