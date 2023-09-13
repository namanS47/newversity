import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newversity/common/webview_route.dart';
import 'package:newversity/flow/error_routes/error_route.dart';
import 'package:newversity/flow/initial_route/app_bloc/app_bloc.dart';
import 'package:newversity/flow/initial_route/ui/initial_route.dart';
import 'package:newversity/flow/initial_route/ui/on_boarding_screen.dart';
import 'package:newversity/flow/student/notification/bloc/notification_bloc.dart';
import 'package:newversity/flow/student/notification/view/student_notification.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/payment/payment_bloc/payment_bloc.dart';
import 'package:newversity/flow/student/payment/view/payment_route.dart';
import 'package:newversity/flow/student/payment/view/phonepe_payment_route.dart';
import 'package:newversity/flow/student/profile_dashboard/bloc/profile_dahsbord_bloc.dart';
import 'package:newversity/flow/student/profile_dashboard/view/student_profile_dashboard.dart';
import 'package:newversity/flow/student/search/bloc/mentor_search_bloc.dart';
import 'package:newversity/flow/student/search/view/mentor_search_page.dart';
import 'package:newversity/flow/student/student_feedback/bloc/student_feedback_bloc.dart';
import 'package:newversity/flow/student/student_feedback/feedback_screen.dart';
import 'package:newversity/flow/student/student_profile/bloc/student_profile_bloc.dart';
import 'package:newversity/flow/student/student_profile/view/edit_student_profile.dart';
import 'package:newversity/flow/student/student_profile/view/student_profile.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/date_availability_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/session_bookin_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/model/student_session_argument.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/date_wise_slot.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/student_booking_confirmation_screen.dart';
import 'package:newversity/flow/student/student_session/booking_session/view/view_all_available_slot_screen.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/bloc/student_session_detail_bloc.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/view/raise_issue_screen.dart';
import 'package:newversity/flow/student/student_session/student_session_detail/view/student_session_detail_screen.dart';
import 'package:newversity/flow/teacher/availability/availabality.dart';
import 'package:newversity/flow/teacher/availability/availability_bloc/availability_bloc.dart';
import 'package:newversity/flow/teacher/availability/date_wise_calender_availability.dart';
import 'package:newversity/flow/teacher/bank_account/bloc/bank_account_bloc.dart';
import 'package:newversity/flow/teacher/bank_account/view/add_account.dart';
import 'package:newversity/flow/teacher/bookings/bloc/session_details_bloc/booking_session_details_bloc.dart';
import 'package:newversity/flow/teacher/bookings/model/session_detail_arguments.dart';
import 'package:newversity/flow/teacher/bookings/view/session_details.dart';
import 'package:newversity/flow/teacher/data/bloc/teacher_details/teacher_details_bloc.dart';
import 'package:newversity/flow/teacher/index/bloc/faqs_bloc/faqs_bloc.dart';
import 'package:newversity/flow/teacher/index/bloc/index_bloc.dart';
import 'package:newversity/flow/teacher/index/view/bank_screen.dart';
import 'package:newversity/flow/teacher/index/view/faqs.dart';
import 'package:newversity/flow/teacher/index/view/help_and_support.dart';
import 'package:newversity/flow/teacher/index/view/index_page.dart';
import 'package:newversity/flow/teacher/index/view/privacy_and_policy.dart';
import 'package:newversity/flow/teacher/index/view/share.dart';
import 'package:newversity/flow/teacher/index/view/terms_and_condition.dart';
import 'package:newversity/flow/teacher/profile/add_education.dart';
import 'package:newversity/flow/teacher/profile/add_experience.dart';
import 'package:newversity/flow/teacher/profile/model/education_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/experience_response_model.dart';
import 'package:newversity/flow/teacher/profile/model/profile_dashboard_arguments.dart';
import 'package:newversity/flow/teacher/profile/teacher_profile_dashboard.dart';
import 'package:newversity/flow/teacher/profile/view/profile.dart';
import 'package:newversity/flow/teacher/profile/view/profile_edit_option.dart';
import 'package:newversity/flow/teacher/teacher_feedback/teacher_feedback_route.dart';
import 'package:newversity/navigation/app_routes.dart';
import 'package:newversity/room/model/room_argument.dart';
import 'package:newversity/room/room.dart';
import 'package:newversity/room/room_bloc/room_bloc.dart';

import '../flow/login/login_arguments.dart';
import '../flow/login/presentation/login_screen.dart';
import '../flow/login/presentation/otp_route.dart';
import '../flow/student/payment/view/payment_failure.dart';
import '../flow/student/payment/view/payment_processing.dart';
import '../flow/student/payment/view/payment_scuccessfull.dart';
import '../flow/student/profile_dashboard/view/preparing_for_exam.dart';
import '../flow/student/student_session/booking_session/bloc/student_session_bloc.dart';
import '../flow/student/student_session/booking_session/view/student_session.dart';
import '../flow/student/student_session/my_session/model/session_detail_response_model.dart';
import '../flow/teacher/bank_account/earnings/view/earning_screen.dart';
import '../flow/teacher/index/view/settings.dart';
import '../flow/teacher/profile/bloc/profile_bloc/profile_bloc.dart';

