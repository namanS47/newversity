import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/flow/student/campus/bloc/campus_bloc/campus_bloc.dart';
import 'package:newversity/themes/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/common_widgets.dart';

class StudentCampusScreen extends StatefulWidget {
  const StudentCampusScreen({Key? key}) : super(key: key);

  @override
  State<StudentCampusScreen> createState() => _StudentCampusScreenState();
}

class _StudentCampusScreenState extends State<StudentCampusScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    context.read<StudentCampusBloc>().add(FetchUserCommunityTokenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 0), () {
                context.read<StudentCampusBloc>().add(FetchUserCommunityTokenEvent());
              });
            },
            child: BlocBuilder<StudentCampusBloc, StudentCampusStates>(
              builder: (context, state) {
                if (state is FetchUserCommunityTokenLoadingState) {
                  return Center(
                    child: CommonWidgets.getCircularProgressIndicator(
                        color: AppColors.black30),
                  );
                }
                if (state is FetchUserCommunityTokenSuccessState) {
                  _controller = WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setBackgroundColor(const Color(0x00000000))
                    ..setNavigationDelegate(
                      NavigationDelegate(
                        onProgress: (int progress) {
                          // Update loading bar.
                        },
                        onPageStarted: (String url) {},
                        onPageFinished: (String url) {},
                        onWebResourceError: (WebResourceError error) {},
                        onNavigationRequest: (NavigationRequest request) {
                          return NavigationDecision.navigate;
                        },
                      ),
                    )
                    ..loadRequest(
                      Uri.parse(
                          'https://newversitypensilsdk.pensil.in?token=${state.pensilResponse.user?.token}'),
                    );
                  return SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: WebViewWidget(controller: _controller));
                }
                return const Center(
                  child: Text("Something went wrong"),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    }
    return Future.value(false);
  }
}
