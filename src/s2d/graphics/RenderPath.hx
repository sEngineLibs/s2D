package s2d.graphics;

import kha.Image;
import kha.Canvas;
import kha.Shaders;
// s2d
import s2d.objects.Sprite;
import s2d.graphics.shaders.LightingPass;
import s2d.graphics.shaders.GeometryPass;
#if S2D_RP_ENV_LIGHTING
import s2d.graphics.shaders.EnvLightingPass;
#end

using s2d.utils.FastMatrix4Ext;

@:allow(s2d.S2D)
class RenderPath {
	static var geometryPass:GeometryPass = new GeometryPass();
	#if S2D_RP_ENV_LIGHTING
	static var envLightingPass:EnvLightingPass = new EnvLightingPass();
	#end
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
		#if S2D_RP_ENV_LIGHTING
		envLightingPass.compile(Shaders.env_lighting_pass_frag, Shaders.s2d_2d_vert);
		#end

		#if S2D_PP
		#if S2D_PP_DOF
		PostProcessing.dofPass.compile(Shaders.dof_pass_frag);
		#end
		#if S2D_PP_MIST
		PostProcessing.mistPass.compile(Shaders.mist_pass_frag);
		#end
		#if S2D_PP_FILTER
		PostProcessing.filterPass.compile(Shaders.filter_pass_frag);
		#end
		#if S2D_PP_FISHEYE
		PostProcessing.fisheyePass.compile(Shaders.fisheye_pass_frag);
		#end
		#if S2D_PP_COMPOSITOR
		PostProcessing.compositorPass.compile(Shaders.compositor_pass_frag);
		#end
		#end
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
		var sourceInd:Int = 0, targetInd:Int = 0;

		var VP = stage.viewProjection;
		var cameraPos = stage.camera.finalTransformation.getTranslation();

		// geometry pass
		g4 = gbuffer[targetInd].g4;
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
		sourceInd = 0;
		targetInd = 5;

		// Lighting Pass
		// environment + glow pass
		g2 = gbuffer[targetInd].g2;
		g4 = gbuffer[targetInd].g4;
		g2.begin();
		#if S2D_RP_ENV_LIGHTING
		g4.setPipeline(envLightingPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(envLightingPass.normalMapTU, gbuffer[1]);
		g4.setTexture(envLightingPass.colorMapTU, gbuffer[2]);
		g4.setTexture(envLightingPass.ormMapTU, gbuffer[3]);
		g4.setTexture(envLightingPass.glowMapTU, gbuffer[4]);
		g4.setTexture(envLightingPass.envMapTU, stage.environmentMap);
		g4.setTextureParameters(envLightingPass.envMapTU, Clamp, Clamp, LinearFilter, LinearFilter, LinearMipFilter);
		g4.drawIndexedVertices();
		#end
		// stage lights
		g4.setPipeline(lightingPass.pipeline);
		g4.setIndexBuffer(Sprite.indices);
		g4.setVertexBuffer(Sprite.vertices);
		g4.setTexture(lightingPass.positionMapTU, gbuffer[0]);
		g4.setTexture(lightingPass.normalMapTU, gbuffer[1]);
		g4.setTexture(lightingPass.colorMapTU, gbuffer[2]);
		g4.setTexture(lightingPass.ormMapTU, gbuffer[3]);
		g4.setMatrix(lightingPass.invVPCL, VP.inverse());
		g4.setFloats(lightingPass.lightsDataCL, stage.lightsData);
		g4.drawIndexedVertices();
		g2.end();
		sourceInd = 5;
		targetInd = 6;

		// post-processing
		#if S2D_PP
		var invVP = VP.inverse();

		#if S2D_PP_MIST
		var mist = PostProcessing.mist;
		PostProcessing.mistPass.render(gbuffer[targetInd], Sprite.indices, Sprite.vertices, [
			gbuffer[sourceInd],
			// uniforms
			gbuffer[0],
			invVP,
			cameraPos,
			mist.near,
			mist.far,
			mist.color.R,
			mist.color.G,
			mist.color.B,
			mist.color.A
		]);
		sourceInd = 6;
		targetInd = 5;
		#end

		#if S2D_PP_DOF
		var dof = PostProcessing.dof;
		PostProcessing.dofPass.render(gbuffer[targetInd], Sprite.indices, Sprite.vertices, [
			gbuffer[sourceInd],
			// uniforms
			gbuffer[0],
			invVP,
			cameraPos,
			dof.focusDistance,
			dof.blurSize
		]);
		sourceInd = 5;
		targetInd = 6;
		#end

		#if S2D_PP_FISHEYE
		var fisheye = PostProcessing.fisheye;
		PostProcessing.fisheyePass.render(gbuffer[targetInd], Sprite.indices, Sprite.vertices, [
			gbuffer[sourceInd],
			// uniforms
			fisheye.position.x,
			fisheye.position.y,
			fisheye.strength
		]);
		sourceInd = 6;
		targetInd = 5;
		#end

		#if S2D_PP_FILTER
		for (i in 0...PostProcessing.filters.length) {
			sourceInd = 5 + (i + 1) % 2;
			targetInd = 5 + i % 2;
			PostProcessing.filterPass.render(gbuffer[targetInd], Sprite.indices, Sprite.vertices, [
				gbuffer[sourceInd],
				// uniforms
				PostProcessing.filters[i]
			]);
		}
		#end

		#if S2D_PP_COMPOSITOR
		var compositor = PostProcessing.compositor;
		g2 = gbuffer[sourceInd].g2;
		g2.scissor(0, compositor.letterBoxHeight, target.width, target.height - compositor.letterBoxHeight * 2);
		PostProcessing.compositorPass.render(gbuffer[sourceInd], Sprite.indices, Sprite.vertices, [
			gbuffer[targetInd],
			// uniforms
			compositor.params
		]);
		g2.disableScissor();
		#end
		#end

		g2 = target.g2;
		g2.begin();
		g2.drawScaledImage(gbuffer[sourceInd], 0, 0, target.width, target.height);
		g2.end();
	};
}
