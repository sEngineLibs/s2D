package s2d.graphics;

#if S2D_PP_COMPOSITOR
import kha.Color;
import kha.FastFloat;
import kha.arrays.Float32Array;

@:allow(s2d.graphics.RenderPath)
class Compositor {
	var params:Float32Array;

	public var letterBoxHeight:Int = 0;
	public var letterBoxColor:Color = Black;
	public var vignetteStrength(get, set):FastFloat;
	public var posterizeGamma(get, set):FastFloat;
	public var posterizeSteps(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(3);

		vignetteStrength = 0.0;
		posterizeGamma = 1.0;
		posterizeSteps = 255.0;
	}

	inline function get_vignetteStrength():FastFloat {
		return params[0];
	}

	inline function set_vignetteStrength(value:FastFloat):FastFloat {
		params[0] = value;
		return value;
	}

	inline function get_posterizeGamma():FastFloat {
		return params[1];
	}

	inline function set_posterizeGamma(value:FastFloat):FastFloat {
		params[1] = value;
		return value;
	}

	inline function get_posterizeSteps():FastFloat {
		return params[2];
	}

	inline function set_posterizeSteps(value:FastFloat):FastFloat {
		params[2] = value;
		return value;
	}
}
#end
