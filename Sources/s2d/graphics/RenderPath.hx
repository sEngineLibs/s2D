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
		var MVP = S2D.projection.multmat(stage.camera);

		// geometry pass
		S2D.gbuffer[0].g4.begin([S2D.gbuffer[1], S2D.gbuffer[2], S2D.gbuffer[3], S2D.gbuffer[4]]);
		S2D.gbuffer[0].g4.clear(Black);
		S2D.gbuffer[0].g4.setPipeline(GeometryPass.pipeline);
		S2D.gbuffer[0].g4.setIndexBuffer(Sprite.indices);
		for (sprite in stage.sprites) {
			var t = sprite.finalTransformation;

			S2D.gbuffer[0].g4.setFloat4(GeometryPass.rotCL, t._00, t._01, t._10, t._11);
			S2D.gbuffer[0].g4.setMatrix(GeometryPass.mvpCL, MVP.multmat(t));
			S2D.gbuffer[0].g4.setTexture(GeometryPass.colorMapTU, sprite.material.colorMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.normalMapTU, sprite.material.normalMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.ormMapTU, sprite.material.ormMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.glowMapTU, sprite.material.glowMap);
			S2D.gbuffer[0].g4.setFloats(GeometryPass.matAttribCL, sprite.material.attrib);
			S2D.gbuffer[0].g4.setVertexBuffer(Sprite.vertices);
			S2D.gbuffer[0].g4.drawIndexedVertices();
		}
		S2D.gbuffer[0].g4.end();

		// lighting pass
		S2D.gbuffer[5].g2.begin();
		S2D.gbuffer[5].g2.pipeline = LightingPass.pipeline;
		S2D.gbuffer[5].g4.setPipeline(LightingPass.pipeline);
		S2D.gbuffer[5].g4.setTexture(LightingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.normalMapTU, S2D.gbuffer[1]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.colorMapTU, S2D.gbuffer[2]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.ormMapTU, S2D.gbuffer[3]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.glowMapTU, S2D.gbuffer[4]);
		S2D.gbuffer[5].g4.setFloat3(LightingPass.stageScaleCL, S2D.projection.getScaleX(), S2D.projection.getScaleY(), S2D.projection.getScaleZ());
		for (light in stage.lights) {
			S2D.gbuffer[5].g4.setVector3(LightingPass.lightPosCL, light.location);
			S2D.gbuffer[5].g4.setFloat3(LightingPass.lightColorCL, light.color.R, light.color.G, light.color.B);
			S2D.gbuffer[5].g4.setFloat2(LightingPass.lightAttribCL, light.power, light.radius);
			S2D.gbuffer[5].g2.fillRect(0, 0, S2D.gbuffer[5].width, S2D.gbuffer[6].height);
		}
		S2D.gbuffer[5].g2.end();

		// postprocessing pass
		S2D.gbuffer[6].g2.begin();
		S2D.gbuffer[6].g2.pipeline = PostProcessingPass.pipeline;
		S2D.gbuffer[6].g4.setPipeline(PostProcessingPass.pipeline);
		S2D.gbuffer[6].g4.setTexture(PostProcessingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[6].g4.setFloat2(PostProcessingPass.dofAttribCL, PostProcessing.dof.distance + stage.camera.getTranslationZ(), PostProcessing.dof.size);
		S2D.gbuffer[6].g2.drawImage(S2D.gbuffer[5], 0, 0);
		S2D.gbuffer[6].g2.end();

		// compositor pass
		target.g2.begin();
		target.g2.pipeline = CompositorPass.pipeline;
		target.g4.setPipeline(CompositorPass.pipeline);
		target.g4.setFloat2(CompositorPass.resolutionCL, target.width, target.height);
		target.g4.setFloat3(CompositorPass.distortionAttribCL, Compositor.distortion.x, Compositor.distortion.y, Compositor.distortion.strength);
		target.g2.drawImage(S2D.gbuffer[6], 0, 0);
		target.g2.end();
	};
}