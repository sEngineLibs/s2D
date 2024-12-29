package s2d.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.arrays.Float32Array;

@:allow(s2d.graphics.RenderPath)
class Compositor {
	var params:Float32Array;

	public var letterBoxHeight:Int = 0;
	public var letterBoxColor:Color = Black;
	public var vignetteStrength(get, set):FastFloat;
	public var distortionPosition(get, set):FastVector2;
	public var distortionStrength(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(4);

		distortionPosition = {x: 0.5, y: 0.5};
		distortionStrength = 1.0;
		vignetteStrength = 0.0;
	}

	inline function get_distortionPosition():FastVector2 {
		return {
			x: params[0],
			y: params[1]
		};
	}

	inline function set_distortionPosition(value:FastVector2):FastVector2 {
		params[0] = value.x;
		params[1] = value.y;
		return value;
	}

	inline function get_distortionStrength():FastFloat {
		return params[2];
	}

	inline function set_distortionStrength(value:FastFloat):FastFloat {
		params[2] = value;
		return value;
	}

	inline function get_vignetteStrength():FastFloat {
		return params[3];
	}

	inline function set_vignetteStrength(value:FastFloat):FastFloat {
		params[3] = value;
		return value;
	}
}
