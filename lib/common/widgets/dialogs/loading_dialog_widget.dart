import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/loading_indicator_widget.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String? message;

  const LoadingDialogWidget({super.key, this.message});

  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialogWidget(message: message),
    );
  }

  static void hide(BuildContext context) => context.pop();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.none,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingIndicatorWidget(type: LoadingIndicatorType.circular),
              if (message != null) ...[
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    message!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
