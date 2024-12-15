package s2d;

import kha.Canvas;
// s2d
import s2d.objects.Object;
import s2d.objects.Sprite;
import s2d.objects.Light;

using score.utils.ArrayExt;

@:allow(s2d.graphics.RenderPath)
class S2D {
	var lights:Array<Light> = [];
	var sprites:Array<Sprite> = [];

	public function new() {}

	public inline function add(object:Object) {
		if (object is Sprite) {
			var sprite:Sprite = cast object;
			sprites.push(sprite);
		} else if (object is Light)
			lights.push(cast object);
	}

	public inline function update() {};

	public inline function draw(target:Canvas) {
		for (sprite in sprites)
			sprite.draw(target);
	}
}
