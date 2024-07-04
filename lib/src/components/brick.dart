import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required this.number,required super.position, required Color color})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  final int number;

  @override
  void renderTree(Canvas canvas) {
    super.renderTree(canvas);
    final textSpan = TextSpan(
      text: number.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.x - textPainter.width / 2,
        position.y - textPainter.height / 2,
      ),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();

    if (game.world.children.query<Brick>().length == 1) {
       game.playState = PlayState.won;  
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}