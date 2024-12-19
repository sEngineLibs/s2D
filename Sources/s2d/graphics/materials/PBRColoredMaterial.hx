package s2d.graphics.materials;

import kha.Color;
import kha.Canvas;
import kha.math.FastMatrix4;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import sengine.SEngine;
import s2d.graphics.shaders.S2DShaders;

class PBRColoredMaterial extends Material {
	public var diffuseColor:Color;
	public var emissionColor:Color;
	public var normalColor:Color;
	public var ormColor:Color;

	public function new() {
		super();

		diffuseColor = Color.fromFloats(0.85, 0.85, 0.85);
		emissionColor = Color.fromFloats(0.0, 0.0, 0.0);
		normalColor = Color.fromFloats(0.5, 0.5, 1.0);
		ormColor = Color.fromFloats(1.0, 0.5, 0.0);
	}

	override inline function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, transformation:FastMatrix4) {
		S2DShaders.pbrColored.render(target, vertices, indices, [
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
			ormColor.R,
			ormColor.G,
			ormColor.B,
			SEngine.stage.lights
		]);
	};
}
