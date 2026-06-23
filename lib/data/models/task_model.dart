import 'package:flutter/material.dart';

enum TaskStatus {
  created,
  accepted,
  inProgress,
  submitted,
  review,
  approved,
  rejected,
  completed,
}

extension TaskStatusX on TaskStatus {
  static TaskStatus fromJson(String value) {
    switch (value) {
      case 'CREATED':     return TaskStatus.created;
      case 'ACCEPTED':    return TaskStatus.accepted;
      case 'IN_PROGRESS': return TaskStatus.inProgress;
      case 'SUBMITTED':   return TaskStatus.submitted;
      case 'REVIEW':      return TaskStatus.review;
      case 'APPROVED':    return TaskStatus.approved;
      case 'REJECTED':    return TaskStatus.rejected;
      case 'COMPLETED':   return TaskStatus.completed;
      default:            return TaskStatus.created;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.created:    return 'Создана';
      case TaskStatus.accepted:   return 'Принята';
      case TaskStatus.inProgress: return 'В работе';
      case TaskStatus.submitted:  return 'Отправлена';
      case TaskStatus.review:     return 'На проверке';
      case TaskStatus.approved:   return 'Одобрена';
      case TaskStatus.rejected:   return 'Отклонена';
      case TaskStatus.completed:  return 'Завершена';
    }
  }

  Color get textColor {
    switch (this) {
      case TaskStatus.created:    return const Color(0xFF374151);
      case TaskStatus.accepted:   return const Color(0xFF1D4ED8);
      case TaskStatus.inProgress: return const Color(0xFF7C3AED);
      case TaskStatus.submitted:  return const Color(0xFFC2410C);
      case TaskStatus.review:     return const Color(0xFF92400E);
      case TaskStatus.approved:   return const Color(0xFF065F46);
      case TaskStatus.rejected:   return const Color(0xFF991B1B);
      case TaskStatus.completed:  return const Color(0xFF065F46);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TaskStatus.created:    return const Color(0xFFF3F4F6);
      case TaskStatus.accepted:   return const Color(0xFFDBEAFE);
      case TaskStatus.inProgress: return const Color(0xFFEDE9FE);
      case TaskStatus.submitted:  return const Color(0xFFFFEDD5);
      case TaskStatus.review:     return const Color(0xFFFEF3C7);
      case TaskStatus.approved:   return const Color(0xFFD1FAE5);
      case TaskStatus.rejected:   return const Color(0xFFFEE2E2);
      case TaskStatus.completed:  return const Color(0xFFD1FAE5);
    }
  }
}

class TaskModel {
  final int id;
  final int companyId;
  final int createdById;
  final int? assignedToId;
  final int? contractId;
  final String title;
  final String description;
  final double budget;
  final DateTime? deadline;
  final TaskStatus status;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.companyId,
    required this.createdById,
    this.assignedToId,
    this.contractId,
    required this.title,
    required this.description,
    required this.budget,
    this.deadline,
    required this.status,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    int? extractId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is Map && value['id'] != null) {
        return int.tryParse(value['id'].toString());
      }
      return int.tryParse(value.toString());
    }

    return TaskModel(
      id: extractId(json['id']) ?? 0,
      
      companyId: extractId(json['companyId'] ?? json['company']) ?? 0,
      createdById: extractId(json['createdById'] ?? json['createdBy']) ?? 0,
      
      assignedToId: extractId(json['assignedToId'] ?? json['assignedTo']),
      contractId: extractId(json['contractId'] ?? json['contract']),
      
      title: json['title']?.toString() ?? 'Без названия',
      description: json['description']?.toString() ?? '',
      
      budget: double.tryParse(json['budget']?.toString() ?? '0') ?? 0.0,
      
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'].toString())
          : null,
          
      status: TaskStatusX.fromJson(json['status']?.toString() ?? 'CREATED'),
      
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}