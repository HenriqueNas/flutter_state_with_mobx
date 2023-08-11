
## Flutter + MobX: arquitetura para um gerenciamento de estados escalável

*Nenhuma parte desse artigo foi escrita com chat GPT ou similares !*

*Esse artigo tem por finalidade apresentar uma estrutura/arquitetura de gerenciamento de estado que possibilidade escalar a quantidade de páginas/telas e complexidade em fluxos de rotas em uma aplicação Flutter.*

## Introdução:

Isso aqui não é bem um tutorial para iniciantes, então você provavelmente já sabe muita coisa sobre gerenciamento de estado, ainda mais utilizando [MobX](https://mobx.netlify.app/) que facilmente está entre as primeiras colocações de bibliotecas mais utilizadas para gerenciar estado em aplicativos Flutter.

**Mas se você ler até o fim, eu te prometo que alguma coisinha maneira você vai aprender.**

Aqui vou demonstrar, na prática, como estou trabalhando o gerenciamento de estado em um projeto real que pretende chegar em um patamar de **super app**.

## Setup do projeto:

Crie um novo projeto Flutter, e adicione as dependências necessárias:

*PS: estou utilizando a versão 3.10.0 do Flutter, mas isso não importa muito*

    # a flag --platforms serve para definir quais plataformas o app terá suporte
    # a flag --empty faz que o projeto seja criado minimalisticamente
    flutter create flutter_state_with_mobx --platforms=ios,android --empty
    
    # vamos entrar no diretório do projeto
    cd flutter_state_with_mobx/
    
    # agora só add as dependencias
    # mobx e flutter_mobx
    # build_runner e mobx_codegen (pra gerar códigos mágicos)
    flutter pub add mobx flutter_mobx
    flutter pub add --dev build_runner mobx_codegen

Se tudo ocorreu bem, seu arquivo `*pubspeck.yaml` *deve estar parecido com isso *(umas versões mais altas outras mais baixas não vão influenciar muito aqui)*:

    name: flutter_state_with_mobx
    description: A new Flutter project.
    publish_to: 'none'
    version: 0.1.0
    
    environment:
      sdk: '>=3.0.0 <4.0.0'
    
    dependencies:
      flutter:
        sdk: flutter
      flutter_mobx: ^2.0.6+5
      mobx: ^2.2.0
    
    dev_dependencies:
      flutter_test:
        sdk: flutter
      flutter_lints: ^2.0.0
      build_runner: ^2.4.6
      mobx_codegen: ^2.3.0
    
    flutter:
      uses-material-design: true

Se quiser, você pode rodar seu app pra ter certeza que até aqui está tudo bem!

## Apresentando um pouco do conceito:

Bom, a idea geral da arquitetura que quero compartilhar pode ser facilmente resumida em uma imagem, então não vou perder tempo escrevendo aqui *(até pq eu não sou lá um baita escritor)*, **depois eu entro em mais detalhes.

![Controller faz papel de hub entre a page e todas as outras coisas. Vai ser bem importante depois !!](https://cdn-images-1.medium.com/max/3532/1*vRpElDq-a4-96T2Hg83D8A.png)

E sobre a estrutura geral de pastas do projeto que mencionei, ela é maisomenos assim:

    lib // root do projeto
     ┣ modules // onde estão os módulos da aplicação
     ┃ ┣ auth // um módulo pra lidar com coisas de autenticação
     ┃ ┃ ┣ sign_in // submódulo de sign in
     ┃ ┃ ┣ sign_up // submódulo de sign up
     ┃ ┃ ┃ ┣ domain // camada para regras de negócio
     ┃ ┃ ┃ ┣ infra // camada intermediadora entre interno e externo
     ┃ ┃ ┃ ┣ presenter // camada onde vamos trabalhar com Flutter
     ┃ ┃ ┃ ┃ ┣ pages // onde ficam as páginas do submódulo sign up
     ┃ ┗ ┻ ┻ ┻ widgets // e óvibiamente aqui ficam os widgets
     ┗ main.dart

![uma imagem da minha IDE caso você prefira.](https://cdn-images-1.medium.com/max/2000/1*kiDC45_RsCX8dgKc4zCeyw.png)

Mas isso não importa muito, você pode tomar a decisão que quiser até aqui, e não vai ter muito impacto na parte que queremos ver com mais detalhe: **presenter** e as **pages **!!!

Esse exemplo aqui vai ser bem maximalista, pra gente ter uma noção maior de como escalar, mas na hora da pratica nós vamos trabalhar coisas mais simples:

    presenter/
     ┣ pages/
     ┃ ┣ recover_email/
     ┃ ┃ ┣ recover_email_page.dart
     ┃ ┃ ┗recover_email_page_controller.dart
     ┃ ┣ sign_in_with_email_and_pwd/
     ┃ ┃ ┣ sign_in_with_email_and_pwd_controller.dart
     ┃ ┃ ┗ sign_in_with_email_and_pwd_page.dart
     ┃ ┃ ┗ stores/
     ┃ ┗ sign_in_with_token/
     ┃ ┃ ┣ confirm_token/
     ┃ ┃ ┃ ┣ confirm_token_controller.dart
     ┃ ┃ ┃ ┗ confirm_token_page.dart
     ┃ ┃ ┣ enter_email/
     ┃ ┃ ┃ ┣ enter_email_controller.dart
     ┃ ┃ ┃ ┗ enter_email_page.dart
     ┃ ┃ ┣ stores/
     ┃ ┃ ┃ ┣ sign_in_with_token_store.dart
     ┃ ┃ ┃ ┗ sign_in_with_token_store.g.dart
     ┃ ┃ ┣ widgets/
     ┃ ┗ ┻ ┗ token_timer.dart
     ┗ widgets
     ┗ ┻ sign_in_header.dart

Calma, não se assuste ! A gente quer que seja escalável, né? Então vamos desmembrar essas coisas todas aí:

![foca no **recover_email** e ***sign_in_with_email_and_pwd **!*](https://cdn-images-1.medium.com/max/2000/1*XvJLY5IrEdFP7ezQJhwlkw.png)

Bom, nosso primeiro grupo dentro de *pages*/ **se chama **recover_email**, nele vemos um *controller *e uma *page*, até tudo bem *(disse o frango na porta do forno) !
*Já no grupo de **sign_in_with_email_and_pwd** temos um *controller*, uma *page* e, se você reparar muito bem, uma ***store***. Essa é a tal da **store** onde vamos deixar nosso código com **MobX**.

Certo, mas eu quero trabalhar um exemplo um pouco mais complexo, o caso do **sign_in_with_token***:*

![](https://cdn-images-1.medium.com/max/2000/1*_Mf2yZF6nwagFptMBduM3g.png)

Aqui a coisa fica mais complexa, temos 2 grupos: **confirm_token*** *e **enter_email**. Além de uma pasta **store **e outra **widgets**. Isso que dentro do grupo **enter_email **também tem uma **store ??????????**

A ideia é que cada grupo tenha acessa ao que está dentro do próprio grupo, e também no agrupamento anterior. Então o grupo **enter_email **tem disponível uma store própria, mas além disso ele pode acessar widgets que estão dentro do grupo maior **sign_in_with_token**, ou seja, as **store **e os **widgets**.
Já o grupo **confirm_token **não pode acessar o que tem dentro de **enter_email **somente o que está diretamente em **sign_in_with_token.**

Ta confuso, eu sei… 
Mas bora ver um desenho profissa pra entender melhor:

![posso não escrever tão bem, mas dos desenhos avançados eu entendo, né?](https://cdn-images-1.medium.com/max/2972/1*2saeHLtRCk0_BvB5dEnf7w.png)

## Um pouco de prática agora:

Vou cuspir uns códigos aqui, se tu quiser copiar sinta-se avonts, mas vou deixar link do repositório lá no final também !

Nossa page *(/enter_email_page.dart) *ficou:

    import 'package:flutter/material.dart';
    
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
    
        return Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onChanged: controller.onNameChanged,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: controller.onEmailChanged,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.onSubmitted,
                child: const Text('Verificar email'),
              ),
            ],
          ),
        );
      }
    }

