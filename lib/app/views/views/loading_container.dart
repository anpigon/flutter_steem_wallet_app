import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/widgets/loader.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoadingContainer extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingContainer(
      {Key? key, required this.isLoading, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: Loader(),
      child: child,
    );
  }
}
