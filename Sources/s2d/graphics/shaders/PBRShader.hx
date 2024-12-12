package s2d.graphics.shaders;

import sui.core.graphics.shaders.Shader;

class PBRShader {
	#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
	static public var geometry:GeometryPass = new GeometryPass();
	#end
	static public var lighting:LightingPass = new LightingPass();
}

#if (S2D_SHADING_DEFERRED || S2D_SHADING_MIXED)
private class GeometryPass extends Shader {
	var albedoMapTU:TextureUnit;
	var emissionMapTU:TextureUnit;
	var normalMapTU:TextureUnit;
	var ormMapTU:TextureUnit;
	var blendModeCL:ConstantLocation;
	#if S2D_BATCHING
	var instancesCountCL:ConstantLocation;
	#end

	override inline function initStructure() {
		structure = new VertexStructure();
		#if S2D_BATCHING
		structure.add("vertData", VertexData.Float32_4X);
		#else
		structure.add("vertPos", VertexData.Float32_3X);
		#end
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.depthWrite = true;
		pipeline.depthStencilAttachment = DepthOnly;
		pipeline.colorAttachmentCount = 3;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		albedoMapTU = pipeline.getTextureUnit("albedoMap");
		emissionMapTU = pipeline.getTextureUnit("emissionMap");
		normalMapTU = pipeline.getTextureUnit("normalMap");
		ormMapTU = pipeline.getTextureUnit("ormMap");
		blendModeCL = pipeline.getConstantLocation("blendMode");
		#if S2D_BATCHING
		instancesCountCL = pipeline.getConstantLocation("instancesCount");
		#end
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(albedoMapTU, uniforms[0]);
		target.g4.setTexture(emissionMapTU, uniforms[1]);
		target.g4.setTexture(normalMapTU, uniforms[2]);
		target.g4.setTexture(ormMapTU, uniforms[3]);
		#if S2D_BATCHING
		target.g4.setInts(blendModeCL, uniforms[4]);
		target.g4.setInt(instancesCountCL, uniforms[5]);
		#else
		target.g4.setInt(blendModeCL, uniforms[4]);
		#end
		pipeline.depthMode = Greater;
	}
}
#end

private class LightingPass extends Shader {
	var albedoTU:TextureUnit;
	var emissionTU:TextureUnit;
	var normalTU:TextureUnit;
	var ormTU:TextureUnit;

	var lightPosCL:ConstantLocation;
	var lightColorCL:ConstantLocation;
	var lightAttribCL:ConstantLocation;

	#if S2D_BATCHING
	var instancesCountCL:ConstantLocation;
	#end

	override inline function initStructure() {
		structure = new VertexStructure();
		#if S2D_BATCHING
		structure.add("vertData", VertexData.Float32_4X);
		#else
		structure.add("vertPos", VertexData.Float32_3X);
		#end
		structure.add("vertUV", VertexData.Float32_2X);
	}

	override public function compile(vert:VertexShader, frag:FragmentShader) {
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = vert;
		pipeline.fragmentShader = frag;
		pipeline.blendOperation = Add;
		pipeline.blendSource = BlendOne;
		pipeline.blendDestination = BlendOne;
		pipeline.compile();
		getUniforms();
	}

	override inline function getUniforms() {
		ormTU = pipeline.getTextureUnit("ormMap");
		normalTU = pipeline.getTextureUnit("normalMap");
		albedoTU = pipeline.getTextureUnit("albedoMap");
		emissionTU = pipeline.getTextureUnit("emissionMap");

		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightAttribCL = pipeline.getConstantLocation("lightAttrib");
		#if S2D_BATCHING
		instancesCountCL = pipeline.getConstantLocation("instancesCount");
		#end
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setTexture(albedoTU, uniforms[0]);
		target.g4.setTexture(emissionTU, uniforms[1]);
		target.g4.setTexture(normalTU, uniforms[2]);
		target.g4.setTexture(ormTU, uniforms[3]);
		target.g4.setFloat3(lightPosCL, uniforms[4], uniforms[5], uniforms[6]);
		target.g4.setFloat3(lightColorCL, uniforms[7], uniforms[8], uniforms[9]);
		target.g4.setFloat2(lightAttribCL, uniforms[10], uniforms[11]);
		#if S2D_BATCHING
		target.g4.setInt(instancesCountCL, uniforms[5]);
		#end
	}
}
