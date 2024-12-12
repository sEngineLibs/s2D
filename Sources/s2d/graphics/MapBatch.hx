package s2d.graphics;

import kha.Color;
import kha.Image;

enum abstract MapBatch(Array<Image>) from Array<Image> to Array<Image> {
	public var packsCount(get, never):Int;
	public var packsCapacity(get, never):Int;
	public var width(get, never):Int;
	public var height(get, never):Int;

	inline function get_width():Int {
		return this[0].width;
	}

	inline function get_height():Int {
		return this[0].height;
	}

	inline function get_packsCount():Int {
		return Std.int(height / width);
	}

	inline function get_packsCapacity():Int {
		return Std.int(Image.maxSize / width);
	}

	public inline function new(resolution:Int, ?mapCount:Int = 4) {
		this = [];
		for (_ in 0...mapCount)
			this.push(Image.createRenderTarget(resolution, resolution));
	}

	public inline function extend():Void {
		var w = width;
		var h = height + w;

		for (i in 0...this.length) {
			var img = Image.createRenderTarget(w, h);
			img.g2.begin(true, Color.Transparent);
			img.g2.drawImage(this[i], 0, 0);
			img.g2.end();
			this[i] = img;
		}
	}

	public inline function resize(resolution:Int):Void {
		if (resolution > 0) {
			for (i in 0...this.length) {
				var img = Image.createRenderTarget(resolution, resolution);
				img.g2.begin(true, Color.Transparent);
				img.g2.drawScaledImage(this[i], 0, 0, resolution, resolution);
				img.g2.end();

				this[i] = img;
			}
		}
	}

	public inline function getMapInstance(mapID:Int, instanceID:Int):Image {
		var map = Image.createRenderTarget(width, width);
		map.g2.begin(true, Color.Transparent);
		map.g2.drawScaledSubImage(this[mapID], 0, instanceID * width, width, width, 0, 0, width, width);
		map.g2.end();
		return map;
	}

	public inline function setMapInstance(mapID:Int, instanceID:Int, value:Image):Void {
		var mapRect = [0, instanceID * width, width, width];

		this[mapID].g2.scissor(mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this[mapID].g2.begin(true, Color.Transparent);
		this[mapID].g2.drawScaledImage(value, mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this[mapID].g2.end();
		this[mapID].g2.disableScissor();
	}

	public inline function deleteMapPack(instanceID:Int):Void {
		for (i in 0...this.length) {
			var img = Image.createRenderTarget(width, height - width);
			img.g2.begin(true, Color.Transparent);
			img.g2.drawSubImage(this[instanceID], 0, 0, 0, 0, width, width * instanceID);
			img.g2.drawSubImage(this[instanceID], 0, 0, 0, width * (instanceID + 1), width, width * (packsCount - instanceID - 1));
			img.g2.end();

			this[i] = img;
		}
	}

	public inline function setMapInstanceColor(mapID:Int, instanceID:Int, color:Color):Void {
		var mapRect = [0, instanceID * width, width, width];

		this[mapID].g2.scissor(mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this[mapID].g2.begin(true, Color.Transparent);
		this[mapID].g2.color = color;
		this[mapID].g2.fillRect(mapRect[0], mapRect[1], mapRect[2], mapRect[3]);
		this[mapID].g2.color = Color.White;
		this[mapID].g2.end();
		this[mapID].g2.disableScissor();
	}
}
