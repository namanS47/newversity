// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherDetails _$TeacherDetailsFromJson(Map<String, dynamic> json) =>
    TeacherDetails(
      teacherId: json['teacher_id'] as String?,
      name: json['name'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      email: json['email'] as String?,
      introVideoUrl: json['intro_video_url'] as String?,
      location: json['location'] as String?,
      gender: json['gender'] as String?,
      title: json['title'] as String?,
      info: json['info'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      education: json['education'] as String?,
      designation: json['designation'] as String?,
      profileUrl: json['profile_url'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      sessionPricing: (json['session_pricing'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      language: json['language'] as String?,
    );

Map<String, dynamic> _$TeacherDetailsToJson(TeacherDetails instance) =>
    <String, dynamic>{
      'teacher_id': instance.teacherId,
      'name': instance.name,
      'mobile_number': instance.mobileNumber,
      'email': instance.email,
      'intro_video_url': instance.introVideoUrl,
      'location': instance.location,
      'gender': instance.gender,
      'title': instance.title,
      'info': instance.info,
      'tags': instance.tags,
      'education': instance.education,
      'designation': instance.designation,
      'profile_url': instance.profileUrl,
      'profile_picture_url': instance.profilePictureUrl,
      'session_pricing': instance.sessionPricing,
      'language': instance.language,
    };
