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

	public var blendMode(get, set):BlendMode;
	public var depthScale(get, set):FastFloat;
	public var glowStrength(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(3);
		blendMode = AlphaBlend;
		depthScale = 0.0;
		glowStrength = 1.0;
	}

	inline function get_blendMode():BlendMode {
		return Std.int(params[0]);
	}

	inline function set_blendMode(value:BlendMode):BlendMode {
		params[0] = value;
		return value;
	}

	inline function get_depthScale():FastFloat {
		return params[1];
	}

	inline function set_depthScale(value:FastFloat):FastFloat {
		params[1] = value;
		return value;
	}

	inline function get_glowStrength():FastFloat {
		return params[2];
	}

	inline function set_glowStrength(value:FastFloat):FastFloat {
		params[2] = value;
		return value;
	}
}
