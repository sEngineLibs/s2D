package s2d.graphics.shaders.postprocessing;

#if S2D_PP_DOF
import kha.graphics4.Graphics;
import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class DOFPass extends PostProcessingPass {
	var positionMapTU:TextureUnit;
	var invVPCL:ConstantLocation;
	var cameraPosCL:ConstantLocation;
	var focusDistanceCL:ConstantLocation;
	var blurSizeCL:ConstantLocation;

	override inline function getUniforms() {
		positionMapTU = pipeline.getTextureUnit("positionMap");
		invVPCL = pipeline.getConstantLocation("invVP");
		cameraPosCL = pipeline.getConstantLocation("cameraPos");
		focusDistanceCL = pipeline.getConstantLocation("focusDistance");
		blurSizeCL = pipeline.getConstantLocation("blurSize");
	}

	override inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {
		g.setTexture(positionMapTU, uniforms[0]);
		g.setMatrix(invVPCL, uniforms[1]);
		g.setVector3(cameraPosCL, uniforms[2]);
		g.setFloat(focusDistanceCL, uniforms[3]);
		g.setFloat(blurSizeCL, uniforms[4]);
	}
}
#end
