package s2d.graphics.shaders.postprocessing;

#if S2D_PP_MIST
import kha.graphics4.Graphics;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class MistPass extends PostProcessingPass {
	var positionMapTU:TextureUnit;
	var invVPCL:ConstantLocation;
	var cameraPosCL:ConstantLocation;
	var mistScaleCL:ConstantLocation;
	var mistColorCL:ConstantLocation;

	override inline function getUniforms() {
		positionMapTU = pipeline.getTextureUnit("positionMap");
		invVPCL = pipeline.getConstantLocation("invVP");
		cameraPosCL = pipeline.getConstantLocation("cameraPos");
		mistScaleCL = pipeline.getConstantLocation("mistScale");
		mistColorCL = pipeline.getConstantLocation("mistColor");
	}

	override inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {
		g.setTexture(positionMapTU, uniforms[0]);
		g.setMatrix(invVPCL, uniforms[1]);
		g.setVector3(cameraPosCL, uniforms[2]);
		g.setFloat2(mistScaleCL, uniforms[3], uniforms[4]);
		g.setFloat4(mistColorCL, uniforms[5], uniforms[6], uniforms[7], uniforms[8]);
	}
}
#end
