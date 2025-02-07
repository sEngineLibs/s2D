package se.s2d.graphics;

import kha.Image;
#if (S2D_LIGHTING != 1)
import kha.Shaders;
import kha.graphics4.TextureUnit;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;
#else
#if (S2D_LIGHTING_SHADOWS == 1)
import se.s2d.graphics.lighting.ShadowPass;
#end
#if (S2D_LIGHTING_DEFERRED == 1)
import se.s2d.graphics.lighting.GeometryDeferred;
import se.s2d.graphics.lighting.LightingDeferred;
#else
import se.s2d.graphics.lighting.LightingForward;
#end
#end
class Renderer {
	static var commands:Array<Void->Void>;
	static var buffer:RenderBuffer;

	@:access(se.s2d.graphics.postprocessing.PPEffect)
	static function compile(width:Int, height:Int) {
		buffer = new RenderBuffer(width, height);

		#if (S2D_LIGHTING == 1)
		#if (S2D_LIGHTING_DEFERRED == 1)
		commands = [GeometryDeferred.render, LightingDeferred.render];
		GeometryDeferred.compile();
		LightingDeferred.compile();
		#else
		commands = [LightingForward.render];
		LightingForward.compile();
		#end
		#if (S2D_LIGHTING_SHADOWS == 1)
		ShadowPass.compile();
		#end
		#else
		commands = [_render];
		_compile();
		#end

		#if S2D_PP_BLOOM
		PostProcessing.bloom.index = 1;
		PostProcessing.bloom.enable();
		PostProcessing.bloom.compile();
		#end

		#if S2D_PP_FISHEYE
		PostProcessing.fisheye.index = 2;
		PostProcessing.fisheye.enable();
		PostProcessing.fisheye.compile();
		#end

		#if S2D_PP_FILTER
		PostProcessing.filter.index = 3;
		PostProcessing.filter.enable();
		PostProcessing.filter.compile();
		#end

		#if S2D_PP_COMPOSITOR
		PostProcessing.compositor.index = 4;
		PostProcessing.compositor.enable();
		PostProcessing.compositor.compile();
		#end
	}

	static function resize(width:Int, height:Int) {
		buffer.resize(width, height);
	}

	static function render():Image {
		for (command in commands)
			command();
		return buffer.tgt;
	}

	#if (S2D_LIGHTING != 1)
	static var structures:Array<VertexStructure> = [];
	static var pipeline:PipelineState;
	static var viewProjectionCL:ConstantLocation;
	#if (S2D_SPRITE_INSTANCING != 1) static var modelCL:ConstantLocation;
	static var cropRectCL:ConstantLocation; #end // S2D_SPRITE_INSTANCING
	static var textureMapTU:TextureUnit;

	static function _compile() {
		structures.push(new VertexStructure());
		structures[0].add("vertCoord", Float32_2X);

		#if (S2D_SPRITE_INSTANCING == 1)
		structures.push(new VertexStructure());
		structures[1].instanced = true;
		structures[1].add("cropRect", Float32_4X);
		structures.push(new VertexStructure());
		structures[2].instanced = true;
		structures[2].add("model0", Float32_3X);
		structures[2].add("model1", Float32_3X);
		structures[2].add("model2", Float32_3X);
		structures.push(new VertexStructure());
		structures[3].instanced = true;
		structures[3].add("depth", Float32_1X);
		#end // S2D_SPRITE_INSTANCING

		pipeline = new PipelineState();
		pipeline.inputLayout = structures;
		pipeline.vertexShader = Shaders.sprite_vert;
		pipeline.fragmentShader = Shaders.sprite_frag;
		pipeline.alphaBlendSource = SourceAlpha;
		pipeline.alphaBlendDestination = InverseSourceAlpha;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.compile();

		viewProjectionCL = pipeline.getConstantLocation("viewProjection");
		#if (S2D_SPRITE_INSTANCING != 1) modelCL = pipeline.getConstantLocation("model");
		cropRectCL = pipeline.getConstantLocation("cropRect"); #end // S2D_SPRITE_INSTANCING
		textureMapTU = pipeline.getTextureUnit("textureMap");
	}

	@:access(se.s2d.objects.Sprite)
	static function _render():Void {
		final g4 = Renderer.buffer.tgt.g4;

		g4.begin();
		g4.clear(Black);
		g4.setPipeline(pipeline);
		g4.setIndexBuffer(SEngine.indices);
		#if (S2D_SPRITE_INSTANCING != 1)
		g4.setVertexBuffer(SEngine.vertices);
		#end
		g4.setMatrix3(viewProjectionCL, Stage.current.viewProjection);
		for (layer in Stage.current.layers) {
			#if (S2D_SPRITE_INSTANCING == 1)
			for (atlas in layer.spriteAtlases) {
				@:privateAccess g4.setVertexBuffers(atlas.vertices);
				g4.setTexture(textureMapTU, atlas.textureMap);
				g4.drawIndexedVerticesInstanced(atlas.sprites.length);
			}
			#else
			for (sprite in layer.sprites) {
				g4.setMatrix3(modelCL, sprite.finalModel);
				g4.setVector4(cropRectCL, sprite.cropRect);
				g4.setTexture(textureMapTU, sprite.atlas.textureMap);
				g4.drawIndexedVertices();
			}
			#end
		}
		g4.end();
	}
	#end
}
