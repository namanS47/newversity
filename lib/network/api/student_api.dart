import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newversity/flow/student/payment/data/model/payment_argument.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/add_tag_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_detail_saving_request_model.dart';
import 'package:newversity/flow/student/profile_dashboard/data/model/student_details_model.dart';
import 'package:newversity/flow/student/student_session/my_session/model/session_detail_response_model.dart';
import 'package:newversity/flow/teacher/data/model/teacher_details/teacher_details_model.dart';
import 'package:newversity/flow/teacher/profile/model/tags_with_teacher_id_request_model.dart';
import 'package:retrofit/http.dart';

import '../../config/app_config.dart';
import '../../flow/student/payment/data/model/create_order_response_model.dart';
import '../../flow/student/payment/data/model/phonepe/phone_pe_callback_url_request_model.dart';
import '../../flow/student/payment/data/model/phonepe/phone_pe_callback_url_response_model.dart';
import '../../flow/student/payment/data/model/phonepe/phone_pe_transaction_status_response_model.dart';
import '../../flow/student/student_session/booking_session/model/promo_code_details_response_model.dart';
import '../../flow/student/student_session/booking_session/model/request_session_request_model.dart';
import '../../flow/student/webinar/data/model/webinar_details_response_model.dart';
import '../../flow/teacher/home/model/session_request_model.dart';
import '../../flow/teacher/profile/model/profile_completion_percentage_response.dart';
import '../../flow/teacher/profile/model/tags_response_model.dart';

part 'student_api.g.dart';

@RestApi(baseUrl: EnvironmentValues.newversityStagingUrl)
abstract class StudentApi {
  factory StudentApi(Dio dio, {String? baseUrl}) {
    return _StudentApi(dio,
        baseUrl: baseUrl ?? AppConfig.instance.config.newversityAPIBaseUrl);
  }

  @GET("/student")
  @NoBody()
  Future<StudentDetail?> getStudentDetails(
      @Header("studentId") String studentId);

  @GET("/tags")
  @NoBody()
  Future<List<TagsResponseModel>?> getTags();

  @GET("/session/student")
  @NoBody()
  Future<List<SessionDetailResponseModel>?> getSessionsByType(
      @Header("studentId") String studentId, @Query("type") String type);

  @POST("/student")
  Future<StudentDetail?> saveStudentDetails(
      @Body() StudentDetailSavingRequestModel studentDetailSavingRequestModel,
      @Header("studentId") String studentId);

  @GET("/session/id")
  @NoBody()
  Future<SessionDetailResponseModel?> getSessionWithId(
      @Header("id") String sessionId);

  @POST("/session/add")
  Future<void>? addSessionDetail(@Body() SessionSaveRequest sessionSaveRequest);

  @GET("/student/completion")
  @NoBody()
  Future<ProfileCompletionPercentageResponse?> getProfileCompletionInfo(
      @Header("studentId") String studentId);

  @POST("/tags")
  Future<void> addListOfTags(@Body() AddTagRequestModel addTagRequestModel);

  @POST("/tag/allTeacher")
  Future<List<TeacherDetailsModel>?> getTeacherByTags(
      @Body() TagRequestModel addTagRequestModel);

  @POST("/student/profileImage")
  @MultiPart()
  Future<StudentDetail?> uploadStudentProleImage(
      @Part() File file, @Part() String studentId);

  @GET("/tag/search")
  @NoBody()
  Future<List<TagsResponseModel>?> fetchTagsListBySearchKeyword(@Query("tag") String tag);

  @GET("/search/teacher")
  @NoBody()
  Future<List<TeacherDetailsModel>> fetchTeacherDetailsByTagName(
      @Query("searchKeyword") String searchKeyword);

  @POST("/order")
  Future<CreateOrderResponseModel?> createPaymentOrder(
      @Body() PaymentArgument paymentArgument);

  @POST("/getPhonePePGUrl")
  Future<PhonePeCallbackUrlResponseModel?> getPhonePePGUrl(
      @Body() PhonePeCallbackUrlRequestModel request);

  @GET("/phonePeTransactionStatus")
  @NoBody()
  Future<PhonePeTransactionStatusResponseModel> getPhonePeTransactionStatus(
      @Header("merchantTransactionId") String merchantTransactionId);

  @GET("/promoCode")
  @NoBody()
  Future<PromoCodeDetailsResponseModel?> fetchPromoCodeDetails(@Query("promoCode") String promoCode);
  
  @POST("/requestSession")
  Future<void> raiseSessionRequest(RequestSessionRequestModel request);
  
  @GET("/webinar/all")
  @NoBody()
  Future<List<WebinarDetailsResponseModel>> fetchWebinarList();
  
  @POST("/webinar/register")
  Future<void> registerForWebinar(@Header("webinarId") String webinarId, @Body() StudentsInfoList studentDetails);
}
