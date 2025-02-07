package se.math;

import kha.FastFloat;
import kha.math.FastVector3;
#if macro
import haxe.macro.Expr.ExprOf;
#end

@:nullSafety
#if !macro @:build(se.math.VectorMath.Swizzle.generateFields(3)) #end
abstract Vec3(FastVector3) from FastVector3 to FastVector3 {
	#if !macro
	public var x(get, set):FastFloat;

	inline function get_x()
		return this.x;

	inline function set_x(v:FastFloat)
		return this.x = v;

	public var y(get, set):FastFloat;

	inline function get_y()
		return this.y;

	inline function set_y(v:FastFloat)
		return this.y = v;

	public var z(get, set):FastFloat;

	inline function get_z()
		return this.z;

	inline function set_z(v:FastFloat)
		return this.z = v;

	public inline function new(x:FastFloat, y:FastFloat, z:FastFloat) {
		this = new FastVector3(x, y, z);
	}

	@:to
	public inline function toVec3I():Vec3I {
		return Vec3I.fromVec3(this);
	}

	public inline function set(x:FastFloat, y:FastFloat, z:FastFloat) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function clone() {
		return new Vec3(x, y, z);
	}

	// special case for vec3
	public inline function cross(b:Vec3)
		return new Vec3(y * b.z - z * b.y, z * b.x - x * b.z, x * b.y - y * b.x);

	// Trigonometric
	public inline function radians():Vec3 {
		return (this : Vec3) * Math.PI / 180;
	}

	public inline function degrees():Vec3 {
		return (this : Vec3) * 180 / Math.PI;
	}

	public inline function sin():Vec3 {
		return new Vec3(Math.sin(x), Math.sin(y), Math.sin(z));
	}

	public inline function cos():Vec3 {
		return new Vec3(Math.cos(x), Math.cos(y), Math.cos(z));
	}

	public inline function tan():Vec3 {
		return new Vec3(Math.tan(x), Math.tan(y), Math.tan(z));
	}

	public inline function asin():Vec3 {
		return new Vec3(Math.asin(x), Math.asin(y), Math.asin(z));
	}

	public inline function acos():Vec3 {
		return new Vec3(Math.acos(x), Math.acos(y), Math.acos(z));
	}

	public inline function atan():Vec3 {
		return new Vec3(Math.atan(x), Math.atan(y), Math.atan(z));
	}

	public inline function atan2(b:Vec3):Vec3 {
		return new Vec3(Math.atan2(x, b.x), Math.atan2(y, b.y), Math.atan2(z, b.z));
	}

	// Exponential
	public inline function pow(e:Vec3):Vec3 {
		return new Vec3(Math.pow(x, e.x), Math.pow(y, e.y), Math.pow(z, e.z));
	}

	public inline function exp():Vec3 {
		return new Vec3(Math.exp(x), Math.exp(y), Math.exp(z));
	}

	public inline function log():Vec3 {
		return new Vec3(Math.log(x), Math.log(y), Math.log(z));
	}

	public inline function exp2():Vec3 {
		return new Vec3(Math.pow(2, x), Math.pow(2, y), Math.pow(2, z));
	}

	public inline function log2():Vec3 @:privateAccess {
		return new Vec3(VectorMath.log2f(x), VectorMath.log2f(y), VectorMath.log2f(z));
	}

	public inline function sqrt():Vec3 {
		return new Vec3(Math.sqrt(x), Math.sqrt(y), Math.sqrt(z));
	}

	public inline function inverseSqrt():Vec3 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs():Vec3 {
		return new Vec3(Math.abs(x), Math.abs(y), Math.abs(z));
	}

	public inline function sign():Vec3 {
		return new Vec3(x > 0.?1.:(x < 0.? -1.:0.), y > 0.?1.:(y < 0.? -1.:0.), z > 0.?1.:(z < 0.? -1.:0.));
	}

	public inline function floor():Vec3 {
		return new Vec3(Math.floor(x), Math.floor(y), Math.floor(z));
	}

	public inline function ceil():Vec3 {
		return new Vec3(Math.ceil(x), Math.ceil(y), Math.ceil(z));
	}

	public inline function fract():Vec3 {
		return (this : Vec3) - floor();
	}

	public extern overload inline function mod(d:Vec3):Vec3 {
		return (this : Vec3) - d * ((this : Vec3) / d).floor();
	}

	public extern overload inline function mod(d:FastFloat):Vec3 {
		return (this : Vec3) - d * ((this : Vec3) / d).floor();
	}

	public extern overload inline function min(b:Vec3):Vec3 {
		return new Vec3(b.x < x ? b.x : x, b.y < y ? b.y : y, b.z < z ? b.z : z);
	}

	public extern overload inline function min(b:FastFloat):Vec3 {
		return new Vec3(b < x ? b : x, b < y ? b : y, b < z ? b : z);
	}

	public extern overload inline function max(b:Vec3):Vec3 {
		return new Vec3(x < b.x ? b.x : x, y < b.y ? b.y : y, z < b.z ? b.z : z);
	}

	public extern overload inline function max(b:FastFloat):Vec3 {
		return new Vec3(x < b ? b : x, y < b ? b : y, z < b ? b : z);
	}

	public extern overload inline function clamp(minLimit:Vec3, maxLimit:Vec3) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function clamp(minLimit:FastFloat, maxLimit:FastFloat) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b:Vec3, t:Vec3):Vec3 {
		return (this : Vec3) * (1.0 - t) + b * t;
	}

	public extern overload inline function mix(b:Vec3, t:FastFloat):Vec3 {
		return (this : Vec3) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge:Vec3):Vec3 {
		return new Vec3(x < edge.x ? 0.0 : 1.0, y < edge.y ? 0.0 : 1.0, z < edge.z ? 0.0 : 1.0);
	}

	public extern overload inline function step(edge:FastFloat):Vec3 {
		return new Vec3(x < edge ? 0.0 : 1.0, y < edge ? 0.0 : 1.0, z < edge ? 0.0 : 1.0);
	}

	public extern overload inline function smoothstep(edge0:Vec3, edge1:Vec3):Vec3 {
		var t = (((this : Vec3) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	public extern overload inline function smoothstep(edge0:FastFloat, edge1:FastFloat):Vec3 {
		var t = (((this : Vec3) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length():FastFloat {
		return Math.sqrt(x * x + y * y + z * z);
	}

	public inline function distance(b:Vec3):FastFloat {
		return (b - this).length();
	}

	public inline function dot(b:Vec3):FastFloat {
		return x * b.x + y * b.y + z * b.z;
	}

	public inline function normalize():Vec3 {
		var v:Vec3 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I:Vec3, Nref:Vec3):Vec3 {
		return new Vec3(x, y, z) * (Nref.dot(I) < 0 ? 1 : -1);
	}

	public inline function reflect(N:Vec3):Vec3 {
		var I = (this : Vec3);
		return I - 2 * N.dot(I) * N;
	}

	public inline function refract(N:Vec3, eta:FastFloat):Vec3 {
		var I = (this : Vec3);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return (eta * I - (eta * nDotI + Math.sqrt(k)) * N) * (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec3(${x}, ${y}, ${z})';
	}

	@:op([])
	inline function arrayRead(i:Int)
		return switch i {
			case 0: x;
			case 1: y;
			case 2: z;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i:Int, v:FastFloat)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			case 2: z = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a:Vec3)
		return new Vec3(-a.x, -a.y, -a.z);

	@:op(++a)
	static inline function prefixIncrement(a:Vec3) {
		++a.x;
		++a.y;
		++a.z;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a:Vec3) {
		--a.x;
		--a.y;
		--a.z;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a:Vec3) {
		var ret = a.clone();
		++a.x;
		++a.y;
		++a.z;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a:Vec3) {
		var ret = a.clone();
		--a.x;
		--a.y;
		--a.z;
		return ret;
	}

	@:op(a * b)
	static inline function mul(a:Vec3, b:Vec3):Vec3
		return new Vec3(a.x * b.x, a.y * b.y, a.z * b.z);

	@:op(a * b) @:commutative
	static inline function mulScalar(a:Vec3, b:FastFloat):Vec3
		return new Vec3(a.x * b, a.y * b, a.z * b);

	@:op(a / b)
	static inline function div(a:Vec3, b:Vec3):Vec3
		return new Vec3(a.x / b.x, a.y / b.y, a.z / b.z);

	@:op(a / b)
	static inline function divScalar(a:Vec3, b:FastFloat):Vec3
		return new Vec3(a.x / b, a.y / b, a.z / b);

	@:op(a / b)
	static inline function divScalarInv(a:FastFloat, b:Vec3):Vec3
		return new Vec3(a / b.x, a / b.y, a / b.z);

	@:op(a + b)
	static inline function add(a:Vec3, b:Vec3):Vec3
		return new Vec3(a.x + b.x, a.y + b.y, a.z + b.z);

	@:op(a + b) @:commutative
	static inline function addScalar(a:Vec3, b:FastFloat):Vec3
		return new Vec3(a.x + b, a.y + b, a.z + b);

	@:op(a - b)
	static inline function sub(a:Vec3, b:Vec3):Vec3
		return new Vec3(a.x - b.x, a.y - b.y, a.z - b.z);

	@:op(a - b)
	static inline function subScalar(a:Vec3, b:FastFloat):Vec3
		return new Vec3(a.x - b, a.y - b, a.z - b);

	@:op(b - a)
	static inline function subScalarInv(a:FastFloat, b:Vec3):Vec3
		return new Vec3(a - b.x, a - b.y, a - b.z);

	@:op(a == b)
	static inline function equal(a:Vec3, b:Vec3):Bool
		return a.x == b.x && a.y == b.y && a.z == b.z;

	@:op(a != b)
	static inline function notEqual(a:Vec3, b:Vec3):Bool
		return !equal(a, b);
	#end // !macro

	// macros

	/**
	 * Copy from any object with .x .y .z fields
	 */
	@:overload(function(source:{x:FastFloat, y:FastFloat, z:FastFloat}):Vec3 {})
	public macro function copyFrom(self:ExprOf<Vec3>, source:ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}>):ExprOf<Vec3> {
		return macro {
			var self = $self;
			var source = $source;
			self.x = source.x;
			self.y = source.y;
			self.z = source.z;
			self;
		}
	}

	/**
	 * Copy into any object with .x .y .z fields
	 */
	@:overload(function(target:{x:FastFloat, y:FastFloat, z:FastFloat}):{x:FastFloat, y:FastFloat, z:FastFloat} {})
	public macro function copyInto(self:ExprOf<Vec3>, target:ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}>):ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}> {
		return macro {
			var self = $self;
			var target = $target;
			target.x = self.x;
			target.y = self.y;
			target.z = self.z;
			target;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyIntoArray(self:ExprOf<Vec3>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array[2 + i] = self.z;
			array;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyFromArray(self:ExprOf<Vec3>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			self.x = array[0 + i];
			self.y = array[1 + i];
			self.z = array[2 + i];
			self;
		}
	}

	// static macros

	/**
	 * Create from any object with .x .y .z fields
	 */
	@:overload(function(source:{x:FastFloat, y:FastFloat, z:FastFloat}):Vec3 {})
	public static macro function from(xyz:ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}>):ExprOf<Vec3> {
		return macro {
			var source = $xyz;
			new Vec3(source.x, source.y, source.z);
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public static macro function fromArray(array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>):ExprOf<Vec3> {
		return macro {
			var array = $array;
			var i:Int = $index;
			new Vec3(array[0 + i], array[1 + i], array[2 + i]);
		}
	}
}
