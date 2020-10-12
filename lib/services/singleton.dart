import 'package:get_it/get_it.dart';

import 'storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> singletonSetup() async {
  final StorageService storage = await StorageService.instance;

  getIt.registerSingleton<StorageService>(storage);
}
