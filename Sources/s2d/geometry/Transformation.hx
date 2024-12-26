package s2d.geometry;

import kha.FastFloat;
import kha.math.FastMatrix4;

abstract Transformation(FastMatrix4) from FastMatrix4 to FastMatrix4 {
	public var translationX(get, set):FastFloat;
	public var translationY(get, set):FastFloat;
	public var translationZ(get, set):FastFloat;
	public var scaleX(get, set):FastFloat;
	public var scaleY(get, set):FastFloat;
	public var rotation(get, set):FastFloat;

	inline function new(value:FastMatrix4) {
		this = value;
	}

	public inline function multmat(value:FastMatrix4) {
		return this.multmat(value);
	}

	inline function get_translationX():FastFloat {
		return this._30;
	}

	inline function set_translationX(value:FastFloat):FastFloat {
		this._30 = value;
		return value;
	}

	inline function get_translationY():FastFloat {
		return this._31;
	}

	inline function set_translationY(value:FastFloat):FastFloat {
		this._31 = value;
		return value;
	}

	inline function get_translationZ():FastFloat {
		return this._32;
	}

	inline function set_translationZ(value:FastFloat):FastFloat {
		this._32 = value;
		return value;
	}

	inline function get_scaleX():FastFloat {
		return Math.sqrt(this._00 * this._00 + this._10 * this._10);
	}

	inline function set_scaleX(value:FastFloat):FastFloat {
		var sx = Math.sqrt(this._00 * this._00 + this._10 * this._10);
		if (sx != 0) {
			this._00 *= value / sx;
			this._10 *= value / sx;
		} else {
			this._00 = value;
			this._10 = 0;
		}
		return value;
	}

	inline function get_scaleY():FastFloat {
		return Math.sqrt(this._01 * this._01 + this._11 * this._11);
	}

	inline function set_scaleY(value:FastFloat):FastFloat {
		var sy = scaleY;
		if (sy != 0) {
			this._01 *= value / sy;
			this._11 *= value / sy;
		} else {
			this._01 = 0;
			this._11 = value;
		}
		return value;
	}

	inline function get_rotation():FastFloat {
		return Math.atan2(this._10, this._00) * 180 / Math.PI;
	}

	inline function set_rotation(value:FastFloat):FastFloat {
		var angle = value * Math.PI / 180;
		var sx = scaleX;
		var sy = scaleY;
		var ca = Math.cos(angle);
		var cs = Math.sin(angle);

		this._00 = ca * sx;
		this._10 = cs * sx;
		this._01 = -cs * sy;
		this._11 = ca * sy;

		return value;
	}

	public inline function rotate(angle:FastFloat):Void {
		rotation += angle;
	}

	public inline function scale(x:FastFloat, y:FastFloat):Void {
		scaleX *= x;
		scaleY *= y;
	}

	public inline function translate(x:FastFloat, y:FastFloat, ?z:FastFloat = 0):Void {
		translationX += x;
		translationY += y;
		translationZ += z;
	}
}
