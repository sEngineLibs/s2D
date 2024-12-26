package s2d.objects;

import kha.FastFloat;
import kha.math.FastMatrix4;
// s2d
import s2d.geometry.Transformation;

class Object {
	@:isVar public var parent(default, null):Object = null;
	@:isVar public var children(default, null):Array<Object> = [];
	public var x:FastFloat = 0.0;
	public var y:FastFloat = 0.0;
	public var z:FastFloat = 0.0;
	public var transformation:Transformation = FastMatrix4.identity();
	public var finalTransformation(get, never):Transformation;

	public inline function new() {}

	public inline function setParent(value:Object):Void {
		if (parent == value)
			return;

		removeParent();

		if (value != null) {
			if (!value.children.contains(this))
				value.addChild(this);
			parent = value;
		}
	}

	public inline function removeParent():Void {
		if (parent != null)
			parent.removeChild(this);
		parent = null;
	}

	public inline function addChild(value:Object):Void {
		if (value == null || value == this)
			return;

		if (!children.contains(value)) {
			children.push(value);
			value.setParent(this);
		}
	}

	public inline function removeChild(value:Object):Void {
		if (value != null && children.remove(value))
			value.removeParent();
	}

	inline function get_finalTransformation():Transformation {
		return parent == null ? transformation : parent.finalTransformation.multmat(transformation);
	}
}
