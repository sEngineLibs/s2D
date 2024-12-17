package s2d;

import kha.Canvas;
import kha.FastFloat;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
// s2d
import s2d.objects.Object;
import s2d.objects.Sprite;
import s2d.objects.Light;

using score.utils.ArrayExt;

@:build(score.macro.SMacro.build())
class S2D {
	@readonly public var lights:Array<Light> = [];
	@readonly public var sprites:Array<Sprite> = [];
	@readonly public var projection:OrthogonalProjection = FastMatrix4.orthogonalProjection(-1, 1, -1, 1, 0, 1);

	public function new() {}

	public inline function add(object:Object) {
		if (object is Sprite) {
			var sprite:Sprite = cast object;
			sprites.push(sprite);
		} else if (object is Light)
			lights.push(cast object);
	}

	public inline function update() {};

	inline function showGrid(target:Canvas) {
		// var cellSize, s = target.width / target.height;
		// if (s >= 1)
		// 	cellSize = target.height / (projectionScale * 2);
		// else
		// 	cellSize = target.width / (projectionScale * 2);

		// target.g2.color = White;
		// target.g2.pushOpacity(0.25);
		// for (i in 0...Std.int(projectionScale * 2)) {
		// 	target.g2.drawLine(i * cellSize, 0, i * cellSize, target.height, 1);
		// 	target.g2.drawLine(0, i * cellSize, target.width, i * cellSize, 1);
		// }
		// target.g2.popOpacity();
	}

	public inline function render(target:Canvas) {
		for (sprite in sprites)
			sprite.render(target);
		#if S2D_SHOW_GRID
		showGrid(target);
		#end
	}
}

@:structInit
@:build(score.macro.SMacro.build())
private abstract OrthogonalProjection(FastMatrix4) from FastMatrix4 to FastMatrix4 {
	public inline function rotate(angle:FastFloat):Void {
		this = this.multmat(FastMatrix4.rotationZ(angle));
	}

	public inline function scale(x:FastFloat, y:FastFloat, ?z:FastFloat = 1):Void {
		this = this.multmat(FastMatrix4.scale(x, y, z));
	}

	public inline function translate(x:FastFloat, y:FastFloat, ?z:FastFloat = 0):Void {
		this = this.multmat(FastMatrix4.translation(x, y, z));
	}

	public inline function setAspectRatio(value:FastFloat) {
		if (value >= 1)
			scale(1 / this._00 / value, 1, 1);
		else
			scale(1, value / this._11, 1);
	}

	public inline function multmat(value:FastMatrix4) {
		return this.multmat(value);
	}
}
