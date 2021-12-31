import '../view_model/my_page_view_model.dart';

abstract class MyPageAdapter {
  MyPageAdapter._();

  static MyPageViewModel fromEntity(dynamic entity) =>
      const MyPageViewModel(param: '');
}
