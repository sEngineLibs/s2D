package s2d.geometry;

import kha.FastFloat;

abstract OrthogonalProjection(TransformationMatrix) from TransformationMatrix to TransformationMatrix {
	inline function new(value:TransformationMatrix) {
		this = value;
	}

	public var transformation(get, set):TransformationMatrix;

	inline function get_transformation() {
		return this;
	}

	inline function set_transformation(value:TransformationMatrix) {
		this = value;
		return value;
	}

	public inline function setAspectRatio(value:FastFloat) {
		if (value >= 1)
			this.scale(1 / this.scaleX / value, 1, 1);
		else
			this.scale(1, value / this.scaleY, 1);
	}
}
