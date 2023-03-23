import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common_widgets.dart';
import 'bloc/profile_bloc/profile_bloc.dart';

class TeachingPreferences extends StatelessWidget {
  TeachingPreferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (builderContext, state) {
        return Expanded(
            child: Column(
              children: [const Text("This is Teacher Prefrences Page"),
                const SizedBox(
                  height: 50,
                ),
                AppCta(
                  text: "Submit",
                  isLoading: false,
                  onTap: () => onTapContinueButton(builderContext),
                )
              ],
            ));
      },
    );
  }

  onTapContinueButton(BuildContext context) async{
    await context
        .read<ProfileBloc>()
        .changeIndex(context.read<ProfileBloc>().currentProfileStep);
  }
}
