import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/watchlist_bloc.dart';
import '../../bloc/watchlist_event.dart';
import '../../bloc/watchlist_state.dart';
import '../../data/repositories/watchlist_repository.dart';
import '../widgets/bottom_action_buttons.dart';
import '../widgets/stock_list_item.dart';
import '../widgets/watchlist_header.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistBloc(
        repository: WatchlistRepository(),
      )..add(const WatchlistLoaded()),
      child: const _WatchlistView(),
    );
  }
}

class _WatchlistView extends StatelessWidget {
  const _WatchlistView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Watchlist 1'),
        centerTitle: false,
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          return switch (state) {
            WatchlistInitial() ||
            WatchlistLoadInProgress() =>
              const _LoadingView(),
            WatchlistLoadFailure(:final message) =>
              _ErrorView(message: message),
            WatchlistLoadSuccess(:final watchlistName, :final stocks) =>
              _SuccessView(watchlistName: watchlistName, stocks: stocks),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.black54),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  context.read<WatchlistBloc>().add(const WatchlistLoaded()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.watchlistName,
    required this.stocks,
  });

  final String watchlistName;
  final List stocks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WatchlistHeader(name: watchlistName),
        Expanded(
          child: _StockReorderableList(stocks: stocks),
        ),
        BottomActionButtons(
          onEditOtherWatchlists: () =>
              _showSnackBar(context, 'Opening other watchlists…'),
          onSave: () => _showSnackBar(context, 'Watchlist saved!'),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class _StockReorderableList extends StatelessWidget {
  const _StockReorderableList({required this.stocks});

  final List stocks;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WatchlistBloc>();

    return ReorderableListView.builder(
      itemCount: stocks.length,
      buildDefaultDragHandles: false,
      proxyDecorator: _proxyDecorator,
      onReorder: (oldIndex, newIndex) {
        bloc.add(WatchlistStockReordered(
          oldIndex: oldIndex,
          newIndex: newIndex,
        ));
      },
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return ReorderableDragStartListener(
          key: ValueKey(stock.id),
          index: index,
          child: StockListItem(
            stock: stock,
            onDelete: () => bloc.add(
              WatchlistStockRemoved(stockId: stock.id),
            ),
          ),
        );
      },
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, innerChild) {
        final elevation = Tween<double>(begin: 0, end: 6)
            .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ))
            .value;
        return Material(
          elevation: elevation,
          color: Colors.white,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(4),
          child: innerChild,
        );
      },
      child: child,
    );
  }
}
