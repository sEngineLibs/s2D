package s2d.graphics.lighting;

import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;
// s2d
import s2d.math.SMath;

@:access(s2d.Stage)
@:allow(s2d.graphics.Renderer)
@:access(s2d.graphics.Renderer)
@:access(s2d.objects.Sprite)
@:access(s2d.graphics.materials.Material)
class LightingForward {
	static var pipeline:PipelineState;

	// stage uniforms
	static var mvpCL:ConstantLocation;
	static var invVPCL:ConstantLocation;
	static var lightsDataCL:ConstantLocation;
	#if (S2D_RP_ENV_LIGHTING == 1)
	static var envMapTU:TextureUnit;
	#end
	// sprite uniforms
	static var spriteParamsCL:ConstantLocation;
	static var cropRectCL:ConstantLocation;
	// material uniforms
	static var albedoMapTU:TextureUnit;
	static var normalMapTU:TextureUnit;
	static var emissionMapTU:TextureUnit;
	static var ormMapTU:TextureUnit;
	static var matParamsCL:ConstantLocation;

	static inline function compile() {
		var structure = new VertexStructure();
		structure.add("vertCoord", Float32_2X);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.sprite_vert;
		pipeline.fragmentShader = Shaders.lighting_forward_frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();

		// stage uniforms
		mvpCL = pipeline.getConstantLocation("MVP");
		invVPCL = pipeline.getConstantLocation("invVP");
		lightsDataCL = pipeline.getConstantLocation("lightsData");
		#if (S2D_RP_ENV_LIGHTING == 1)
		envMapTU = pipeline.getTextureUnit("envMap");
		#end
		// sprite uniforms
		spriteParamsCL = pipeline.getConstantLocation("spriteParams");
		cropRectCL = pipeline.getConstantLocation("cropRect");
		// material uniforms
		albedoMapTU = pipeline.getTextureUnit("albedoMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		emissionMapTU = pipeline.getTextureUnit("emissionMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		matParamsCL = pipeline.getConstantLocation("matParams");
	}

	static inline function render():Void {
		final g2 = Renderer.ppBuffer.tgt.g2;
		final g4 = Renderer.ppBuffer.tgt.g4;
		final VP = S2D.stage.VP;
		final sprites = S2D.stage.sprites;

		g2.begin();
		// emission + environment
		g4.setPipeline(pipeline);
		g4.setIndexBuffer(S2D.indices);
		g4.setVertexBuffer(S2D.vertices);
		#if (S2D_RP_ENV_LIGHTING == 1)
		g4.setTexture(envMapTU, S2D.stage.environmentMap);
		g4.setTextureParameters(envMapTU, Clamp, Clamp, LinearFilter, LinearFilter, LinearMipFilter);
		#end
		g4.setMatrix3(invVPCL, inverse(VP));
		for (sprite in sprites) {
			final ct = sprite.material.sheet.curTile;
			final model = sprite._model;
			final rot = atan2(model._10, model._00);
			final cropRect = vec4(mix(ct.xy, ct.zw, sprite.cropRect.xy), mix(ct.xy, ct.zw, sprite.cropRect.zw));

			g4.setMatrix3(mvpCL, VP * sprite._model);
			g4.setFloat2(spriteParamsCL, rot, sprite._z);
			g4.setVector4(cropRectCL, cropRect);
			g4.setTexture(albedoMapTU, sprite.material.albedoMap);
			g4.setTexture(normalMapTU, sprite.material.normalMap);
			g4.setTexture(ormMapTU, sprite.material.ormMap);
			g4.setTexture(emissionMapTU, sprite.material.emissionMap);
			g4.setFloats(matParamsCL, sprite.material.params);
			g4.setFloats(lightsDataCL, S2D.stage.lightsData);
			g4.drawIndexedVertices();
		}
		g2.end();
	}
}
