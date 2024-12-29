package s2d.graphics;

import kha.Canvas;
// s2d
import s2d.objects.Sprite;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.GeometryPass;
import s2d.graphics.shaders.CompositorPass;
import s2d.graphics.shaders.PostProcessingPass;

using s2d.utils.FastMatrix4Ext;

class RenderPath {
	public static inline function render(target:Canvas, stage:Stage):Void {
		var VP = stage.viewProjection;

		// geometry pass
		S2D.gbuffer[0].g4.begin([S2D.gbuffer[1], S2D.gbuffer[2], S2D.gbuffer[3], S2D.gbuffer[4]]);
		S2D.gbuffer[0].g4.clear(Black);
		S2D.gbuffer[0].g4.setPipeline(GeometryPass.pipeline);
		S2D.gbuffer[0].g4.setIndexBuffer(Sprite.indices);
		for (sprite in stage.sprites) {
			var t = sprite.finalTransformation;

			S2D.gbuffer[0].g4.setFloat4(GeometryPass.rotCL, t._00, t._01, t._10, t._11);
			S2D.gbuffer[0].g4.setMatrix(GeometryPass.mvpCL, VP.multmat(t));
			S2D.gbuffer[0].g4.setTexture(GeometryPass.colorMapTU, sprite.material.colorMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.normalMapTU, sprite.material.normalMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.ormMapTU, sprite.material.ormMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.glowMapTU, sprite.material.glowMap);
			S2D.gbuffer[0].g4.setFloats(GeometryPass.paramsCL, sprite.material.params);
			S2D.gbuffer[0].g4.setVertexBuffer(Sprite.vertices);
			S2D.gbuffer[0].g4.drawIndexedVertices();
		}
		S2D.gbuffer[0].g4.end();

		// lighting pass
		S2D.gbuffer[5].g2.begin();
		S2D.gbuffer[5].g4.setPipeline(LightingPass.pipeline);
		S2D.gbuffer[5].g4.setIndexBuffer(Sprite.indices);
		S2D.gbuffer[5].g4.setVertexBuffer(Sprite.vertices);
		S2D.gbuffer[5].g4.setTexture(LightingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.normalMapTU, S2D.gbuffer[1]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.colorMapTU, S2D.gbuffer[2]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.ormMapTU, S2D.gbuffer[3]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.glowMapTU, S2D.gbuffer[4]);
		S2D.gbuffer[5].g4.setMatrix(LightingPass.invVPCL, VP.inverse());
		for (light in stage.lights) {
			S2D.gbuffer[5].g4.setVector3(LightingPass.lightPosCL, light.location);
			S2D.gbuffer[5].g4.setFloat3(LightingPass.lightColorCL, light.color.R, light.color.G, light.color.B);
			S2D.gbuffer[5].g4.setFloat2(LightingPass.lightAttribCL, light.power, light.radius);
			S2D.gbuffer[5].g4.drawIndexedVertices();
		}
		S2D.gbuffer[5].g2.end();

		// postprocessing pass
		S2D.gbuffer[6].g2.begin(false);
		S2D.gbuffer[6].g4.setPipeline(PostProcessingPass.pipeline);
		S2D.gbuffer[6].g4.setIndexBuffer(Sprite.indices);
		S2D.gbuffer[6].g4.setVertexBuffer(Sprite.vertices);
		S2D.gbuffer[6].g4.setTexture(PostProcessingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[6].g4.setTexture(PostProcessingPass.textureMapTU, S2D.gbuffer[5]);
		S2D.gbuffer[6].g4.setFloats(PostProcessingPass.paramsCL, S2D.postProcessing.params);
		S2D.gbuffer[6].g4.setMatrix(PostProcessingPass.invVPCL, VP.inverse());
		S2D.gbuffer[6].g4.setFloat3(PostProcessingPass.cameraPosCL, stage.camera.getTranslationX(), stage.camera.getTranslationY(),
			stage.camera.getTranslationZ());
		S2D.gbuffer[6].g4.drawIndexedVertices();
		S2D.gbuffer[6].g2.end();

		// compositor pass
		target.g2.begin(true, S2D.compositor.letterBoxColor);
		target.g2.scissor(0, S2D.compositor.letterBoxHeight, target.width, target.height - S2D.compositor.letterBoxHeight * 2);
		target.g2.pipeline = CompositorPass.pipeline;
		target.g4.setPipeline(CompositorPass.pipeline);
		target.g4.setFloats(CompositorPass.paramsCL, S2D.compositor.params);
		target.g2.drawScaledImage(S2D.gbuffer[6], 0, 0, target.width, target.height);
		target.g2.disableScissor();
		target.g2.end();
	};
}
