import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';
import 'package:payouts_platform/features/contracts/presentation/widgets/contracts_sheet.dart';
import 'package:payouts_platform/features/home/presentation/widgets/task_card.dart';
import '../../../../data/api/api_client.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/task_service.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  late final TaskService _service;
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _error;
  TaskStatus? _activeFilter;

  static const _filters = <({String label, TaskStatus? value})>[
    (label: 'Все',         value: null),
    (label: 'Созданы',     value: TaskStatus.created),
    (label: 'В работе',    value: TaskStatus.inProgress),
    (label: 'На проверке', value: TaskStatus.review),
    (label: 'Одобрены',    value: TaskStatus.approved),
  ];

  @override
  void initState() {
    super.initState();
    final authService = AuthService();
    final apiClient = ApiClient(authService);
    _service = TaskService(apiClient);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final tasks = await _service.fetchTasks();
      setState(() => _tasks = tasks);
    } on UnauthorizedException {
      setState(() => _error = 'Сессия истекла. Войдите снова.');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<TaskModel> get _visibleTasks => _activeFilter == null
      ? _tasks
      : _tasks.where((t) => t.status == _activeFilter).toList();

  void _showContractDetails(TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ContractDetailsSheet(task: task),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final visible = _visibleTasks;
    if (visible.isEmpty) {
      return const Center(child: Text('Нет договоров в этой категории'));
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = visible[index];
          return TaskCard(
            task: task,
            onTap: () => _showContractDetails(task),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Договоры', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  IconButton(
                    onPressed: _isLoading ? null : _loadTasks, 
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final active = _activeFilter == f.value;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = f.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF111827) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(f.label, style: TextStyle(fontSize: 13, color: active ? Colors.white : const Color(0xFF374151))),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }
}