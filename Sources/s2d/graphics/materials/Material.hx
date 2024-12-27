package s2d.graphics.materials;

import kha.Image;
import kha.Assets;
import kha.FastFloat;
import kha.arrays.Float32Array;

class Material {
	public var colorMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	public var glowMap:Image;
	public var attrib:Float32Array;

	public var blendMode(get, set):BlendMode;
	public var depthScale(get, set):FastFloat;
	public var glowStrength(get, set):FastFloat;

	public inline function new() {
		attrib = new Float32Array(3);
		blendMode = AlphaBlend;
		depthScale = 0.0;
		glowStrength = 1.0;

		colorMap = Assets.images.get("color_default");
		normalMap = Assets.images.get("normal_default");
		ormMap = Assets.images.get("orm_default");
		glowMap = Assets.images.get("glow_default");
	}

	inline function get_blendMode():BlendMode {
		return Std.int(attrib[0]);
	}

	inline function set_blendMode(value:BlendMode):BlendMode {
		attrib[0] = value;
		return value;
	}

	inline function get_depthScale():FastFloat {
		return attrib[1];
	}

	inline function set_depthScale(value:FastFloat):FastFloat {
		attrib[1] = value;
		return value;
	}

	inline function get_glowStrength():FastFloat {
		return attrib[2];
	}

	inline function set_glowStrength(value:FastFloat):FastFloat {
		attrib[2] = value;
		return value;
	}
}
