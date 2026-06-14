class ApiConstant {
  static const String baseUrl = 'https://happy-forgiveness-production-caca.up.railway.app/api';

  // Auth
  static const String register = '$baseUrl/auth/register/';
  static const String login = '$baseUrl/auth/login/';
  static const String me = '$baseUrl/auth/me/';
  static const String registerContractor = '$baseUrl/auth/register-contractor/';

  // Contracts
  static const String contractTemplates = '$baseUrl/contracts/templates/';
  static const String contracts = '$baseUrl/contracts/';
  static String contractDetail(int id) => '$baseUrl/contracts/$id';
  static String contractSign(int id) => '$baseUrl/contracts/$id/sign/';

  // Tasks
  static const String tasks = '$baseUrl/tasks/';
  static String taskDetail(int id) => '$baseUrl/tasks/$id';
}