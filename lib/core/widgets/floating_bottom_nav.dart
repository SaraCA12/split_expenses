import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NavItemData {
  final IconData icon;
  final String route;

  const NavItemData({required this.icon, required this.route});
}

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<NavItemData> items; // exactamente 4 items (2 a cada lado del FAB)
  final VoidCallback onFabTap;
  final void Function(int index) onItemTap;

  const FloatingBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onFabTap,
    required this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    assert(items.length == 4, 'FloatingBottomNav necesita exactamente 4 items');

    return SizedBox(
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Barra de fondo
          Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavIcon(
                  icon: items[0].icon,
                  isActive: currentIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                _NavIcon(
                  icon: items[1].icon,
                  isActive: currentIndex == 1,
                  onTap: () => onItemTap(1),
                ),
                const SizedBox(width: 56), // espacio para el FAB
                _NavIcon(
                  icon: items[2].icon,
                  isActive: currentIndex == 2,
                  onTap: () => onItemTap(2),
                ),
                _NavIcon(
                  icon: items[3].icon,
                  isActive: currentIndex == 3,
                  onTap: () => onItemTap(3),
                ),
              ],
            ),
          ),

          // FAB central flotante, un poco más arriba de la barra
          Positioned(
            top: -8,
            child: GestureDetector(
              onTap: onFabTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? AppColors.primary : AppColors.textHint,
        ),
      ),
    );
  }
}