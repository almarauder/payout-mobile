import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payouts_platform/core/theme/app_colors.dart';
import 'package:payouts_platform/features/home/presentation/screens/home_screen.dart';
import 'package:payouts_platform/features/navigation/cubit/bottom_cubit.dart';
import 'package:payouts_platform/features/navigation/widgets/nav_item.dart';

class RootScreen extends StatefulWidget {
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Something #1')),
    const Center(child: Text('Something #2')),
  ];

  @override
  Widget build(BuildContext) {
    return BlocBuilder<BottomCubit, int>(
      builder: (context , index) {
        return Scaffold(
          body: IndexedStack(index: index, children: _pages),
          bottomNavigationBar: Container(
            height: 95,
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavItem(index: 0, currentIndex: index, icon: Icons.list_alt, activeIcon: Icons.list_alt, label: 'Задачи', selectedColor: AppColors.gradientBottom, unselectedColor: AppColors.gradientMid),
                NavItem(index: 1, currentIndex: index, icon: Icons.assignment, activeIcon: Icons.assignment, label: 'Договоры', selectedColor: AppColors.gradientBottom, unselectedColor: AppColors.gradientMid),
                NavItem(index: 2, currentIndex: index, icon: Icons.person, activeIcon: Icons.person, label: 'Профиль', selectedColor: AppColors.gradientBottom, unselectedColor: AppColors.gradientMid),
              ],
            ),
          ),
        );
      },
    );
  }
}