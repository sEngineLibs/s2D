package s2d.graphics.shaders;

import kha.Canvas;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.PipelineState;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;
// score
import s2d.objects.Light;
import score.graphics.Shader;

class ToonColoredShader extends Shader {
	var mvpCL:ConstantLocation;
	var diffuseCL:ConstantLocation;
	var emissionCL:ConstantLocation;
	var normalCL:ConstantLocation;
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
		normalCL = pipeline.getConstantLocation("normalCol");
		diffuseCL = pipeline.getConstantLocation("diffuseCol");
		emissionCL = pipeline.getConstantLocation("emissionCol");

		lightPosCL = pipeline.getConstantLocation("lightPos");
		lightColorCL = pipeline.getConstantLocation("lightColor");
		lightPowerCL = pipeline.getConstantLocation("lightPower");
	}

	override inline function setUniforms(target:Canvas, ?uniforms:Dynamic) {
		target.g4.setMatrix(mvpCL, uniforms[0]);
		target.g4.setFloat3(diffuseCL, uniforms[1], uniforms[2], uniforms[3]);
		target.g4.setFloat3(emissionCL, uniforms[4], uniforms[5], uniforms[6]);
		target.g4.setFloat3(normalCL, uniforms[7], uniforms[8], uniforms[9]);

		var lights:Array<Light> = cast uniforms[10];
		target.g4.setFloat3(lightPosCL, lights[0].x, lights[0].y, lights[0].z);
		target.g4.setFloat3(lightColorCL, lights[0].color.R, lights[0].color.G, lights[0].color.B);
		target.g4.setFloat(lightPowerCL, lights[0].power);
	}
}
