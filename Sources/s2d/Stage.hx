package s2d;

import s2d.objects.Light;
import s2d.objects.Sprite;
import s2d.objects.Camera;

class Stage {
	public var sprites:Array<Sprite> = [];
	public var lights:Array<Light> = [];
	public var camera:Camera = Camera.create();

	public inline function new() {}
}
