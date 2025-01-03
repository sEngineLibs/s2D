package s2d.graphics.shaders.postprocessing;

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
		g.setVector2(positionCL, uniforms[0]);
		g.setFloat(strengthCL, uniforms[1]);
	}
}
