package s2d.objects;

import kha.FastFloat;
import kha.math.FastVector2;

@:structInit
@:autoBuild(score.macro.SMacro.build())
class Object {
	var stage:S2D = null;

	@:isVar public var x(default, set):FastFloat = 0.0;
	@:isVar public var y(default, set):FastFloat = 0.0;
	@:isVar public var z(default, set):FastFloat = 0.0;
	public var origin:FastVector2 = {};
	public var parent:Object = null;
	public var children:Array<Object> = [];

	public inline function new(?stage:S2D) {
		if (stage != null)
			stage.add(this);

		this.stage = stage;
	}

	function set_x(value:FastFloat):FastFloat {
		for (c in children)
			c.x += value - x;
		x = value;
		return value;
	}

	function set_y(value:FastFloat):FastFloat {
		for (c in children)
			c.y += value - y;
		y = value;
		return value;
	}

	function set_z(value:FastFloat):FastFloat {
		for (c in children)
			c.z += value - z;
		z = value;
		return value;
	}

	public function rotate(angle:FastFloat) {
		for (c in children)
			c.rotate(angle);
	}

	public function scale(x:FastFloat, y:FastFloat) {
		for (c in children)
			c.scale(x, y);
	}

	public function translate(x:FastFloat, y:FastFloat) {
		for (c in children)
			c.translate(x, y);
	}

	public function addChild(child:Object) {
		children.push(child);
		child.parent = this;
	}

	public function removeChild(child:Object) {
		var index = children.indexOf(child);
		if (index != -1) {
			children.splice(index, 1);
			child.parent = null;
		}
	}

	public function removeChildren() {
		for (child in children)
			child.parent = null;

		children = [];
	}

	public function setParent(parent:Object) {
		parent.addChild(this);
	}

	public function removeParent() {
		parent.removeChild(this);
	}
}
