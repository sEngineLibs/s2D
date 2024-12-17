package s2d;

import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.Canvas;
// s2d
import s2d.objects.Object;
import s2d.objects.Sprite;
import s2d.objects.Light;

using score.utils.ArrayExt;

@:build(score.macro.SMacro.build())
class S2D {
	@readonly public var lights:Array<Light> = [];
	@readonly public var sprites:Array<Sprite> = [];
	@readonly public var projection:FastMatrix4;
	@readonly public var projectionScale:FastFloat = 10;

	public function new() {}

	public inline function add(object:Object) {
		if (object is Sprite) {
			var sprite:Sprite = cast object;
			sprites.push(sprite);
		} else if (object is Light)
			lights.push(cast object);
	}

	public inline function update() {};

	public inline function resize(w:Int, h:Int) {
		var b = projectionScale, s = w / h;
		if (s >= 1)
			projection = FastMatrix4.orthogonalProjection(-b * s, b * s, -b, b, 0, 1);
		else
			projection = FastMatrix4.orthogonalProjection(-b, b, -b / s, b / s, 0, 1);
	}

	inline function showGrid(target:Canvas) {
		var cellSize, s = target.width / target.height;
		if (s >= 1)
			cellSize = target.height / (projectionScale * 2);
		else
			cellSize = target.width / (projectionScale * 2);

		target.g2.color = White;
		target.g2.pushOpacity(0.25);
		for (i in 0...Std.int(projectionScale * 2)) {
			target.g2.drawLine(i * cellSize, 0, i * cellSize, target.height, 1);
			target.g2.drawLine(0, i * cellSize, target.width, i * cellSize, 1);
		}
		target.g2.popOpacity();
	}

	public inline function render(target:Canvas) {
		for (sprite in sprites)
			sprite.render(target);
		#if S2D_SHOW_GRID
		showGrid(target);
		#end
	}
}
