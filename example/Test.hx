import cairo.*;

class Test {
	static public function main() {
		trace('Cairo version: ' + Cairo.getVersion());
		var surface = CairoSurface.create(CairoSurfaceFormat.ARGB32, 256, 256);
		trace(surface);
		var context = surface.getContext();
		context.saveRestore(function() {
			context.setSourceRgba(1, 0, 0, 1);
			context.rectangle(10, 10, 50, 50);
			context.fill();
			context.setSourceRgba(0, 1, 0, 1);
			context.rectangle(30, 30, 70, 70);
			context.fill();
			context.saveRestore(function() {
				context.transform(new CairoMatrix().setToRotate(1));
				context.setSourceRgba(0, 0, 1, 1);
				context.rectangle(100, 30, 70, 70);
				context.fill();
			});
		});
		surface.writeToPng('output.png');
	}
}
