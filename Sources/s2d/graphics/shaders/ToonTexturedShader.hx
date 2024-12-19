package s2d.graphics.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexShader;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;
// score
import s2d.objects.Light;
import score.graphics.Shader;

class ToonTexturedShader extends Shader {
	var mvpCL:ConstantLocation;
	var diffuseTU:TextureUnit;
	var emissionTU:TextureUnit;
	var normalTU:TextureUnit;
	var lightPosCL:ConstantLocation;
	var lightColorCL:ConstantLocation;
	var lightPowerCL:ConstantLocation;

	override inline function initStructure() {
		structure = new VertexStructure();
		structure.add("vertPos", VertexData.Float32_3X);
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
		mvpCL = pipeline.getConstantLocation("MVP");
		normalTU = pipeline.getTextureUnit("normalMap");
		diffuseTU = pipeline.getTextureUnit("diffuseMap");
		emissionTU = pipeline.getTextureUnit("emissionMap");

		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightPowerCL = pipeline.getConstantLocation("lightPower");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setMatrix(mvpCL, uniforms[0]);
		target.g4.setTexture(diffuseTU, uniforms[1]);
		target.g4.setTexture(emissionTU, uniforms[2]);
		target.g4.setTexture(normalTU, uniforms[3]);

		var lights:Array<Light> = cast uniforms[4];
		target.g4.setFloat3(lightPosCL, lights[0].x, lights[0].y, lights[0].z);
		target.g4.setFloat3(lightColorCL, lights[0].color.R, lights[0].color.G, lights[0].color.B);
		target.g4.setFloat(lightPowerCL, lights[0].power);
	}
}
