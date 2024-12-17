package s2d.graphics.materials;

import kha.math.FastMatrix4;
import sengine.SEngine;
import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.math.FastVector2;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import s2d.graphics.shaders.S2DShaders;

class PBRMaterial implements Material {
	public var diffuseMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	public var emissionMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	public var normalMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	public var ormMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	@:isVar public var diffuseColor(default, set):Color;
	@:isVar public var emissionColor(default, set):Color;
	@:isVar public var normalColor(default, set):Color;
	@:isVar public var ormColor(default, set):Color;

	public inline function new() {
		diffuseColor = Color.fromFloats(0.85, 0.85, 0.85);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

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

	public function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, transformation:FastMatrix4) {
		S2DShaders.pbr.render(target, vertices, indices, [
			SEngine.stage.projection.transformation.matrix.multmat(transformation), // mvp
			diffuseMap,
			emissionMap,
			normalMap,
			ormMap,
			SEngine.stage.lights
		]);
	};
}
