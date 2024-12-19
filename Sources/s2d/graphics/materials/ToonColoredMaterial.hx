package s2d.graphics.materials;

import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import sengine.SEngine;
import s2d.graphics.shaders.S2DShaders;

class ToonColoredMaterial extends Material {
	public var diffuseColor:Color;
	public var emissionColor:Color;
	public var normalColor:Color;

	public function new() {
		super();

		diffuseColor = Color.fromFloats(0.85, 0.85, 0.85);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
	}

	override inline function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, transformation:FastMatrix4) {
		S2DShaders.toonColored.render(target, vertices, indices, [
			SEngine.stage.projection.transformation.matrix.multmat(transformation), // mvp
			diffuseColor.R,
			diffuseColor.G,
			diffuseColor.B,
			emissionColor.R,
			emissionColor.G,
			emissionColor.B,
			normalColor.R,
			normalColor.G,
			normalColor.B,
			SEngine.stage.lights
		]);
	};
}
