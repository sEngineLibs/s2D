package s2d.geometry;

import kha.FastFloat;
import kha.math.FastMatrix4;

@:structInit
enum abstract TransformationMatrix(FastMatrix4) from FastMatrix4 to FastMatrix4 {
	public static var Identity:TransformationMatrix = FastMatrix4.identity();

	inline function new(value:FastMatrix4) {
		this = value;
	}

	public var matrix(get, set):FastMatrix4;

	inline function get_matrix() {
		return this;
	}

	inline function set_matrix(value:FastMatrix4) {
		this = value;
		return value;
	}

	public inline function rotate(pitch:FastFloat, yaw:FastFloat, roll:FastFloat):Void {
		this = this.multmat(FastMatrix4.rotation(yaw, pitch, roll));
	}

	public inline function scale(x:FastFloat, y:FastFloat, ?z:FastFloat = 1):Void {
		this = this.multmat(FastMatrix4.scale(x, y, z));
	}

	public inline function translate(x:FastFloat, y:FastFloat, ?z:FastFloat = 0):Void {
		this = this.multmat(FastMatrix4.translation(x, y, z));
	}

	public var rotationX(get, set):FastFloat;
	public var rotationY(get, set):FastFloat;
	public var rotationZ(get, set):FastFloat;
	public var scaleX(get, set):FastFloat;
	public var scaleY(get, set):FastFloat;
	public var scaleZ(get, set):FastFloat;
	public var translationX(get, set):FastFloat;
	public var translationY(get, set):FastFloat;
	public var translationZ(get, set):FastFloat;

	inline function get_rotationX() {
		return this._01;
	}

	inline function set_rotationX(value:FastFloat):FastFloat {
		this._01 = value;
		return value;
	}

	inline function get_rotationY() {
		return this._12;
	}

	inline function set_rotationY(value:FastFloat):FastFloat {
		this._12 = value;
		return value;
	}

	inline function get_rotationZ() {
		return this._23;
	}

	inline function set_rotationZ(value:FastFloat):FastFloat {
		this._23 = value;
		return value;
	}

	inline function get_scaleX() {
		return this._00;
	}

	inline function set_scaleX(value:FastFloat):FastFloat {
		this._00 = value;
		return value;
	}

	inline function get_scaleY() {
		return this._11;
	}

	inline function set_scaleY(value:FastFloat):FastFloat {
		this._11 = value;
		return value;
	}

	inline function get_scaleZ() {
		return this._22;
	}

	inline function set_scaleZ(value:FastFloat):FastFloat {
		this._22 = value;
		return value;
	}

	inline function get_translationX() {
		return this._03;
	}

	inline function set_translationX(value:FastFloat):FastFloat {
		this._03 = value;
		return value;
	}

	inline function get_translationY() {
		return this._13;
	}

	inline function set_translationY(value:FastFloat):FastFloat {
		this._13 = value;
		return value;
	}

	inline function get_translationZ() {
		return this._23;
	}

	inline function set_translationZ(value:FastFloat):FastFloat {
		this._23 = value;
		return value;
	}
}
