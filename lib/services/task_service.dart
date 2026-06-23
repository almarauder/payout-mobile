import 'dart:convert';
import 'package:payouts_platform/data/models/task_model.dart';
import '../data/api/api_client.dart';
import '../data/api/api_constant.dart';

class TaskService {
  final ApiClient _apiClient;

  TaskService(this._apiClient);

  Future<List<TaskModel>> fetchTasks() async {
    final response = await _apiClient.get(ApiConstant.tasks);

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    if (response.statusCode != 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>?;
      throw ApiException(body?['error']?.toString() ?? 'HTTP ${response.statusCode}');
    }

    final list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> fetchTask(int id) async {
    final response = await _apiClient.get(ApiConstant.taskDetail(id));

    if (response.statusCode == 401) throw UnauthorizedException();
    if (response.statusCode == 404) throw NotFoundException('Задача не найдена');
    if (response.statusCode != 200) throw ApiException('HTTP ${response.statusCode}');

    return TaskModel.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }
}


class UnauthorizedException implements Exception {
  @override
  String toString() => 'Сессия истекла. Войдите снова.';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}