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
		var g2:kha.graphics2.Graphics, g4:kha.graphics4.Graphics;
		var VP = stage.viewProjection;

		g4 = S2D.gbuffer[0].g4;
		// geometry pass
		g4.begin([S2D.gbuffer[1], S2D.gbuffer[2], S2D.gbuffer[3], S2D.gbuffer[4]]);
		g4.clear(Black);
		g4.setPipeline(GeometryPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		for (sprite in stage.sprites) {
			g4.setMatrix(GeometryPass.modelCL, sprite.finalTransformation);
			g4.setMatrix(GeometryPass.viewProjectionCL, VP);
			g4.setTexture(GeometryPass.colorMapTU, sprite.material.colorMap);
			g4.setTexture(GeometryPass.normalMapTU, sprite.material.normalMap);
			g4.setTexture(GeometryPass.ormMapTU, sprite.material.ormMap);
			g4.setTexture(GeometryPass.glowMapTU, sprite.material.glowMap);
			g4.setFloats(GeometryPass.paramsCL, sprite.material.params);
			g4.drawIndexedVertices();
		}
		g4.end();

		g2 = S2D.gbuffer[5].g2;
		g4 = S2D.gbuffer[5].g4;
		// lighting pass
		g2.begin();
		g4.setPipeline(LightingPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(LightingPass.positionMapTU, S2D.gbuffer[0]);
		g4.setTexture(LightingPass.normalMapTU, S2D.gbuffer[1]);
		g4.setTexture(LightingPass.colorMapTU, S2D.gbuffer[2]);
		g4.setTexture(LightingPass.ormMapTU, S2D.gbuffer[3]);
		g4.setTexture(LightingPass.glowMapTU, S2D.gbuffer[4]);
		g4.setTexture(LightingPass.envMapTU, stage.environmentMap);
		g4.setTextureParameters(LightingPass.envMapTU, Clamp, Clamp, LinearFilter, LinearFilter, PointMipFilter);
		g4.setMatrix(LightingPass.invVPCL, VP.inverse());
		g4.setFloats(LightingPass.lightsDataCL, stage.lightsData);
		g4.drawIndexedVertices();
		g2.end();

		g2 = S2D.gbuffer[6].g2;
		g4 = S2D.gbuffer[6].g4;
		// postprocessing pass
		var cameraPosition = stage.camera.finalTransformation.getTranslation();
		g2.begin(false);
		g4.setPipeline(PostProcessingPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(PostProcessingPass.positionMapTU, S2D.gbuffer[0]);
		g4.setTexture(PostProcessingPass.textureMapTU, S2D.gbuffer[5]);
		g4.setFloats(PostProcessingPass.paramsCL, S2D.postProcessing.params);
		g4.setMatrix(PostProcessingPass.invVPCL, VP.inverse());
		g4.setVector3(PostProcessingPass.cameraPosCL, cameraPosition);
		g4.drawIndexedVertices();
		g2.end();

		g2 = S2D.gbuffer[5].g2;
		g4 = S2D.gbuffer[5].g4;
		// compositor pass
		g2.begin();
		g4.clear(S2D.compositor.letterBoxColor);
		g4.setPipeline(CompositorPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(CompositorPass.textureMapTU, S2D.gbuffer[6]);
		g4.setFloat2(CompositorPass.resolutionCL, S2D.gbuffer[6].width, S2D.gbuffer[6].height);
		g4.setFloats(CompositorPass.paramsCL, S2D.compositor.params);
		g4.drawIndexedVertices();
		g2.end();

		g2 = target.g2;
		g2.begin();
		g2.scissor(0, S2D.compositor.letterBoxHeight, target.width, target.height - S2D.compositor.letterBoxHeight * 2);
		g2.drawScaledImage(S2D.gbuffer[5], 0, 0, target.width, target.height);
		g2.disableScissor();
		g2.end();
	};
}
