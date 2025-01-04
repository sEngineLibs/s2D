package s2d.graphics.materials;

import kha.Image;
import kha.FastFloat;
import kha.arrays.Float32Array;

class Material {
	public var colorMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	public var glowMap:Image;

	public var params:Float32Array;
	public var depthScale(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(1);
		depthScale = 1.0;
	}

	inline function get_depthScale():FastFloat {
		return params[0];
	}

	inline function set_depthScale(value:FastFloat):FastFloat {
		params[0] = value;
		return value;
	}
}
