class Application {
  final String vacancyId;
  final String fullName;
  final String email;
  final String phone;
  final String secondPhone;
  final String coverLetter;
  final String dateOfBirth;
  final String gender;
  final String citizenship;

  Application({
    required this.vacancyId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.secondPhone,
    required this.coverLetter,
    required this.dateOfBirth,
    required this.gender,
    required this.citizenship,
  });

  Map<String, dynamic> toJson() => {
    'vacancyId': vacancyId,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'secondPhone': secondPhone,
    'coverLetter': coverLetter,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'citizenship': citizenship,
    'submittedAt': DateTime.now().toIso8601String(),
  };
}
