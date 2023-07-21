enum UserType { student, teacher }

enum Gender { male, female, other }

enum SlotType { short, long, both }

enum TagStatus { Verified, Unverified, Failed, InProcess }

enum SessionType { upcoming, previous }

enum TagCategory { expertise, scope }

String getTagCategory(TagCategory tagCat) {
  String tagCategory = "";
  switch (tagCat) {
    case TagCategory.expertise:
      tagCategory = "expertise";
      break;
    case TagCategory.scope:
      tagCategory = "scope";
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

String getSessionTypeWithSlotType(SlotType type) {
  String sessionType = "";
  switch (type) {
    case SlotType.short:
      sessionType = "15 min session";
      break;
    case SlotType.long:
      sessionType = "30 min session";
      break;
    case SlotType.both:
      sessionType = "both sessions";
      break;
  }
  return sessionType;
}
