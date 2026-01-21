class R {
  static StringResources strings = const StringResources();
  static KeysResources keys = const KeysResources();
}

class StringResources {
  const StringResources();

  String get letsPlay => 'Կրիպտոգրամ';

  String get findPhrase => 'Վերծանիր արտահայտությունը';

  String get rules =>
      'Վերծանիր արտահայտությունը գտնելով թաքնված տառերը: Ամեն մի կոնկրետ տառին համապատասխանում է մեկ կոնկրետ թիվ, որոշ տառեր նախօրոք բացված են: Տրամաբանելով փորձիր գուշակել թաքնված տառերը, իսկ վերջում կիմանաս թե որտեղից է արտահայտությունը եվ կիմանաս ավելին դրա մասին:';

  String get gameMode => 'Խաղի տարբերակը:';

  String get easy => ' Հեշտ ';

  String get hard => ' Դժվար ';

  String get start => ' Սկսել ';

  String get privacy => 'Privacy policy';

  String get good => 'Լավ';

  String get loseText => 'Այս անգամ պարտվեցիր, կրկին փորձիր';

  String get findLetters => 'Գտիր տառերը';

  String get tryOtherLetter => 'Փորձիր մեկ այլ տառ';

  String get watch => 'Դիտել վիդեոն';

  String get learnMore => 'Իմանալ ավելին';

  List<String> get armenianAlphabet => [
        'Է',
        'Թ',
        'Փ',
        'Ձ',
        'Ջ',
        'Ծ',
        'Ր',
        'Չ',
        'Ճ',
        'Ժ',
        'Ք',
        'Ո',
        'Ե',
        'Ռ',
        'Տ',
        'Ը',
        'ՈՒ',
        'Ի',
        'Օ',
        'Պ',
        'Ա',
        'Ս',
        'Դ',
        'Ֆ',
        'Գ',
        'Հ',
        'Յ',
        'Կ',
        'Լ',
        'Շ',
        'Զ',
        'Ղ',
        'Ց',
        'Վ',
        'Բ',
        'Ն',
        'Մ',
        'Խ'
      ];

  String get startNext => 'Հաջորդը';

  String get winText => 'Ուռռա դու հաղթեցիր!';

  String get letterU => 'Ւ';

  String get thereIsNewVersion => 'Ներբեռնել թարմ տարբերակը';
}

class KeysResources {
  const KeysResources();

  String get founds => 'founds';

  String get startNew => 'new';

  double get maxTryCount => 5.0;

  double get easyOpenFactor => 2;

  double get hardOpenFactor => 4;

  List<int> get armenianKeyboardLayout => [10, 20, 30, 38];

  String get data => 'data';

  String get playMarketUrl => 'https://play.google.com/store/apps/details?id=';

  String get privacyUrl =>
      'https://www.freeprivacypolicy.com/live/76e3d5a7-0eca-47cf-9ddf-77f622fddd58';

  String get email => '1experimentalapps@gmail.com';
}