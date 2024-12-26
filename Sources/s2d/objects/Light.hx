package s2d.objects;

import kha.FastFloat;
import kha.Color;

class Light extends Object {
	public var color:Color = Color.White;
	public var power:FastFloat = 1;
	public var radius:FastFloat = 0;

	public inline function new() {
		super();
		S2D.stage.lights.push(this);
	}
}
