package s2d.math;

import kha.FastFloat;
import kha.math.FastVector4;
#if macro
import haxe.macro.Expr.ExprOf;
#end

@:nullSafety
#if !macro @:build(s2d.math.VectorMath.Swizzle.generateFields(4)) #end
abstract Vec4(FastVector4) from FastVector4 to FastVector4 {
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

	public var w(get, set):FastFloat;

	inline function get_w()
		return this.w;

	inline function set_w(v:FastFloat)
		return this.w = v;

	public inline function new(x:FastFloat, y:FastFloat, z:FastFloat, w:FastFloat) {
		this = new FastVector4(x, y, z, w);
	}

	@:to
	public inline function toVec4I():Vec4I {
		return Vec4I.fromVec4(this);
	}

	public inline function set(x:FastFloat, y:FastFloat, z:FastFloat, w:FastFloat) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function clone() {
		return new Vec4(x, y, z, w);
	}

	// Trigonometric
	public inline function radians():Vec4 {
		return (this : Vec4) * Math.PI / 180;
	}

	public inline function degrees():Vec4 {
		return (this : Vec4) * 180 / Math.PI;
	}

	public inline function sin():Vec4 {
		return new Vec4(Math.sin(x), Math.sin(y), Math.sin(z), Math.sin(w));
	}

	public inline function cos():Vec4 {
		return new Vec4(Math.cos(x), Math.cos(y), Math.cos(z), Math.cos(w));
	}

	public inline function tan():Vec4 {
		return new Vec4(Math.tan(x), Math.tan(y), Math.tan(z), Math.tan(w));
	}

	public inline function asin():Vec4 {
		return new Vec4(Math.asin(x), Math.asin(y), Math.asin(z), Math.asin(w));
	}

	public inline function acos():Vec4 {
		return new Vec4(Math.acos(x), Math.acos(y), Math.acos(z), Math.acos(w));
	}

	public inline function atan():Vec4 {
		return new Vec4(Math.atan(x), Math.atan(y), Math.atan(z), Math.atan(w));
	}

	public inline function atan2(b:Vec4):Vec4 {
		return new Vec4(Math.atan2(x, b.x), Math.atan2(y, b.y), Math.atan2(z, b.z), Math.atan2(w, b.w));
	}

	// Exponential
	public inline function pow(e:Vec4):Vec4 {
		return new Vec4(Math.pow(x, e.x), Math.pow(y, e.y), Math.pow(z, e.z), Math.pow(w, e.w));
	}

	public inline function exp():Vec4 {
		return new Vec4(Math.exp(x), Math.exp(y), Math.exp(z), Math.exp(w));
	}

	public inline function log():Vec4 {
		return new Vec4(Math.log(x), Math.log(y), Math.log(z), Math.log(w));
	}

	public inline function exp2():Vec4 {
		return new Vec4(Math.pow(2, x), Math.pow(2, y), Math.pow(2, z), Math.pow(2, w));
	}

	public inline function log2():Vec4 @:privateAccess {
		return new Vec4(VectorMath.log2f(x), VectorMath.log2f(y), VectorMath.log2f(z), VectorMath.log2f(w));
	}

	public inline function sqrt():Vec4 {
		return new Vec4(Math.sqrt(x), Math.sqrt(y), Math.sqrt(z), Math.sqrt(w));
	}

	public inline function inverseSqrt():Vec4 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs():Vec4 {
		return new Vec4(Math.abs(x), Math.abs(y), Math.abs(z), Math.abs(w));
	}

	public inline function sign():Vec4 {
		return new Vec4(x > 0.?1.:(x < 0.? -1.:0.), y > 0.?1.:(y < 0.? -1.:0.), z > 0.?1.:(z < 0.? -1.:0.), w > 0.?1.:(w < 0.? -1.:0.));
	}

	public inline function floor():Vec4 {
		return new Vec4(Math.floor(x), Math.floor(y), Math.floor(z), Math.floor(w));
	}

	public inline function ceil():Vec4 {
		return new Vec4(Math.ceil(x), Math.ceil(y), Math.ceil(z), Math.ceil(w));
	}

	public inline function fract():Vec4 {
		return (this : Vec4) - floor();
	}

	public extern overload inline function mod(d:FastFloat):Vec4 {
		return (this : Vec4) - d * ((this : Vec4) / d).floor();
	}

	public extern overload inline function mod(d:Vec4):Vec4 {
		return (this : Vec4) - d * ((this : Vec4) / d).floor();
	}

	public extern overload inline function min(b:Vec4):Vec4 {
		return new Vec4(b.x < x ? b.x : x, b.y < y ? b.y : y, b.z < z ? b.z : z, b.w < w ? b.w : w);
	}

	public extern overload inline function min(b:FastFloat):Vec4 {
		return new Vec4(b < x ? b : x, b < y ? b : y, b < z ? b : z, b < w ? b : w);
	}

	public extern overload inline function max(b:Vec4):Vec4 {
		return new Vec4(x < b.x ? b.x : x, y < b.y ? b.y : y, z < b.z ? b.z : z, w < b.w ? b.w : w);
	}

	public extern overload inline function max(b:FastFloat):Vec4 {
		return new Vec4(x < b ? b : x, y < b ? b : y, z < b ? b : z, w < b ? b : w);
	}

	public extern overload inline function clamp(minLimit:Vec4, maxLimit:Vec4) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function clamp(minLimit:FastFloat, maxLimit:FastFloat) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b:Vec4, t:Vec4):Vec4 {
		return (this : Vec4) * (1.0 - t) + b * t;
	}

	public extern overload inline function mix(b:Vec4, t:FastFloat):Vec4 {
		return (this : Vec4) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge:Vec4):Vec4 {
		return new Vec4(x < edge.x ? 0.0 : 1.0, y < edge.y ? 0.0 : 1.0, z < edge.z ? 0.0 : 1.0, w < edge.w ? 0.0 : 1.0);
	}

	public extern overload inline function step(edge:FastFloat):Vec4 {
		return new Vec4(x < edge ? 0.0 : 1.0, y < edge ? 0.0 : 1.0, z < edge ? 0.0 : 1.0, w < edge ? 0.0 : 1.0);
	}

	public extern overload inline function smoothstep(edge0:Vec4, edge1:Vec4):Vec4 {
		var t = (((this : Vec4) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	public extern overload inline function smoothstep(edge0:FastFloat, edge1:FastFloat):Vec4 {
		var t = (((this : Vec4) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length():FastFloat {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}

	public inline function distance(b:Vec4):FastFloat {
		return (b - this).length();
	}

	public inline function dot(b:Vec4):FastFloat {
		return x * b.x + y * b.y + z * b.z + w * b.w;
	}

	public inline function normalize():Vec4 {
		var v:Vec4 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I:Vec4, Nref:Vec4):Vec4 {
		return new Vec4(x, y, z, w) * (Nref.dot(I) < 0 ? 1 : -1);
	}

	public inline function reflect(N:Vec4):Vec4 {
		var I = (this : Vec4);
		return I - 2 * N.dot(I) * N;
	}

	public inline function refract(N:Vec4, eta:FastFloat):Vec4 {
		var I = (this : Vec4);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return (eta * I - (eta * nDotI + Math.sqrt(k)) * N) * (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec4(${x}, ${y}, ${z}, ${w})';
	}

	@:op([])
	inline function arrayRead(i:Int)
		return switch i {
			case 0: x;
			case 1: y;
			case 2: z;
			case 3: w;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i:Int, v:FastFloat)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			case 2: z = v;
			case 3: w = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a:Vec4)
		return new Vec4(-a.x, -a.y, -a.z, -a.w);

	@:op(++a)
	static inline function prefixIncrement(a:Vec4) {
		++a.x;
		++a.y;
		++a.z;
		++a.w;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a:Vec4) {
		--a.x;
		--a.y;
		--a.z;
		--a.w;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a:Vec4) {
		var ret = a.clone();
		++a.x;
		++a.y;
		++a.z;
		++a.w;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a:Vec4) {
		var ret = a.clone();
		--a.x;
		--a.y;
		--a.z;
		--a.w;
		return ret;
	}

	@:op(a * b)
	static inline function mul(a:Vec4, b:Vec4):Vec4
		return new Vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);

	@:op(a * b) @:commutative
	static inline function mulScalar(a:Vec4, b:FastFloat):Vec4
		return new Vec4(a.x * b, a.y * b, a.z * b, a.w * b);

	@:op(a / b)
	static inline function div(a:Vec4, b:Vec4):Vec4
		return new Vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w);

	@:op(a / b)
	static inline function divScalar(a:Vec4, b:FastFloat):Vec4
		return new Vec4(a.x / b, a.y / b, a.z / b, a.w / b);

	@:op(a / b)
	static inline function divScalarInv(a:FastFloat, b:Vec4):Vec4
		return new Vec4(a / b.x, a / b.y, a / b.z, a / b.w);

	@:op(a + b)
	static inline function add(a:Vec4, b:Vec4):Vec4
		return new Vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);

	@:op(a + b) @:commutative
	static inline function addScalar(a:Vec4, b:FastFloat):Vec4
		return new Vec4(a.x + b, a.y + b, a.z + b, a.w + b);

	@:op(a - b)
	static inline function sub(a:Vec4, b:Vec4):Vec4
		return new Vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);

	@:op(a - b)
	static inline function subScalar(a:Vec4, b:FastFloat):Vec4
		return new Vec4(a.x - b, a.y - b, a.z - b, a.w - b);

	@:op(b - a)
	static inline function subScalarInv(a:FastFloat, b:Vec4):Vec4
		return new Vec4(a - b.x, a - b.y, a - b.z, a - b.w);

	@:op(a == b)
	static inline function equal(a:Vec4, b:Vec4):Bool
		return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w;

	@:op(a != b)
	static inline function notEqual(a:Vec4, b:Vec4):Bool
		return !equal(a, b);
	#end // !macro

	// macros

	/**
	 * Copy from any object with .x .y .z .w fields
	 */
	@:overload(function(source:{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	}):Vec4 {})
	public macro function copyFrom(self:ExprOf<Vec4>, source:ExprOf<{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	}>):ExprOf<Vec4> {
		return macro {
			var self = $self;
			var source = $source;
			self.x = source.x;
			self.y = source.y;
			self.z = source.z;
			self.w = source.w;
			self;
		}
	}

	/**
	 * Copy into any object with .x .y .z .w fields
	 */
	@:overload(function(target:{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	}):{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	} {})
	public macro function copyInto(self:ExprOf<Vec4>, target:ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}>):ExprOf<{x:FastFloat, y:FastFloat, z:FastFloat}> {
		return macro {
			var self = $self;
			var target = $target;
			target.x = self.x;
			target.y = self.y;
			target.z = self.z;
			target.w = self.w;
			target;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyIntoArray(self:ExprOf<Vec4>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array[2 + i] = self.z;
			array[3 + i] = self.w;
			array;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyFromArray(self:ExprOf<Vec4>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			self.x = array[0 + i];
			self.y = array[1 + i];
			self.z = array[2 + i];
			self.w = array[3 + i];
			self;
		}
	}

	// static macros

	/**
	 * Create from any object with .x .y .z .w fields
	 */
	@:overload(function(source:{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	}):Vec4 {})
	public static macro function from(xyzw:ExprOf<{
		x:FastFloat,
		y:FastFloat,
		z:FastFloat,
		w:FastFloat
	}>):ExprOf<Vec4> {
		return macro {
			var source = $xyzw;
			new Vec4(source.x, source.y, source.z, source.w);
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public static macro function fromArray(array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>):ExprOf<Vec4> {
		return macro {
			var array = $array;
			var i:Int = $index;
			new Vec4(array[0 + i], array[1 + i], array[2 + i], array[3 + i]);
		}
	}
}
