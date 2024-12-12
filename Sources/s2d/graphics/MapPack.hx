package s2d.graphics;

import kha.Color;
import kha.Image;

enum abstract MapPack(Array<Image>) from Array<Image> to Array<Image> {
	public inline function new(width:Int, height:Int, ?mapCount:Int = 4) {
		this = [];

		for (_ in 0...mapCount)
			this.push(Image.createRenderTarget(width, height));
	}

	public var width(get, never):Int;
	public var height(get, never):Int;
	public var count(get, never):Int;

	inline function get_width():Int {
		return this[0].width;
	}

	inline function get_height():Int {
		return this[0].height;
	}

	inline function get_count():Int {
		return this.length;
	}

	public inline function resize(width:Int, height:Int):Void {
		if (width > 0 && height > 0) {
			for (i in 0...this.length) {
				var img = Image.createRenderTarget(width, height);
				img.g2.begin(true, Color.Transparent);
				img.g2.drawScaledImage(this[i], 0, 0, width, height);
				img.g2.end();

				this[i] = img;
			}
		}
	}

	public inline function setMap(i:Int, value:Image) {
		this[i].g2.begin(true, Color.Transparent);
		this[i].g2.drawScaledImage(value, 0, 0, width, height);
		this[i].g2.end();
	}

	public inline function setMapColor(i:Int, color:Color):Void {
		this[i].g2.begin(true, Color.Transparent);
		this[i].g2.color = color;
		this[i].g2.fillRect(0, 0, width, height);
		this[i].g2.color = Color.White;
		this[i].g2.end();
	}
}
