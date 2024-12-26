package s2d.objects;

import kha.FastFloat;
import kha.math.FastMatrix4;

abstract Camera(FastMatrix4) from FastMatrix4 to FastMatrix4 {
	public inline function new(value:FastMatrix4) {
		this = value;
	}

	public static inline function create() {
		// [world position, look at, head up]
		return new Camera(FastMatrix4.lookAt({x: 0.0, y: 0.0, z: 0.0}, {x: 0.0, y: 0.0, z: 1.0}, {x: 0.0, y: -1.0, z: 0.0}));
	}

	public inline function rotate(angle:FastFloat) {
		this = this.multmat(FastMatrix4.rotationZ(angle * Math.PI / 180));
	}

	public inline function translate(x:FastFloat, y:FastFloat, ?z:FastFloat = 0.0) {
		this = this.multmat(FastMatrix4.translation(x, y, z));
	}
}
