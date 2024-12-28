package s2d.graphics;

import kha.Color;
import kha.FastFloat;
import kha.math.FastVector2;
import kha.arrays.Float32Array;

@:allow(s2d.graphics.RenderPath)
class PostProcessing {
	var params:Float32Array;

	public var dofDistance(get, set):FastFloat;
	public var dofSize(get, set):FastFloat;
	public var mistScale(get, set):FastVector2;
	public var mistColor(get, set):Color;

	public inline function new() {
		params = new Float32Array(8);

		dofDistance = 0.5;
		dofSize = 0.01;
		mistScale = {x: 0.0, y: 1.0};
		mistColor = Transparent;
	}

	inline function get_dofDistance():FastFloat {
		return params[0];
	}

	inline function set_dofDistance(value:FastFloat):FastFloat {
		params[0] = value;
		return value;
	}

	inline function get_dofSize():FastFloat {
		return params[1];
	}

	inline function set_dofSize(value:FastFloat):FastFloat {
		params[1] = value;
		return value;
	}

	inline function get_mistScale():FastVector2 {
		return {
			x: params[2],
			y: params[3]
		};
	}

	inline function set_mistScale(value:FastVector2):FastVector2 {
		params[2] = value.x;
		params[3] = value.y;
		return value;
	}

	inline function get_mistColor():Color {
		return Color.fromFloats(params[4], params[5], params[6], params[7]);
	}

	inline function set_mistColor(value:Color):Color {
		params[4] = value.R;
		params[5] = value.G;
		params[6] = value.B;
		params[7] = value.A;
		return value;
	}
}
