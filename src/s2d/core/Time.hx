package s2d.core;

import kha.System;

@:allow(s2d.App)
class Time {
	public static var realTime:Float = 0.0;
	public static var time:Float = 0.0;
	public static var delta:Float = 0.0;
	public static var scale:Float = 1.0;

	static var timeListeners:Array<TimeListener> = [];
	static var realTimeListeners:Array<TimeListener> = [];

	/**
	 * Adds a time listener
	 * @param callback A function to call
	 * @param time Timestamp in seconds
	 * @return Returns a listener
	 */
	public static function notifyOnTime(callback:Void->Void, time:Float) {
		var listener = {f: callback, time: time};
		timeListeners.push(listener);
		return listener;
	}

	/**
	 * Adds a real time listener
	 * @param callback A function to call
	 * @param time Real timestamp in seconds
	 * @return Returns a listener
	 */
	public static function notifyOnRealTime(callback:Void->Void, time:Float) {
		var listener = {f: callback, time: time};
		realTimeListeners.push(listener);
		return listener;
	}

	static function update() {
		final rt = System.time;
		delta = (rt - realTime) * scale;
		realTime = rt;
		time += delta;
		for (l in timeListeners) {
			if (time >= l.time) {
				l.f();
				timeListeners.remove(l);
			}
		}
		for (l in realTimeListeners) {
			if (time >= l.time) {
				l.f();
				realTimeListeners.remove(l);
			}
		}
	}
}

typedef TimeListener = {
	f:Void->Void,
	time:Float
}
