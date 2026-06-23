import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';
import '../../../../data/api/api_client.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/task_service.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  const Text('Задачи', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
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
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _tasks.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    if (_visibleTasks.isEmpty) return const Center(child: Text('Задач нет'));

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
        ),
        itemCount: _visibleTasks.length,
        itemBuilder: (context, index) => TaskCard(task: _visibleTasks[index]),
      ),
    );
  }
}