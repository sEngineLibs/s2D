package s2d.graphics.materials;

import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.math.FastVector2;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import s2d.graphics.shaders.S2DShaders;

class PBRMaterial implements Material {
	public var diffuseMap:Image;
	public var emissionMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	@:isVar public var diffuseColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;

	// meterial settings
	public var blendMode:BlendMode;
	public var shadowCast:Bool;
	public var shadowMode:BlendMode;
	public var shadowVerts:Array<FastVector2>;

	inline function setMapColor(map:Image, color:Color) {
		map.g2.begin(true, color);
		map.g2.end();
	}

	function set_diffuseColor(value:Color):Color {
		diffuseColor = value;
		setMapColor(diffuseMap, value);
		return value;
	}

	function set_emissionColor(value:Color):Color {
		emissionColor = value;
		setMapColor(emissionMap, value);
		return value;
	}

	function set_normalColor(value:Color):Color {
		normalColor = value;
		setMapColor(normalMap, value);
		return value;
	}

	function set_ormColor(value:Color):Color {
		ormColor = value;
		setMapColor(ormMap, value);
		return value;
	}

	public function draw(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, ?uniforms:Array<Dynamic>) {
		var lights = cast uniforms;

		S2DShaders.pbr.draw(target, vertices, indices, [diffuseMap, emissionMap, normalMap, ormMap, lights]);
	};
}
