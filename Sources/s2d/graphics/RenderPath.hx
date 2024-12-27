package s2d.graphics;

import kha.Canvas;
// s2d
import s2d.objects.Sprite;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.GeometryPass;
import s2d.graphics.shaders.CompositorPass;
import s2d.graphics.shaders.PostProcessingPass;

class RenderPath {
	public static inline function render(target:Canvas, stage:Stage):Void {
		var VP = S2D.projection.multmat(stage.camera);

		// geometry pass
		S2D.gbuffer[0].g4.begin([S2D.gbuffer[1], S2D.gbuffer[2], S2D.gbuffer[3], S2D.gbuffer[4]]);
		S2D.gbuffer[0].g4.clear(Black);
		S2D.gbuffer[0].g4.setPipeline(GeometryPass.pipeline);
		S2D.gbuffer[0].g4.setIndexBuffer(Sprite.indices);
		for (sprite in stage.sprites) {
			S2D.gbuffer[0].g4.setMatrix(GeometryPass.modelCL, sprite.finalTransformation);
			S2D.gbuffer[0].g4.setMatrix(GeometryPass.vpCL, VP);
			S2D.gbuffer[0].g4.setInt(GeometryPass.blendModeCL, sprite.material.blendMode);
			S2D.gbuffer[0].g4.setFloat(GeometryPass.depthScaleCL, sprite.material.depthScale);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.colorMapTU, sprite.material.colorMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.normalMapTU, sprite.material.normalMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.ormMapTU, sprite.material.ormMap);
			S2D.gbuffer[0].g4.setTexture(GeometryPass.emissionMapTU, sprite.material.emissionMap);
			S2D.gbuffer[0].g4.setVertexBuffer(Sprite.vertices);
			S2D.gbuffer[0].g4.drawIndexedVertices();
		}
		S2D.gbuffer[0].g4.end();

		// lighting pass
		S2D.gbuffer[5].g2.begin();
		S2D.gbuffer[5].g4.setPipeline(LightingPass.pipeline);
		S2D.gbuffer[5].g4.setIndexBuffer(S2D.indices);
		S2D.gbuffer[5].g4.setVertexBuffer(S2D.vertices);
		S2D.gbuffer[5].g4.setTexture(LightingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.normalMapTU, S2D.gbuffer[1]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.colorMapTU, S2D.gbuffer[2]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.ormMapTU, S2D.gbuffer[3]);
		S2D.gbuffer[5].g4.setTexture(LightingPass.emissionMapTU, S2D.gbuffer[4]);
		for (light in stage.lights) {
			var lightPos = light.finalTransformation.multvec3({x: light.x, y: light.y, z: light.z});
			S2D.gbuffer[5].g4.setFloat3(LightingPass.lightPosCL, lightPos.x, lightPos.y, lightPos.z);
			S2D.gbuffer[5].g4.setFloat3(LightingPass.lightColorCL, light.color.R, light.color.G, light.color.B);
			S2D.gbuffer[5].g4.setFloat2(LightingPass.lightAttribCL, light.power, light.radius);
			S2D.gbuffer[5].g4.drawIndexedVertices();
		}
		S2D.gbuffer[5].g2.end();

		// postprocessing pass
		S2D.gbuffer[6].g2.begin();
		S2D.gbuffer[6].g4.setPipeline(PostProcessingPass.pipeline);
		S2D.gbuffer[6].g4.setIndexBuffer(S2D.indices);
		S2D.gbuffer[6].g4.setVertexBuffer(S2D.vertices);
		S2D.gbuffer[6].g4.setTexture(PostProcessingPass.positionMapTU, S2D.gbuffer[0]);
		S2D.gbuffer[6].g4.setTexture(PostProcessingPass.textureMapTU, S2D.gbuffer[5]);
		S2D.gbuffer[6].g4.setFloat2(PostProcessingPass.dofAttribCL, PostProcessing.dof.distance + stage.camera.matrix._32, PostProcessing.dof.size);
		S2D.gbuffer[6].g4.drawIndexedVertices();
		S2D.gbuffer[6].g2.end();

		// compositor pass
		target.g2.begin();
		target.g4.setPipeline(CompositorPass.pipeline);
		target.g4.setIndexBuffer(S2D.indices);
		target.g4.setVertexBuffer(S2D.vertices);
		target.g4.setTexture(CompositorPass.textureMapTU, S2D.gbuffer[6]);
		target.g4.setFloat2(CompositorPass.resolutionCL, target.width, target.height);
		target.g4.setFloat3(CompositorPass.distortionAttribCL, Compositor.distortion.x, Compositor.distortion.y, Compositor.distortion.strength);
		target.g4.drawIndexedVertices();
		target.g2.end();
	};
}
