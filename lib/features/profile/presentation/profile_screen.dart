import 'package:flutter/material.dart';
import 'package:payouts_platform/data/api/api_client.dart';
import 'package:payouts_platform/data/models/user_model.dart';
import 'package:payouts_platform/data/repositories/auth_repository.dart';
import 'package:payouts_platform/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthRepository _authRepository;
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final authService = AuthService();
    _authRepository = AuthRepository(ApiClient(authService), authService);
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Профиль',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C2033),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const _LoadingCard()
              else if (_error != null)
                _ErrorCard(error: _error!, onRetry: _loadUser)
              else if (_user != null)
                _ProfileCard(user: _user!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserModel user;

  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Email + role badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FieldBlock(label: 'Email', value: user.email),
              ),
              const SizedBox(width: 12),
              _RoleBadge(role: user.role),
            ],
          ),

          const _Divider(),
        ],
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final String value;

  const _FieldBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9EA3B5),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C2033),
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final config = _roleConfig(role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: config.textColor,
        ),
      ),
    );
  }

  _RoleConfig _roleConfig(String role) {
    switch (role) {
      case 'admin':
        return const _RoleConfig(
          label: 'Администратор',
          background: Color(0xFFE9E4F7),
          textColor: Color(0xFF6B4FC8),
        );
      case 'contractor':
        return const _RoleConfig(
          label: 'Подрядчик',
          background: Color(0xFFE3F1FF),
          textColor: Color(0xFF2D72C8),
        );
      default:
        return _RoleConfig(
          label: role,
          background: const Color(0xFFEEEFF3),
          textColor: const Color(0xFF6B7080),
        );
    }
  }
}

class _RoleConfig {
  final String label;
  final Color background;
  final Color textColor;

  const _RoleConfig({
    required this.label,
    required this.background,
    required this.textColor,
  });
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      height: 1,
      color: const Color(0xFFF0F1F5),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: _SkeletonBlock(width: double.infinity, height: 38)),
              const SizedBox(width: 12),
              _SkeletonBlock(width: 110, height: 32, radius: 20),
            ],
          ),
          const SizedBox(height: 18),
          const _Divider(),
          const _SkeletonBlock(width: 180, height: 38),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFF3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorCard({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE05C5C), size: 40),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7080)),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Повторить',
              style: TextStyle(
                color: Color(0xFF3E9E8F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}