package s2d;

import haxe.ds.Vector;
import kha.Image;
// s2d
import s2d.objects.Sprite;
#if (S2D_LIGHTING == 1)
#if (S2D_LIGHTING_DEFERRED == 1)
import s2d.graphics.lighting.GeometryDeferred;
#else
import s2d.graphics.lighting.LightingForward;
#end
#else
import s2d.graphics.Renderer;
#end
#if (S2D_SPRITE_INSTANCING == 1)
import kha.graphics4.VertexBuffer;
#end

@:access(s2d.objects.Sprite)
@:access(s2d.graphics.Renderer)
class SpriteAtlas {
	@:isVar public var layer(default, set):Layer;
	public var sprites:Vector<Sprite> = new Vector(0);

	#if (S2D_LIGHTING == 1)
	public var albedoMap:Image;
	public var normalMap:Image;
	public var ormMap:Image;
	public var emissionMap:Image;
	#else
	public var textureMap:Image;
	#end

	public inline function new(layer:Layer) {
		this.layer = layer;
		#if (S2D_SPRITE_INSTANCING == 1)
		init();
		#end
	}

	inline function set_layer(value:Layer) {
		value.addSpriteAtlas(this);
		layer = value;
		return value;
	}

	#if (S2D_SPRITE_INSTANCING == 1)
	var vertices:Array<VertexBuffer>;

	inline function init() {
		vertices = [
			S2D.vertices,
			#if (S2D_LIGHTING == 1)
			#if (S2D_LIGHTING_DEFERRED == 1)
			new VertexBuffer(0, GeometryDeferred.structures[1], StaticUsage, 1), // crop rect
			new VertexBuffer(0, GeometryDeferred.structures[2], StaticUsage, 1), // model
			new VertexBuffer(0, GeometryDeferred.structures[3], StaticUsage, 1) // depth
			#else
			new VertexBuffer(0, LightingForward.structures[1], StaticUsage, 1), // crop rect
			new VertexBuffer(0, LightingForward.structures[2], StaticUsage, 1), // model
			new VertexBuffer(0, LightingForward.structures[3], StaticUsage, 1) // depth
			#end
			#else
			new VertexBuffer(0, Renderer.structures[1], StaticUsage, 1), // crop rect
			new VertexBuffer(0, Renderer.structures[2], StaticUsage, 1), // model
			new VertexBuffer(0, Renderer.structures[3], StaticUsage, 1) // depth
			#end
		];
	}

	public inline function addSprite(sprite:Sprite) {
		final tmp = sprites;
		sprites = new Vector(tmp.length + 1);

		for (i in 0...tmp.length)
			sprites[i] = tmp[i];
		sprites[tmp.length] = sprite;

		vertices[1].delete();
		vertices[2].delete();

		#if (S2D_LIGHTING == 1)
		#if (S2D_LIGHTING_DEFERRED == 1)
		vertices[1] = new VertexBuffer(sprites.length, GeometryDeferred.structures[1], StaticUsage, 1);
		vertices[2] = new VertexBuffer(sprites.length, GeometryDeferred.structures[2], StaticUsage, 1);
		vertices[3] = new VertexBuffer(sprites.length, GeometryDeferred.structures[3], StaticUsage, 1);
		#else
		vertices[1] = new VertexBuffer(sprites.length, LightingForward.structures[1], StaticUsage, 1);
		vertices[2] = new VertexBuffer(sprites.length, LightingForward.structures[2], StaticUsage, 1);
		vertices[3] = new VertexBuffer(sprites.length, LightingForward.structures[3], StaticUsage, 1);
		#end
		#else
		vertices[1] = new VertexBuffer(sprites.length, Renderer.structures[1], StaticUsage, 1);
		vertices[2] = new VertexBuffer(sprites.length, Renderer.structures[2], StaticUsage, 1);
		vertices[3] = new VertexBuffer(sprites.length, Renderer.structures[3], StaticUsage, 1);
		#end
	}

	inline function update() {
		#if (S2D_LIGHTING == 1)
		#if (S2D_LIGHTING_DEFERRED == 1)
		final cStructSize = GeometryDeferred.structures[1].byteSize() >> 2;
		final mStructSize = GeometryDeferred.structures[2].byteSize() >> 2;
		final dStructSize = GeometryDeferred.structures[3].byteSize() >> 2;
		#else
		final cStructSize = LightingForward.structures[1].byteSize() >> 2;
		final mStructSize = LightingForward.structures[2].byteSize() >> 2;
		final dStructSize = LightingForward.structures[3].byteSize() >> 2;
		#end
		#else
		final cStructSize = Renderer.structures[1].byteSize() >> 2;
		final mStructSize = Renderer.structures[2].byteSize() >> 2;
		final dStructSize = Renderer.structures[3].byteSize() >> 2;
		#end
		final cData = vertices[1].lock();
		final mData = vertices[2].lock();
		final dData = vertices[3].lock();
		final length = sprites.length;
		var i = 0;
		for (sprite in sprites) {
			final c = sprite.cropRect;
			final m = sprite._model;
			// crop rect
			final ci = i * cStructSize;
			cData[ci + 0] = c.x;
			cData[ci + 1] = c.y;
			cData[ci + 2] = c.z;
			cData[ci + 3] = c.w;
			// model
			final mi = i * mStructSize;
			mData[mi + 0] = m._00;
			mData[mi + 1] = m._01;
			mData[mi + 2] = m._02;
			mData[mi + 3] = m._10;
			mData[mi + 4] = m._11;
			mData[mi + 5] = m._12;
			mData[mi + 6] = m._20;
			mData[mi + 7] = m._21;
			mData[mi + 8] = m._22;
			// depth
			final di = i * dStructSize;
			dData[di] = i / length;
			++i;
		}
		vertices[1].unlock();
		vertices[2].unlock();
		vertices[3].unlock();
	}
	#end
}
