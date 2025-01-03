package s2d.graphics.shaders.postprocessing;

#if S2D_PP_COMPOSITOR
import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

@:allow(s2d.graphics.RenderPath)
class CompositorPass extends PostProcessingPass {
	var paramsCL:ConstantLocation;

	override inline function getUniforms() {
		paramsCL = pipeline.getConstantLocation("Params");
	}

	override inline function setUniforms(g:Graphics, ?uniforms:Array<Dynamic>) {
		g.setFloats(paramsCL, uniforms[0]);
	}
}
#end
