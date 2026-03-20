import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/stock_model.dart';
import '../../../../core/theme/app_colors.dart';

class StockListItem extends StatelessWidget {
  const StockListItem({
    super.key,
    required this.stock,
    required this.onDelete,
  });

  final StockModel stock;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ItemRow(stock: stock, onDelete: onDelete),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.stock, required this.onDelete});

  final StockModel stock;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.drag_handle,
              color: AppColors.dragHandle,
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(child: _StockNameColumn(stock: stock)),
          _DeleteButton(onTap: onDelete),
        ],
      ),
    );
  }
}

class _StockNameColumn extends StatelessWidget {
  const _StockNameColumn({required this.stock});

  final StockModel stock;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            stock.displayName,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (stock.type != StockType.equity) ...[
          const SizedBox(width: 8),
          _TypeBadge(type: stock.type),
        ],
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final StockType type;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (type) {
      StockType.option => (AppColors.badgeOptionBg, AppColors.badgeOptionFg),
      StockType.indexFund => (AppColors.badgeIndexBg, AppColors.badgeIndexFg),
      StockType.equity => (Colors.transparent, Colors.transparent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.delete_outline, size: 20),
      color: AppColors.deleteIcon,
      tooltip: 'Remove from watchlist',
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
