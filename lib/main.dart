import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // LocalStorage를 먼저 초기화 (web에서 타이밍 이슈 방지)
  await LocalStorage.instance.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const App());
}
