import 'package:newversity/themes/strings.dart';

class ExpandedItemModel {
  QuestionAnsModel questionAnsModel;
  bool isExpanded;

  ExpandedItemModel({required this.questionAnsModel, required this.isExpanded});

  static List<ExpandedItemModel> listOfExpandedItem = [
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity?",
            answer: "Newversity believes in every student's potential to succeed with proper guidance and resources. We provide access to qualified mentors who can help students reach their full potential. Our platform connects students with exam toppers, career professionals, and mentors to offer personalized mentorship, career insights, and a deep understanding of the job market. Join Newversity to ace your exams, gain career insights, and connect with top professionals in your field. Unlock your full potential today"),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "How can I find the right mentor?",
            answer: "We have verified mentors across all profile. Student can search by exam name, mentor name and filter them based on language, location, skills, rating and review"),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "How long are the calls?", answer: "call duration is 15min and 30min, student can book any type of slot according the their preference"),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "Can I choose my own mentor?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "How much does it cost?",
            answer: "Session/call price is setup by mentors only."),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is the refund/cancellation policy",
            answer: "you can cancel a call before a mentor accepts it, to automatically receive a refund. your refund, minus any payment gateway fees, if applicable, will be returned to you using the same payment method. In the unfortunate event that a mentor is unable to make it for the call, you will automatically receive a full refund."),
        isExpanded: false),
  ];
}

class QuestionAnsModel {
  String? question;
  String? answer;

  QuestionAnsModel({required this.question, required this.answer});
}
