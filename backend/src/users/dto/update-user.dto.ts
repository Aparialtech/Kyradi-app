export class EmergencyContactDto {
  fullName?: string;
  phone?: string;
  email?: string;
  address?: string;
  relation?: string;
}

export class UpdateUserDto {
  name?: string;
  surname?: string;
  email?: string;
  phone?: string;
  address?: string;
  gender?: string;
  pushReminderEnabled?: boolean;
  emailReminderEnabled?: boolean;
  identityDocumentUrl?: string;
  emergencyContact?: EmergencyContactDto;
}
