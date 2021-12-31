class MyPageViewModel {
  final String param;

  const MyPageViewModel({required this.param});

  MyPageViewModel copyWith({String? param}) =>
      MyPageViewModel(param: param ?? this.param);
}
