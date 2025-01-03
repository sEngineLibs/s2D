package s2d.graphics.shaders.postprocessing;

#if S2D_PP_FISHEYE
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class FisheyePass extends PostProcessingPass {
	var positionCL:ConstantLocation;
	var strengthCL:ConstantLocation;

	override inline function getUniforms() {
		positionCL = pipeline.getConstantLocation("fisheyePosition");
		strengthCL = pipeline.getConstantLocation("fisheyeStrength");
	}

	override inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {
		g.setFloat2(positionCL, uniforms[0], uniforms[1]);
		g.setFloat(strengthCL, uniforms[2]);
	}
}
#end
