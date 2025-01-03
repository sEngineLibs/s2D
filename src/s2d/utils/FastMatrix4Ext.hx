package s2d.utils;

import kha.FastFloat;
import kha.math.FastVector3;
import kha.math.FastMatrix4;

using s2d.utils.FastMatrix4Ext;

class FastMatrix4Ext {
	public static inline function getTranslationX(m:FastMatrix4) {
		return m._30;
	}

	public static inline function setTranslationX(m:FastMatrix4, value:FastFloat) {
		m._30 = value;
	}

	public static inline function getTranslationY(m:FastMatrix4) {
		return m._31;
	}

	public static inline function setTranslationY(m:FastMatrix4, value:FastFloat) {
		m._31 = value;
	}

	public static inline function getTranslationZ(m:FastMatrix4) {
		return m._32;
	}

	public static inline function setTranslationZ(m:FastMatrix4, value:FastFloat) {
		m._32 = value;
	}

	public static inline function getTranslation(m:FastMatrix4):FastVector3 {
		return {
			x: m.getTranslationX(),
			y: m.getTranslationY(),
			z: m.getTranslationZ()
		};
	}

	public static inline function setTranslation(m:FastMatrix4, value:FastVector3):Void {
		m.setTranslationX(value.x);
		m.setTranslationY(value.y);
		m.setTranslationZ(value.z);
	}

	public static inline function getScaleX(m:FastMatrix4):FastFloat {
		return Math.sqrt(m._00 * m._00 + m._10 * m._10 + m._20 * m._20);
	}

	public static inline function setScaleX(m:FastMatrix4, value:FastFloat) {
		var sx = m.getScaleX();
		m._00 *= value / sx;
		m._10 *= value / sx;
		m._20 *= value / sx;
	}

	public static inline function getScaleY(m:FastMatrix4):FastFloat {
		return Math.sqrt(m._01 * m._01 + m._11 * m._11 + m._21 * m._21);
	}

	public static inline function setScaleY(m:FastMatrix4, value:FastFloat) {
		var sy = m.getScaleY();
		m._01 *= value / sy;
		m._11 *= value / sy;
		m._21 *= value / sy;
	}

	public static inline function getScaleZ(m:FastMatrix4):FastFloat {
		return Math.sqrt(m._02 * m._02 + m._12 * m._12 + m._22 * m._22);
	}

	public static inline function setScaleZ(m:FastMatrix4, value:FastFloat):Void {
		var sz = m.getScaleZ();
		m._02 *= value / sz;
		m._12 *= value / sz;
		m._22 *= value / sz;
	}

	public static inline function getScale(m:FastMatrix4):FastVector3 {
		return {
			x: m.getScaleX(),
			y: m.getScaleY(),
			z: m.getScaleZ()
		};
	}

	public static inline function setScale(m:FastMatrix4, value:FastVector3):Void {
		m.setScaleX(value.x);
		m.setScaleY(value.y);
		m.setScaleZ(value.z);
	}

	public static inline function getRotation(m:FastMatrix4):FastFloat {
		return Math.atan2(m._10, m._00) * 180 / Math.PI;
	}

	public static inline function setRotation(m:FastMatrix4, value:FastFloat):Void {
		var angle = value * Math.PI / 180;
		var sx = getScaleX(m);
		var sy = getScaleY(m);
		var ca = Math.cos(angle);
		var cs = Math.sin(angle);

		m._00 = ca * sx;
		m._10 = cs * sx;
		m._01 = -cs * sy;
		m._11 = ca * sy;
	}

	public static inline function rotate(m:FastMatrix4, angle:FastFloat):Void {
		m.setRotation(m.getRotation() + angle);
	}

	public static inline function scale(m:FastMatrix4, x:FastFloat, y:FastFloat):Void {
		m.setScaleX(m.getScaleX() * x);
		m.setScaleY(m.getScaleY() * y);
	}

	public static inline function translate(m:FastMatrix4, x:FastFloat, y:FastFloat, ?z:FastFloat = 0):Void {
		m.setTranslationX(m.getTranslationX() + x);
		m.setTranslationY(m.getTranslationY() + y);
		m.setTranslationZ(m.getTranslationZ() + z);
	}
}
