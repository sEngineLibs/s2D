package s2d.graphics;

import kha.Color;
import kha.FastFloat;
import kha.arrays.Float32Array;

@:allow(s2d.graphics.RenderPath)
class PostProcessing {
	var params:Float32Array;

	public var dofDistance(get, set):FastFloat;
	public var dofSize(get, set):FastFloat;
	public var mistNear(get, set):FastFloat;
	public var mistFar(get, set):FastFloat;
	public var mistColor(get, set):Color;
	public var motionBlur(get, set):FastFloat;

	public inline function new() {
		params = new Float32Array(9);

		dofDistance = 0.5;
		dofSize = 0.0;
		mistNear = 0.0;
		mistFar = 1.0;
		mistColor = Transparent;
		motionBlur = 0.0;
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

	inline function get_mistNear():FastFloat {
		return params[2];
	}

	inline function set_mistNear(value:FastFloat):FastFloat {
		params[2] = value;
		return value;
	}

	inline function get_mistFar():FastFloat {
		return params[3];
	}

	inline function set_mistFar(value:FastFloat):FastFloat {
		params[3] = value;
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

	inline function get_motionBlur():FastFloat {
		return 1.0 - params[8];
	}

	inline function set_motionBlur(value:FastFloat):FastFloat {
		params[8] = 1.0 - value;
		return value;
	}
}
