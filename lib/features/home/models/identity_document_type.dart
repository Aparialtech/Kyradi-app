enum IdentityDocumentType { idCard, passport }

extension IdentityDocumentTypeExtension on IdentityDocumentType {
  String label(dynamic loc) {
    switch (this) {
      case IdentityDocumentType.idCard:
        return loc.identityDocIdCard;
      case IdentityDocumentType.passport:
        return loc.identityDocPassport;
    }
  }

  static IdentityDocumentType? fromName(String? name) {
    if (name == null || name.isEmpty) return null;
    for (final type in IdentityDocumentType.values) {
      if (type.name == name) return type;
    }
    return null;
  }
}
