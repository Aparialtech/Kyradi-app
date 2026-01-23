import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../widgets/section_card.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.userInfoTitle,
    required this.userInfoSubtitle,
    required this.firstNameLabel,
    required this.lastNameLabel,
    required this.phoneLabel,
    required this.emailLabel,
    required this.addressLabel,
    required this.genderLabel,
    required this.genderMaleLabel,
    required this.genderFemaleLabel,
    required this.genderUndisclosedLabel,
    required this.emergencyTitle,
    required this.emergencySubtitle,
    required this.relationLabel,
    required this.emergencyRegisteredPersonLabel,
    required this.userNameCtrl,
    required this.userSurnameCtrl,
    required this.userPhoneCtrl,
    required this.userEmailCtrl,
    required this.userAddressCtrl,
    required this.gender,
    required this.onGenderChanged,
    required this.emNameCtrl,
    required this.emSurnameCtrl,
    required this.emPhoneCtrl,
    required this.emEmailCtrl,
    required this.emAddressCtrl,
    required this.emRelationCtrl,
    required this.emergencyContact,
  });

  final String userInfoTitle;
  final String userInfoSubtitle;
  final String firstNameLabel;
  final String lastNameLabel;
  final String phoneLabel;
  final String emailLabel;
  final String addressLabel;
  final String genderLabel;
  final String genderMaleLabel;
  final String genderFemaleLabel;
  final String genderUndisclosedLabel;
  final String emergencyTitle;
  final String emergencySubtitle;
  final String relationLabel;
  final String emergencyRegisteredPersonLabel;

  final TextEditingController userNameCtrl;
  final TextEditingController userSurnameCtrl;
  final TextEditingController userPhoneCtrl;
  final TextEditingController userEmailCtrl;
  final TextEditingController userAddressCtrl;
  final String? gender;
  final ValueChanged<String?> onGenderChanged;

  final TextEditingController emNameCtrl;
  final TextEditingController emSurnameCtrl;
  final TextEditingController emPhoneCtrl;
  final TextEditingController emEmailCtrl;
  final TextEditingController emAddressCtrl;
  final TextEditingController emRelationCtrl;
  final EmergencyContactModel? emergencyContact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: userInfoTitle,
                subtitle: userInfoSubtitle,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userNameCtrl,
                decoration: InputDecoration(
                  labelText: firstNameLabel,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userSurnameCtrl,
                decoration: InputDecoration(
                  labelText: lastNameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userPhoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: phoneLabel,
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userEmailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userAddressCtrl,
                decoration: InputDecoration(
                  labelText: addressLabel,
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(gender),
                initialValue: gender,
                decoration: InputDecoration(
                  labelText: genderLabel,
                  prefixIcon: const Icon(Icons.wc),
                ),
                items: [
                  DropdownMenuItem(
                    value: "male",
                    child: Text(genderMaleLabel),
                  ),
                  DropdownMenuItem(
                    value: "female",
                    child: Text(genderFemaleLabel),
                  ),
                  DropdownMenuItem(
                    value: "none",
                    child: Text(genderUndisclosedLabel),
                  ),
                ],
                onChanged: onGenderChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: emergencyTitle,
                subtitle: emergencySubtitle,
                icon: Icons.shield_outlined,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emNameCtrl,
                decoration: InputDecoration(
                  labelText: firstNameLabel,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emSurnameCtrl,
                decoration: InputDecoration(
                  labelText: lastNameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emPhoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: phoneLabel,
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emEmailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emAddressCtrl,
                decoration: InputDecoration(
                  labelText: addressLabel,
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emRelationCtrl,
                decoration: InputDecoration(
                  labelText: relationLabel,
                  prefixIcon: const Icon(Icons.handshake_outlined),
                ),
              ),
              if (emergencyContact != null &&
                  emergencyContact!.fullName.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                Divider(color: theme.colorScheme.outlineVariant),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: emergencyRegisteredPersonLabel,
                  value: emergencyContact!.fullName,
                ),
                _InfoRow(
                  icon: Icons.call,
                  label: phoneLabel,
                  value: emergencyContact!.phone,
                ),
                _InfoRow(
                  icon: Icons.mail_outline,
                  label: emailLabel,
                  value: emergencyContact!.email,
                ),
                _InfoRow(
                  icon: Icons.home_outlined,
                  label: addressLabel,
                  value: emergencyContact!.address,
                ),
                _InfoRow(
                  icon: Icons.group_work_outlined,
                  label: relationLabel,
                  value: emergencyContact!.relation,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