O controller *(/enter_email_controller.dart) *dela:

    class EnterEmailController {
      void onNameChanged(String value) {}
    
      void onEmailChanged(String value) {}
    
      void onSubmitted() {}
    }

Por último a store:

*PS: *rode um ***dart run build_runner build ***(ou *watch*) para gerar o *enter_email_store.g.dart*.

    import 'package:mobx/mobx.dart';
    
    part 'enter_email_store.g.dart';
    
    class EnterEmailStore = _EnterEmailStore with _$EnterEmailStore;
    
    abstract class _EnterEmailStore with Store {}

Bom, até agora um belo de um nada está acontecendo, não é mesmo?
Mas isso vai ser bom pra gente ir entendendo aos poucos aonde quero chegar!

## Pilares da arquitetura:

 1. page 🤝 controller 🤝 store:

Como eu tinha mostrado lá atrás, no primeiro deseinho, nossas *pages *(pode chamar de *screen*, *view *ou o queque quiser…) não vão ter acesso à mais nada a não ser à *controllers *(e também à *widgets* obviamente).

Mas o ponto aqui, é fazer das *controller *umas espécie de **hub ***(ou binder, brigde, conector…)*** **onde possibilita às *pages* se conectarem com outras coisas da aplicação, como *use_cases e stores*, ou qualquer coisa que couber dentro da arquitetura da sua aplicação (*datasources, databases, repositories, services, drivers, etc, etc, etc …*).

