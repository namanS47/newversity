import 'package:newversity/themes/strings.dart';

class ExpandedItemModel {
  QuestionAnsModel questionAnsModel;
  bool isExpanded;

  ExpandedItemModel({required this.questionAnsModel, required this.isExpanded});

  static List<ExpandedItemModel> listOfExpandedItem = [
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "How does a Newversity app work?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "Is the service free?", answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "Can I choose my own mentor?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
    ExpandedItemModel(
        questionAnsModel: QuestionAnsModel(
            question: "What is a Newversity app?",
            answer: AppStrings.loremText),
        isExpanded: false),
  ];
}

class QuestionAnsModel {
  String? question;
  String? answer;

  QuestionAnsModel({required this.question, required this.answer});
}
