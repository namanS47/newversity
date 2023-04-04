enum UserType { student, teacher }

enum Gender { male, female, other }

enum SlotType { short, long, both }

enum TagStatus { Verified, Unverified, Failed }

enum SessionType { upcoming, previous }

enum TagCategory { exams, guidance }

String getTagCategory(TagCategory tagCat) {
  String tagCategory = "";
  switch (tagCat) {
    case TagCategory.exams:
      tagCategory = "exams";
      break;
    case TagCategory.guidance:
      tagCategory = "guidance";
      break;
  }
  return tagCategory;
}

String getSlotType(SlotType slotType) {
  String slotTp = "";
  switch (slotType) {
    case SlotType.short:
      slotTp = "short";
      break;
    case SlotType.long:
      slotTp = "long";
      break;
    case SlotType.both:
      slotTp = "both";
      break;
  }
  return slotTp;
}

String getSessionType(SessionType sessionType) {
  String sessionTp = "";
  switch (sessionType) {
    case SessionType.upcoming:
      sessionTp = "upcoming";
      break;
    case SessionType.previous:
      sessionTp = "previous";
      break;
  }
  return sessionTp;
}
