class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

const List<Country> countries = [
  Country(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
  Country(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
  Country(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
  Country(name: 'Kenya', code: 'KE', dialCode: '+254', flag: '🇰🇪'),
  Country(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬'),
  Country(name: 'South Africa', code: 'ZA', dialCode: '+27', flag: '🇿🇦'),
  Country(name: 'Rwanda', code: 'RW', dialCode: '+250', flag: '🇷🇼'),
  Country(name: 'Tanzania', code: 'TZ', dialCode: '+255', flag: '🇹🇿'),
  Country(name: 'Uganda', code: 'UG', dialCode: '+256', flag: '🇺🇬'),
  Country(name: 'Ghana', code: 'GH', dialCode: '+233', flag: '🇬🇭'),
  Country(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
  Country(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
  Country(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
  Country(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
  Country(name: 'China', code: 'CN', dialCode: '+86', flag: '🇨🇳'),
  Country(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
];
