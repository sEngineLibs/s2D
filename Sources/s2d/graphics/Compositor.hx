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
	public var filter(get, set):FastMatrix3;

	public inline function new() {
		params = new Float32Array(13);

		distortion = 0.0;
		distortionPosition = {x: 0.5, y: 0.5};
		vignetteStrength = 0.0;
		filter = Filter.NoFilter;
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

	inline function get_filter():FastMatrix3 {
		return new FastMatrix3(params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12]);
	}

	inline function set_filter(value:FastMatrix3):FastMatrix3 {
		params[4] = value._00;
		params[5] = value._01;
		params[6] = value._02;
		params[7] = value._10;
		params[8] = value._11;
		params[9] = value._12;
		params[10] = value._20;
		params[11] = value._21;
		params[12] = value._22;
		return value;
	}
}
