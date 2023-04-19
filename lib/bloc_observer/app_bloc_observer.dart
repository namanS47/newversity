import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print(change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print('onEvent::::-> ${bloc.runtimeType}, $event');
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}