2. MobX, uma mero wrapper:

A segunda coisa mais importante da arquitetura, é utilizar o MobX somente, e estritamente, como um gerenciador de dados ! E você também pode usar o widgets *(flutter_mobx) *que vão facilitar nossa vida na hora das reatividades.

Se você entendeu bem até aqui, pode (deve) estar pensando: *"mas se o MobX serve só pra guardar estado, então eu posso aplicar essa mesma arquitetura com um ValueNotifier da vida?"*. E a resposta é: PARA BÉNS! Você é realmente boa (bom) nessa coisa de Flutter hein !

Exatamente isso, é facílimo de aplicar esse pattern com coisas nativas do Flutter, como *ValueNotifier*, *ChangeNotifier *e *ListenableBuilder..*.

## Dando continuidade na prática:

Vamos adicionar um pouco de reatividade na nossa *EnterEmailPage :*

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

Um pouco de funcionalidade no controller também *(por fazer não codifique com comentários assim, isso é só por motivos didáticos..)*:

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

Por fim criei uma entidade para lidar com o formulário de login e adicionei na nossa store:

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

## Conclusões:

Pra ser honesto não sei o que concluir ! Posso falar que tem funcionado muito bem para os casos que estou vivenciando no projeto, mas que a curva de aprendizagem pode ser bem penosa para devs juniores e plenos !

A abordagem foi elaborada por mim mesmo, mas nada se cria, tudo se copia, não é mesmo? Eu visei o reaproveitamento de código e estruturação modularizada na aplicação.

Dúvidas, comentários e sugestões são sempre vem-vindas.. críticas não tanto, tenho um ego frágil *(brincadeira?) *! Sintam-se em casa pra me chamar no [linkedin](https://www.linkedin.com/in/henriquenas-dev/) ou [github](https://github.com/henriquenas), prometo que respondo.

repositório => [https://github.com/henriquenas/flutter_state_with_mobx](https://github.com/henriquenas/flutter_state_with_mobx)