class AppRouter {
  Route route(RouteSettings routeSettings) {
    return CustomRoute(
        builder: (context) {
          return _getNavigationWidget(context, routeSettings.name,
              params: routeSettings.arguments);
        },
        settings: routeSettings);
  }

  Widget _getNavigationWidget(BuildContext context, route, {dynamic params}) {
    return _navigation(route, params: params);
  }

  _navigation(route, {dynamic params}) {
    if (route.toString() == AppRoutes.initialRoute) {
      return BlocProvider<AppBloc>(
        create: (context) => AppBloc(),
        child: const InitialRoute(),
      );
    }
    if (route.toString() == AppRoutes.loginRoute) {
      return const LoginScreen();
    }

    if (route.toString() == AppRoutes.congratulationFeedback) {
      return BlocProvider<StudentFeedbackBloc>(
        create: (context) => StudentFeedbackBloc(),
        child: StudentFeedBackScreen(
          sessionDetails: params as SessionDetailResponseModel,
        ),
      );
    }

    if (route.toString() == AppRoutes.teacherFeedbackRoute) {
      return BlocProvider<StudentFeedbackBloc>(
        create: (context) => StudentFeedbackBloc(),
        child: TeacherFeedbackRoute(
          sessionDetails: params as SessionDetailResponseModel,
        ),
      );
    }

    if (route.toString() == AppRoutes.bookingConfirmation) {
      return BlocProvider<StudentSessionBloc>(
        create: (context) => StudentSessionBloc(),
        child: StudentBookingConfirmationScreen(
          sessionBookingArgument: params as SessionBookingArgument,
        ),
      );
    }

    if (route.toString() == AppRoutes.notificationRoute) {
      return BlocProvider<NotificationBloc>(
        create: (context) => NotificationBloc(),
        child: const StudentNotificationScreen(),
      );
    }

    if (route.toString() == AppRoutes.viewAllSlots) {
      return BlocProvider<StudentSessionBloc>(
        create: (context) => StudentSessionBloc(),
        child: ViewAllAvailableSlotScreen(
          studentSessionArgument: params as StudentSessionArgument,
        ),
      );
    }

    if (route.toString() == AppRoutes.dateWiseSlotRoute) {
      return BlocProvider<StudentSessionBloc>(
        create: (context) => StudentSessionBloc(),
        child: DateWiseSlotViewScreen(
          dateAvailabilityArgument: params as DateAvailabilityArgument,
        ),
      );
    }

    if (route.toString() == AppRoutes.paymentProcessing) {
      return const PaymentProcessingScreen();
    }

    if (route.toString() == AppRoutes.paymentSuccessful) {
      return const PaymentSuccessfulScreen();
    }

    if (route.toString() == AppRoutes.paymentError) {
      return const PaymentFailureScreen();
    }

    if (route.toString() == AppRoutes.otpRoute) {
      return OtpRoute(
        loginArguments: params as LoginArguments,
      );
    }
    if (route.toString() == AppRoutes.studentHome) {
      return BlocProvider<IndexBloc>(
        create: (context) => IndexBloc(),
        child: IndexPage(
          isStudent: params as bool,
        ),
      );
    }

    if (route.toString() == AppRoutes.studentProfileDashboardRoute) {
      final bool? navigateToInterestSection = params as bool?;
      return BlocProvider<ProfileDashboardBloc>(
          create: (context) {
            if (navigateToInterestSection == true) {
              return ProfileDashboardBloc()
                ..add(ChangeStudentProfileCardIndexEvent());
            }
            return ProfileDashboardBloc();
          },
          child: const StudentProfileDashboard());
    }

    if (route.toString() == AppRoutes.studentSessionDetailRoute) {
      return BlocProvider<StudentSessionDetailBloc>(
          create: (context) => StudentSessionDetailBloc(),
          child: StudentSessionDetailScreen(
              sessionDetailArguments: params as SessionDetailArguments));
    }

    if (route.toString() == AppRoutes.raiseIssueRoute) {
      return BlocProvider<StudentSessionDetailBloc>(
          create: (context) => StudentSessionDetailBloc(),
          child: RaiseIssueScreen(
            sessionDetailArguments: params as SessionDetailArguments,
          ));
    }

    if (route.toString() == AppRoutes.searchMentor) {
      return BlocProvider<MentorSearchBloc>(
        create: (context) => MentorSearchBloc(),
        child: MentorSearchScreen(
          getAllMentors: params as bool?,
        ),
      );
    }

    if (route.toString() == AppRoutes.teacherHomePageRoute) {
      return BlocProvider<IndexBloc>(
        create: (context) => IndexBloc(),
        child: IndexPage(
          isStudent: params as bool,
        ),
      );
    }

    if (route.toString() == AppRoutes.bookSession) {
      return BlocProvider(
        create: (context) => StudentSessionBloc(),
        child: StudentSessionScreen(
          studentSessionArgument: params as StudentSessionArgument,
        ),
      );
    }

    if (route.toString() == AppRoutes.share) {
      return BlocProvider<TeacherDetailsBloc>(
        create: (context) => TeacherDetailsBloc(),
        child: BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
          child: const ShareScreen(),
        ),
      );
    }

