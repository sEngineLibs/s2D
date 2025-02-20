package se.animation;

import se.math.Mat3;
import se.math.VectorMath.mix;

class Transform2DAnimation extends Animation<Mat3> {
	function update(t:Float) {
		return new Mat3(mix(from._00, to._00, t), mix(from._01, to._01, t), mix(from._02, to._02, t), mix(from._10, to._10, t), mix(from._11, to._11, t),
			mix(from._12, to._12, t), mix(from._20, to._20, t), mix(from._21, to._21, t), mix(from._22, to._22, t));
	}
}
