package s2d.math;

import kha.FastFloat;
import kha.math.FastVector2;
#if macro
import haxe.macro.Expr.ExprOf;
#end

@:nullSafety
#if !macro @:build(s2d.math.VectorMath.Swizzle.generateFields(2)) #end
abstract Vec2(FastVector2) from FastVector2 to FastVector2 {
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

	public inline function new(x:FastFloat, y:FastFloat) {
		this = new FastVector2(x, y);
	}

	@:to
	public inline function toVec2I():Vec2I {
		return Vec2I.fromVec2(this);
	}

	public inline function set(x:FastFloat, y:FastFloat) {
		this.x = x;
		this.y = y;
	}

	public inline function clone() {
		return new Vec2(x, y);
	}

	// Trigonometric
	public inline function radians():Vec2 {
		return (this : Vec2) * Math.PI / 180;
	}

	public inline function degrees():Vec2 {
		return (this : Vec2) * 180 / Math.PI;
	}

	public inline function sin():Vec2 {
		return new Vec2(Math.sin(x), Math.sin(y));
	}

	public inline function cos():Vec2 {
		return new Vec2(Math.cos(x), Math.cos(y));
	}

	public inline function tan():Vec2 {
		return new Vec2(Math.tan(x), Math.tan(y));
	}

	public inline function asin():Vec2 {
		return new Vec2(Math.asin(x), Math.asin(y));
	}

	public inline function acos():Vec2 {
		return new Vec2(Math.acos(x), Math.acos(y));
	}

	public inline function atan():Vec2 {
		return new Vec2(Math.atan(x), Math.atan(y));
	}

	public inline function atan2(b:Vec2):Vec2 {
		return new Vec2(Math.atan2(x, b.x), Math.atan2(y, b.y));
	}

	// Exponential
	public inline function pow(e:Vec2):Vec2 {
		return new Vec2(Math.pow(x, e.x), Math.pow(y, e.y));
	}

	public inline function exp():Vec2 {
		return new Vec2(Math.exp(x), Math.exp(y));
	}

	public inline function log():Vec2 {
		return new Vec2(Math.log(x), Math.log(y));
	}

	public inline function exp2():Vec2 {
		return new Vec2(Math.pow(2, x), Math.pow(2, y));
	}

	public inline function log2():Vec2 @:privateAccess {
		return new Vec2(VectorMath.log2f(x), VectorMath.log2f(y));
	}

	public inline function sqrt():Vec2 {
		return new Vec2(Math.sqrt(x), Math.sqrt(y));
	}

	public inline function inverseSqrt():Vec2 {
		return 1.0 / sqrt();
	}

	// Common
	public inline function abs():Vec2 {
		return new Vec2(Math.abs(x), Math.abs(y));
	}

	public inline function sign():Vec2 {
		return new Vec2(x > 0.?1.:(x < 0.? -1.:0.), y > 0.?1.:(y < 0.? -1.:0.));
	}

	public inline function floor():Vec2 {
		return new Vec2(Math.floor(x), Math.floor(y));
	}

	public inline function ceil():Vec2 {
		return new Vec2(Math.ceil(x), Math.ceil(y));
	}

	public inline function fract():Vec2 {
		return (this : Vec2) - floor();
	}

	public extern overload inline function mod(d:Vec2):Vec2 {
		return (this : Vec2) - d * ((this : Vec2) / d).floor();
	}

	public extern overload inline function mod(d:FastFloat):Vec2 {
		return (this : Vec2) - d * ((this : Vec2) / d).floor();
	}

	public extern overload inline function min(b:Vec2):Vec2 {
		return new Vec2(b.x < x ? b.x : x, b.y < y ? b.y : y);
	}

	public extern overload inline function min(b:FastFloat):Vec2 {
		return new Vec2(b < x ? b : x, b < y ? b : y);
	}

	public extern overload inline function max(b:Vec2):Vec2 {
		return new Vec2(x < b.x ? b.x : x, y < b.y ? b.y : y);
	}

	public extern overload inline function max(b:FastFloat):Vec2 {
		return new Vec2(x < b ? b : x, y < b ? b : y);
	}

	public extern overload inline function clamp(minLimit:Vec2, maxLimit:Vec2) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function clamp(minLimit:FastFloat, maxLimit:FastFloat) {
		return max(minLimit).min(maxLimit);
	}

	public extern overload inline function mix(b:Vec2, t:Vec2):Vec2 {
		return (this : Vec2) * (1.0 - t) + b * t;
	}

	public extern overload inline function mix(b:Vec2, t:FastFloat):Vec2 {
		return (this : Vec2) * (1.0 - t) + b * t;
	}

	public extern overload inline function step(edge:Vec2):Vec2 {
		return new Vec2(x < edge.x ? 0.0 : 1.0, y < edge.y ? 0.0 : 1.0);
	}

	public extern overload inline function step(edge:FastFloat):Vec2 {
		return new Vec2(x < edge ? 0.0 : 1.0, y < edge ? 0.0 : 1.0);
	}

	public extern overload inline function smoothstep(edge0:Vec2, edge1:Vec2):Vec2 {
		var t = (((this : Vec2) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	public extern overload inline function smoothstep(edge0:FastFloat, edge1:FastFloat):Vec2 {
		var t = (((this : Vec2) - edge0) / (edge1 - edge0)).clamp(0, 1);
		return t * t * (3.0 - 2.0 * t);
	}

	// Geometric
	public inline function length():FastFloat {
		return Math.sqrt(x * x + y * y);
	}

	public inline function distance(b:Vec2):FastFloat {
		return (b - this).length();
	}

	public inline function dot(b:Vec2):FastFloat {
		return x * b.x + y * b.y;
	}

	public inline function normalize():Vec2 {
		var v:Vec2 = this;
		var lenSq = v.dot(this);
		var denominator = lenSq == 0.0 ? 1.0 : Math.sqrt(lenSq); // for 0 length, return zero vector rather than infinity
		return v / denominator;
	}

	public inline function faceforward(I:Vec2, Nref:Vec2):Vec2 {
		return new Vec2(x, y) * (Nref.dot(I) < 0 ? 1 : -1);
	}

	public inline function reflect(N:Vec2):Vec2 {
		var I = (this : Vec2);
		return I - 2 * N.dot(I) * N;
	}

	public inline function refract(N:Vec2, eta:FastFloat):Vec2 {
		var I = (this : Vec2);
		var nDotI = N.dot(I);
		var k = 1.0 - eta * eta * (1.0 - nDotI * nDotI);
		return (eta * I - (eta * nDotI + Math.sqrt(k)) * N) * (k < 0.0 ? 0.0 : 1.0); // if k < 0, result should be 0 vector
	}

	public inline function toString() {
		return 'vec2(${x}, ${y})';
	}

	@:op([])
	inline function arrayRead(i:Int)
		return switch i {
			case 0: x;
			case 1: y;
			default: null;
		}

	@:op([])
	inline function arrayWrite(i:Int, v:FastFloat)
		return switch i {
			case 0: x = v;
			case 1: y = v;
			default: null;
		}

	@:op(-a)
	static inline function neg(a:Vec2)
		return new Vec2(-a.x, -a.y);

	@:op(++a)
	static inline function prefixIncrement(a:Vec2) {
		++a.x;
		++a.y;
		return a.clone();
	}

	@:op(--a)
	static inline function prefixDecrement(a:Vec2) {
		--a.x;
		--a.y;
		return a.clone();
	}

	@:op(a++)
	static inline function postfixIncrement(a:Vec2) {
		var ret = a.clone();
		++a.x;
		++a.y;
		return ret;
	}

	@:op(a--)
	static inline function postfixDecrement(a:Vec2) {
		var ret = a.clone();
		--a.x;
		--a.y;
		return ret;
	}

	@:op(a * b)
	static inline function mul(a:Vec2, b:Vec2):Vec2
		return new Vec2(a.x * b.x, a.y * b.y);

	@:op(a * b) @:commutative
	static inline function mulScalar(a:Vec2, b:FastFloat):Vec2
		return new Vec2(a.x * b, a.y * b);

	@:op(a / b)
	static inline function div(a:Vec2, b:Vec2):Vec2
		return new Vec2(a.x / b.x, a.y / b.y);

	@:op(a / b)
	static inline function divScalar(a:Vec2, b:FastFloat):Vec2
		return new Vec2(a.x / b, a.y / b);

	@:op(a / b)
	static inline function divScalarInv(a:FastFloat, b:Vec2):Vec2
		return new Vec2(a / b.x, a / b.y);

	@:op(a + b)
	static inline function add(a:Vec2, b:Vec2):Vec2
		return new Vec2(a.x + b.x, a.y + b.y);

	@:op(a + b) @:commutative
	static inline function addScalar(a:Vec2, b:FastFloat):Vec2
		return new Vec2(a.x + b, a.y + b);

	@:op(a - b)
	static inline function sub(a:Vec2, b:Vec2):Vec2
		return new Vec2(a.x - b.x, a.y - b.y);

	@:op(a - b)
	static inline function subScalar(a:Vec2, b:FastFloat):Vec2
		return new Vec2(a.x - b, a.y - b);

	@:op(b - a)
	static inline function subScalarInv(a:FastFloat, b:Vec2):Vec2
		return new Vec2(a - b.x, a - b.y);

	@:op(a == b)
	static inline function equal(a:Vec2, b:Vec2):Bool
		return a.x == b.x && a.y == b.y;

	@:op(a != b)
	static inline function notEqual(a:Vec2, b:Vec2):Bool
		return !equal(a, b);
	#end // !macro

	// macros

	/**
	 * Copy from any object with .x .y fields
	 */
	@:overload(function(source:{x:FastFloat, y:FastFloat}):Vec2 {})
	public macro function copyFrom(self:ExprOf<Vec2>, source:ExprOf<{x:FastFloat, y:FastFloat}>):ExprOf<Vec2> {
		return macro {
			var self = $self;
			var source = $source;
			self.x = source.x;
			self.y = source.y;
			self;
		}
	}

	/**
	 * Copy into any object with .x .y fields
	 */
	@:overload(function(target:{x:FastFloat, y:FastFloat}):{x:FastFloat, y:FastFloat} {})
	public macro function copyInto(self:ExprOf<Vec2>, target:ExprOf<{x:FastFloat, y:FastFloat}>):ExprOf<{x:FastFloat, y:FastFloat}> {
		return macro {
			var self = $self;
			var target = $target;
			target.x = self.x;
			target.y = self.y;
			target;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyIntoArray(self:ExprOf<Vec2>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			array[0 + i] = self.x;
			array[1 + i] = self.y;
			array;
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public macro function copyFromArray(self:ExprOf<Vec2>, array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>) {
		return macro {
			var self = $self;
			var array = $array;
			var i:Int = $index;
			self.x = array[0 + i];
			self.y = array[1 + i];
			self;
		}
	}

	// static macros

	/**
	 * Create from any object with .x .y fields
	 */
	@:overload(function(source:{x:FastFloat, y:FastFloat}):Vec2 {})
	public static macro function from(xy:ExprOf<{x:FastFloat, y:FastFloat}>):ExprOf<Vec2> {
		return macro {
			var source = $xy;
			new Vec2(source.x, source.y);
		}
	}

	@:overload(function<T>(arrayLike:T, index:Int):T {})
	public static macro function fromArray(array:ExprOf<ArrayAccess<FastFloat>>, index:ExprOf<Int>):ExprOf<Vec2> {
		return macro {
			var array = $array;
			var i:Int = $index;
			new Vec2(array[0 + i], array[1 + i]);
		}
	}
}