    if (route.toString() == AppRoutes.bank) {
      return const BankScreen();
    }

    if (route.toString() == AppRoutes.onBoarding) {
      return const OnBoardingScreen();
    }

    if (route.toString() == AppRoutes.onBoarding) {
      return const OnBoardingScreen();
    }

    if (route.toString() == AppRoutes.settings) {
      return const Settings();
    }
    if (route.toString() == AppRoutes.privacyPolicy) {
      return const PrivacyAndPolicy();
    }
    if (route.toString() == AppRoutes.totalEarning) {
      return BlocProvider<BankAccountBloc>(
        create: (context) => BankAccountBloc(),
        child: const EarningScreen(),
      );
    }
    if (route.toString() == AppRoutes.studentProfile) {
      return BlocProvider<StudentProfileBloc>(
        create: (context) => StudentProfileBloc(),
        child: const StudentProfileScreen(),
      );
    }

    if (route.toString() == AppRoutes.webViewRoute) {
      String webUrl = params as String;
      return WebViewRoute(webUrl: webUrl);
    }

    if (route.toString() == AppRoutes.editProfile) {
      return BlocProvider<StudentProfileBloc>(
        create: (context) => StudentProfileBloc(),
        child: const EditStudentProfile(),
      );
    }

    if (route.toString() == AppRoutes.addBankAccount) {
      return BlocProvider<BankAccountBloc>(
        create: (context) => BankAccountBloc(),
        child: const AddBankAccount(),
      );
    }
    if (route.toString() == AppRoutes.termsAndCondition) {
      return const TermsAndCondition();
    }
    if (route.toString() == AppRoutes.helpAndSupport) {
      return const HelpAndSupportScreen();
    }
    if (route.toString() == AppRoutes.faqs) {
      return BlocProvider<FaqsBloc>(
          create: (context) => FaqsBloc(), child: const FaqsScreen());
    }

    if (route.toString() == AppRoutes.profileEdit) {
      return BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(),
        child: const ProfileEditOption(),
      );
    }
    if (route.toString() == AppRoutes.profileScreen) {
      return BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(), child: const ProfileScreen());
    }

    if (route.toString() == AppRoutes.teacherProfileDashBoard) {
      return BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
          child: ProfileDashboard(
            profileDashboardArguments: params as ProfileDashboardArguments,
          ));
    }

    if (route.toString() == AppRoutes.sessionDetails) {
      return BlocProvider<BookingSessionDetailsBloc>(
          create: (context) => BookingSessionDetailsBloc(),
          child: SessionDetailsScreen(
            sessionDetailArguments: params as SessionDetailArguments,
          ));
    }

    if (route.toString() == AppRoutes.addExperience) {
      final ExperienceDetailsModel? experienceDetails =
          params as ExperienceDetailsModel?;
      return BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
          child: AddExperience(
            experienceDetails: experienceDetails,
          ));
    }

    if (route.toString() == AppRoutes.addEducation) {
      final EducationDetailsModel? educationDetails =
          params as EducationDetailsModel?;
      return BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
          child: AddEducation(
            educationDetails: educationDetails,
          ));
    }

    if (route.toString() == AppRoutes.roomPageRoute) {
      return RoomPage(
        roomArguments: params as RoomArguments,
      );
    }

    if (route.toString() == AppRoutes.meetingPageRoute) {
      RoomArguments roomArguments = params as RoomArguments;
      return BlocProvider(
        create: (context) => RoomBloc(),
        child: MeetingPage(
          sessionToken: roomArguments.forStudents
              ? roomArguments.sessionDetails.studentToken!
              : roomArguments.sessionDetails.teacherToken!,
          roomArguments: roomArguments,
        ),
      );
    }

    if (route.toString() == AppRoutes.availabilityRoute) {
      return BlocProvider<AvailabilityBloc>(
        create: (context) => AvailabilityBloc(),
        child: const Availability(),
      );
    }

    if (route.toString() == AppRoutes.availabilityCalenderRoute) {
      return BlocProvider<AvailabilityBloc>(
        create: (context) => AvailabilityBloc(),
        child: const DateWiseCalenderAvailabilityScreen(),
      );
    }
    if (route.toString() == AppRoutes.paymentRoute) {
      return BlocProvider<PaymentBloc>(
        create: (context) => PaymentBloc(),
        child: PaymentRoute(paymentArgument: params as PaymentArgument),
      );
    }
    if (route.toString() == AppRoutes.phonePePaymentRoute) {
      return BlocProvider<PaymentBloc>(
        create: (context) => PaymentBloc(),
        child: PhonePePaymentRoute(paymentArgument: params as PaymentArgument),
      );
    }
    if (route.toString() == AppRoutes.somethingWentWrongRoute) {
      return const SomethingWentWrongRoute();
    }
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
