class EmergencyContactModel {
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String relation;

  const EmergencyContactModel({
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.relation = '',
  });

  factory EmergencyContactModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final givenName = (json['name'] ?? '').toString();
      final familyName = (json['surname'] ?? '').toString();
      var resolvedFullName = (json['fullName'] ?? '').toString();
      if (resolvedFullName.trim().isEmpty) {
        resolvedFullName =
            [givenName, familyName].where((e) => e.trim().isNotEmpty).join(' ').trim();
      }
      return EmergencyContactModel(
        fullName: resolvedFullName,
        phone: (json['phone'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
        relation: (json['relation'] ?? '').toString(),
      );
    }
    return const EmergencyContactModel();
  }

  Map<String, dynamic> toJson() {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return {
      'fullName': fullName,
      'name': first,
      'surname': last,
      'phone': phone,
      'email': email,
      'address': address,
      'relation': relation,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String? birthDate;
  final String? nationalId;
  final String verificationStatus;
  final String? verifiedAt;
  final String? identityDocumentUrl;
  final String? avatarUrl;
  final bool pushReminderEnabled;
  final bool emailReminderEnabled;
  final EmergencyContactModel? emergencyContact;

  const UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.phone = '',
    this.address = '',
    this.gender = 'none',
    this.birthDate,
    this.nationalId,
    this.verificationStatus = 'unverified',
    this.verifiedAt,
    this.identityDocumentUrl,
    this.avatarUrl,
    this.pushReminderEnabled = true,
    this.emailReminderEnabled = true,
    this.emergencyContact,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['_id'];
    final identityRaw = (json['identityDocumentUrl'] ?? '').toString();
    return UserModel(
      id: (rawId ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      surname: (json['surname'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      gender: (() {
        final gender = (json['gender'] ?? '').toString().trim();
        if (gender.isEmpty) return 'none';
        return gender;
      })(),
      birthDate: json['birthDate']?.toString(),
      nationalId: (json['nationalId'] ?? '').toString(),
      verificationStatus: (json['verificationStatus'] ?? 'unverified').toString(),
      verifiedAt: json['verifiedAt']?.toString(),
      identityDocumentUrl: identityRaw.isEmpty ? null : identityRaw,
      avatarUrl: (json['avatarUrl'] ?? '').toString().trim().isEmpty
          ? null
          : (json['avatarUrl'] ?? '').toString(),
      pushReminderEnabled: (json['pushReminderEnabled'] ?? true) == true,
      emailReminderEnabled: (json['emailReminderEnabled'] ?? true) == true,
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContactModel.fromJson(json['emergencyContact'])
          : json['emergency'] != null
              ? EmergencyContactModel.fromJson(json['emergency'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'email': email,
        'phone': phone,
        'address': address,
        'gender': gender,
        'birthDate': birthDate,
        'nationalId': nationalId,
        'verificationStatus': verificationStatus,
        'verifiedAt': verifiedAt,
        'identityDocumentUrl': identityDocumentUrl,
        'avatarUrl': avatarUrl,
        'pushReminderEnabled': pushReminderEnabled,
        'emailReminderEnabled': emailReminderEnabled,
        'emergencyContact': emergencyContact?.toJson(),
      };
}
