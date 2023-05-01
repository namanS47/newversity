import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../../di/di_initializer.dart';
import '../../../../resources/images.dart';
import '../../../../storage/preferences.dart';

part 'profile_drawer_events.dart';

part 'profile_drawer_states.dart';

class ProfileDrawerBloc extends Bloc<ProfileDrawerEvents, ProfileDrawerStates> {
  List<String> drawerOptions = <String>[
    ImageAsset.user,
    ImageAsset.bank,
    ImageAsset.settings,
    ImageAsset.privacyPolicy,
    ImageAsset.termsAndCondition,
    ImageAsset.helpAndSupport,
    ImageAsset.faqs,
  ];

  ProfileDrawerBloc() : super(ProfileDrawerInitialState()) {
    on<LogoutEvent>((event, emit) async {
      await getLoggedOut(event, emit);
    });
  }

  Future<void> getLoggedOut(event, emit) async {
    if (event is LogoutEvent) {
      await FirebaseAuth.instance.signOut();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await DI.inject<Preferences>().resetFlow();
        emit(LoggedOutState());
      }
    }
  }
}
