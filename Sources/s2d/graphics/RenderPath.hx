package s2d.graphics;

import kha.Shaders;
import kha.Image;
import kha.Canvas;
// s2d
import s2d.objects.Sprite;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.GeometryPass;

using s2d.utils.FastMatrix4Ext;

@:allow(s2d.S2D)
class RenderPath {
	static var geometryPass:GeometryPass = new GeometryPass();
	static var lightingPass:LightingPass = new LightingPass();
	static var gbuffer:Array<Image> = [];

	static inline function init(width:Int, height:Int) {
		// position
		gbuffer.push(Image.createRenderTarget(width, height, RGBA128, DepthOnly));
		// normal
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// color
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// [occlusion, roughness, metallness]
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// glow
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, DepthOnly));
		// post processing
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil));
		// compositor
		gbuffer.push(Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil));
	}

	static inline function compile() {
		geometryPass.compile(Shaders.geometry_pass_frag, Shaders.geometry_pass_vert);
		lightingPass.compile(Shaders.lighting_pass_frag, Shaders.s2d_2d_vert);
		PostProcessing.dofPass.compile(Shaders.dof_pass_frag);
		PostProcessing.mistPass.compile(Shaders.mist_pass_frag);
		PostProcessing.filterPass.compile(Shaders.filter_pass_frag);
		PostProcessing.fisheyePass.compile(Shaders.fisheye_pass_frag);
		PostProcessing.compositorPass.compile(Shaders.compositor_pass_frag);
	}

	static inline function resize(width:Int, height:Int) {
		// position
		gbuffer[0] = Image.createRenderTarget(width, height, RGBA128, DepthOnly);
		// normal
		gbuffer[1] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// color
		gbuffer[2] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// [occlusion, roughness, metallness]
		gbuffer[3] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// glow
		gbuffer[4] = Image.createRenderTarget(width, height, RGBA32, DepthOnly);
		// post processing
		gbuffer[5] = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil);
		// compositor
		gbuffer[6] = Image.createRenderTarget(width, height, RGBA32, NoDepthAndStencil);
	}

	static inline function render(target:Canvas, stage:Stage):Void {
		var g2:kha.graphics2.Graphics, g4:kha.graphics4.Graphics;

		var VP = stage.viewProjection;
		var cameraPos = stage.camera.finalTransformation.getTranslation();

		// geometry pass
		g4 = gbuffer[0].g4;
		g4.begin([gbuffer[1], gbuffer[2], gbuffer[3], gbuffer[4]]);
		g4.clear(Black);
		g4.setPipeline(geometryPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		for (sprite in stage.sprites) {
			g4.setMatrix(geometryPass.modelCL, sprite.finalTransformation);
			g4.setMatrix(geometryPass.viewProjectionCL, VP);
			g4.setTexture(geometryPass.colorMapTU, sprite.material.colorMap);
			g4.setTexture(geometryPass.normalMapTU, sprite.material.normalMap);
			g4.setTexture(geometryPass.ormMapTU, sprite.material.ormMap);
			g4.setTexture(geometryPass.glowMapTU, sprite.material.glowMap);
			g4.setFloats(geometryPass.paramsCL, sprite.material.params);
			g4.drawIndexedVertices();
		}
		g4.end();

		// lighting pass
		g2 = gbuffer[5].g2;
		g4 = gbuffer[5].g4;
		g2.begin();
		g4.setPipeline(lightingPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(lightingPass.positionMapTU, gbuffer[0]);
		g4.setTexture(lightingPass.normalMapTU, gbuffer[1]);
		g4.setTexture(lightingPass.colorMapTU, gbuffer[2]);
		g4.setTexture(lightingPass.ormMapTU, gbuffer[3]);
		g4.setTexture(lightingPass.glowMapTU, gbuffer[4]);
		g4.setTexture(lightingPass.envMapTU, stage.environmentMap);
		g4.setTextureParameters(lightingPass.envMapTU, Mirror, Mirror, LinearFilter, LinearFilter, LinearMipFilter);
		g4.setMatrix(lightingPass.invVPCL, VP.inverse());
		g4.setFloats(lightingPass.lightsDataCL, stage.lightsData);
		g4.drawIndexedVertices();
		g2.end();

		// postprocessing
		var invVP = VP.inverse();

		// var mist = PostProcessing.mist;
		// PostProcessing.mistPass.render(gbuffer[6], Sprite.indices, Sprite.vertices, [
		// 	gbuffer[5],
		// 	// uniforms
		// 	gbuffer[0],
		// 	invVP,
		// 	cameraPos,
		// 	mist.near,
		// 	mist.far,
		// 	mist.color.R,
		// 	mist.color.G,
		// 	mist.color.B,
		// 	mist.color.A
		// ]);

		// var dof = PostProcessing.dof;
		// PostProcessing.dofPass.render(gbuffer[5], Sprite.indices, Sprite.vertices, [
		// 	gbuffer[6],
		// 	// uniforms
		// 	gbuffer[0],
		// 	invVP,
		// 	cameraPos,
		// 	dof.focusDistance,
		// 	dof.blurSize
		// ]);

		var fisheye = PostProcessing.fisheye;
		PostProcessing.fisheyePass.render(gbuffer[6], Sprite.indices, Sprite.vertices, [
			gbuffer[5],
			// uniforms
			fisheye.position,
			fisheye.strength
		]);

		var sourceInd = 6;
		var targetInd = 5;
		for (i in 0...PostProcessing.filters.length) {
			sourceInd = 5 + (i + 1) % 2;
			targetInd = 5 + i % 2;
			PostProcessing.filterPass.render(gbuffer[targetInd], Sprite.indices, Sprite.vertices, [
				gbuffer[sourceInd],
				// uniforms
				PostProcessing.filters[i]
			]);
		}

		var compositor = PostProcessing.compositor;
		g2 = gbuffer[sourceInd].g2;
		g2.scissor(0, compositor.letterBoxHeight, target.width, target.height - compositor.letterBoxHeight * 2);
		PostProcessing.compositorPass.render(gbuffer[sourceInd], Sprite.indices, Sprite.vertices, [
			gbuffer[targetInd],
			// uniforms
			compositor.params
		]);
		g2.disableScissor();

		g2 = target.g2;
		g2.begin();
		g2.drawScaledImage(gbuffer[sourceInd], 0, 0, target.width, target.height);
		g2.end();
	};
}
