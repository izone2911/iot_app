import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart'; 
import 'lazy_loading_handler.dart';

//
class LazyLoadingWidget<T extends LazyLoadingHandler> extends StatefulWidget {
  const LazyLoadingWidget({super.key, required this.getWidget});

  final Widget Function(int index) getWidget;

  @override
  State<LazyLoadingWidget> createState() => LazyLoadingState<T>();
}

class LazyLoadingState<T extends LazyLoadingHandler>
    extends State<LazyLoadingWidget> /**/
{
  late final ScrollController _controller;
  late final T _provider;

  void _scrollHandler() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      debugPrint("?");
      _provider.updateOnList();
    }
  }

  Future<void> _onRefresh() async => _provider.refreshOnList();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of(context, listen: false);
    _controller = ScrollController()..addListener(_scrollHandler);
  }

  @override
  Widget build(BuildContext context) {
    final length = context.select<T, int>((provider) => provider.getLMLength);

    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: LazyLoadScrollView(
          onEndOfPage: () => _provider.updateOnList(),
          child: ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                if (index != length) {
                  return widget.getWidget(index);
                }
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }),
        ));
  }
}
