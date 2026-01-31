import {
  IsEmail,
  IsOptional,
  IsString,
  MinLength,
  Validate,
  ValidationArguments,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

@ValidatorConstraint({ name: 'nameOrFullName', async: false })
class NameOrFullNameConstraint implements ValidatorConstraintInterface {
  validate(_: unknown, args: ValidationArguments) {
    const dto = args.object as CreateUserDto;
    const hasFullName = typeof dto.fullName === 'string' && dto.fullName.trim().length > 0;
    const hasName = typeof dto.name === 'string' && dto.name.trim().length > 0;
    const hasSurname = typeof dto.surname === 'string' && dto.surname.trim().length > 0;
    if (hasFullName) return true;
    return hasName && hasSurname;
  }

  defaultMessage() {
    return 'name+surname or fullName is required';
  }
}

export class CreateUserDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  name?: string;

  @IsOptional()
  @IsString()
  @MinLength(1)
  surname?: string;

  @IsOptional()
  @IsString()
  @MinLength(1)
  fullName?: string;

  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(6)
  password!: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @Validate(NameOrFullNameConstraint)
  nameOrFullNameCheck?: string;
}
