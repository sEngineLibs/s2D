package s2d.objects;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.FastVector3;
// sui
import s2d.objects.Object;

@:structInit
class Light extends Object {
	public var color:Color = Color.White;
	public var power:FastFloat = 1;
	public var radius:FastFloat = 0;
	public var isCastingShadows:Bool = true;

	public inline function new(stage:S2D, ?color:Color = Color.White, ?power:FastFloat = 1, ?radius:FastFloat = 0, ?isCastingShadows:Bool = true) {
		super(stage);

		this.color = color;
		this.power = power;
		this.radius = radius;
		this.isCastingShadows = isCastingShadows;
	}

	public function drawShadows(target:Image, vertices:Array<FastVector3>):Void {}
}
