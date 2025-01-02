package s2d.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.math.FastMatrix3;
import kha.arrays.Float32Array;

@:allow(s2d.graphics.RenderPath)
class Compositor {
	var params:Float32Array;

	public var letterBoxHeight:Int = 0;
	public var letterBoxColor:Color = Black;
	public var vignetteStrength(get, set):FastFloat;
	public var distortionPosition(get, set):FastVector2;
	public var distortion(get, set):FastFloat;
	public var filter(get, set):Filter;
	public var posterizeGamma(get, set):FastFloat;
	public var posterizeSteps(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(15);

		distortion = 0.0;
		distortionPosition = {x: 0.5, y: 0.5};
		vignetteStrength = 0.0;
		filter = Filter.Identity;
		posterizeGamma = 1.0;
		posterizeSteps = 255.0;
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

	inline function get_distortion():FastFloat {
		return params[2];
	}

	inline function set_distortion(value:FastFloat):FastFloat {
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

	inline function get_filter():Filter {
		return new FastMatrix3(params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12]);
	}

	inline function set_filter(value:Filter):Filter {
		var f:FastMatrix3 = value;
		params[4] = f._00;
		params[5] = f._01;
		params[6] = f._02;
		params[7] = f._10;
		params[8] = f._11;
		params[9] = f._12;
		params[10] = f._20;
		params[11] = f._21;
		params[12] = f._22;
		return value;
	}

	inline function get_posterizeGamma():FastFloat {
		return params[13];
	}

	inline function set_posterizeGamma(value:FastFloat):FastFloat {
		params[13] = value;
		return value;
	}

	inline function get_posterizeSteps():FastFloat {
		return params[14];
	}

	inline function set_posterizeSteps(value:FastFloat):FastFloat {
		params[14] = value;
		return value;
	}
}
