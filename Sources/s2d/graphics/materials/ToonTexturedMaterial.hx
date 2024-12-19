package s2d.graphics.materials;

import kha.Image;
import kha.Canvas;
import kha.math.FastMatrix4;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
// s2d
import sengine.SEngine;
import s2d.graphics.shaders.S2DShaders;

class ToonTexturedMaterial extends Material {
	public var diffuseMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	public var emissionMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);
	public var normalMap:Image = Image.createRenderTarget(1, 1, RGBA32, NoDepthAndStencil);

	public function new() {
		super();
	}

	override inline function render(target:Canvas, vertices:VertexBuffer, indices:IndexBuffer, transformation:FastMatrix4) {
		S2DShaders.toonTextured.render(target, vertices, indices, [
			SEngine.stage.projection.transformation.matrix.multmat(transformation), // mvp
			diffuseMap,
			emissionMap,
			normalMap,
			SEngine.stage.lights
		]);
	};
}
