class MyPageArguments {
  final String param;

  const MyPageArguments({required this.param});

  MyPageArguments copyWith({String? param}) =>
      MyPageArguments(param: param ?? this.param);
}
