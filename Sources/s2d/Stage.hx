package s2d;

import kha.math.FastMatrix4;
// s2d
import s2d.objects.Light;
import s2d.objects.Sprite;

class Stage {
	public var sprites:Array<Sprite> = [];
	public var lights:Array<Light> = [];
	public var camera:FastMatrix4;

	public inline function new() {
		camera = FastMatrix4.lookAt({x: 0.0, y: 0.0, z: 0.0}, {x: 0.0, y: 0.0, z: -1.0}, {x: 0.0, y: 1.0, z: 0.0});
	}
}
