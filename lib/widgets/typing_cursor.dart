import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 光标闪烁动画
class TypingCursor extends HookWidget {
  const TypingCursor({super.key});

  @override
  Widget build(BuildContext context) {

    // 动画控制器
    final ac = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // 动画监听器
    ac.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        ac.reverse();
      } else if(status == AnimationStatus.dismissed) {
        ac.forward();
      }
    });

    final opacity = useAnimation(
        Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeIn))
            .animate(ac),
    );

    if(!ac.isAnimating) {
      ac.forward(); // 动画开始
    }
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: 6,
        height: 12,
        color: Colors.black,
      ),
    );
  }

}