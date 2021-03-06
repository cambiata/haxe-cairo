import cairo.CairoRectangleInt;
import cairo.CairoRegion;
import cairo.CairoPoint;
import cairo.CairoFontWeight;
import cairo.CairoFontSlant;
import cairo.CairoMatrix;
import cairo.CairoAntialias;
import cairo.CairoPattern;
import sys.io.FileInput;
import sys.io.File;
import haxe.io.BytesOutput;
import cairo.CairoSurface;
import cairo.Cairo;
import cairo.CairoSurfaceFormat;

class Test {
	static public function main() {
		trace('Cairo version: ' + Cairo.getVersionString());

		var surface = CairoSurface.create(CairoSurfaceFormat.ARGB32, 256, 256);
		//var surface = CairoSurface.createForSvg("output.svg", 200, 200);
		//var surface = CairoSurface.createForPdf("output.pdf", 200, 200);
		trace(surface);
		var context = surface.getContext();
		context.saveRestore(function() {
			context.setSourceRgba(1, 0, 0, 1);
			context.rectangle(10, 10, 50, 50);
			context.fill();
			var gradient = CairoPattern.createLinear(30, 30, 70, 70).addColorStopRgb(0, 0.5, 0, 0).addColorStopRgb(1, 0, 0, 1);
			context.setSource(gradient);
			trace('color stop count 2 == ', gradient.getColorStops());
			context.rectangle(30, 30, 70, 70);
			context.fill();

			context.saveRestore(function() {
				context.setAntialias(CairoAntialias.SUBPIXEL);
				context.transform(new CairoMatrix().setToRotate(1));
				context.setSourceRgba(0, 0, 1, 1);
				context.rectangle(100, 30, 70, 70);
				trace('path extents', context.getPathExtents());
				context.fill();
			});

			context.saveRestore(function() {
				context.setAntialias(CairoAntialias.SUBPIXEL);
				context.transform(new CairoMatrix().setToRotate(0.5));
				context.setSourceRgba(0, 1, 0, 1);
				context.rectangle(100, 30, 70, 70);
				context.setLineWidth(5);
				context.setDashes([10, 3, 20], 5);
				trace('dashes', context.getDashes());
				context.stroke();
			});

			trace('status', context.getStatus());
		});
		context.saveRestore(function() {
			context.translate(50, 50);
			context.selectFontFace("Arial", CairoFontSlant.NORMAL, CairoFontWeight.NORMAL);
			context.setFontSize(50);

			trace('First time, this could take a while, it seems that it is building a font cache...');
			context.showText('Hello World!');
		});

		//surface.flush();
		//surface.finish();
		//surface.destroy();
		//surface.writeToPng('output.png');
		File.saveBytes("output2.png", surface.getPngBytes());
		//trace(output.getBytes().length);
		trace('clip extents', context.getClipExtents());
		
		var matrix = new CairoMatrix();
		matrix.setToScale(2, 2);
		trace(matrix.transformPoint(new CairoPoint(10, 10)));

		testStreams();
		testRegions();
		testData();
	}

	static private function testData() {
		var surface = CairoSurface.create(CairoSurfaceFormat.ARGB32, 256, 256);
		var context = surface.getContext();
		context.saveRestore(function() {
			context.translate(50, 0);
			context.saveRestore(function() {
				context.setAntialias(CairoAntialias.SUBPIXEL);
				context.transform(new CairoMatrix().setToRotate(0.5));

				context.setSourceRgba(1, 0, 0, 1);
				context.rectangle(10, 10, 100, 100);
				context.fill();

				var gradient = CairoPattern.createLinear(30, 30, 70, 70).addColorStopRgb(0, 0.5, 0, 0).addColorStopRgb(1, 0, 0, 1);
				context.setSource(gradient);
				trace('color stop count 2 == ', gradient.getColorStops());
				context.rectangle(30, 30, 70, 70);
				context.fill();

			});
			/*
			var gradient = CairoPattern.createLinear(30, 30, 70, 70).addColorStopRgb(0, 0.5, 0, 0).addColorStopRgb(1, 0, 0, 1);
			context.setSource(gradient);
			context.rectangle(30, 30, 70, 70);
			context.fill();
			*/
		});
		//neko.vm.Gc.run(true);
		//var data = surface.getData();
		//trace(data);
		surface.blur(0, 20);
		surface.writeToPng('output_blur.png');
	}

	static private function testStreams() {
		var surface2 = CairoSurface.createFromPngStream(File.read("output2.png")).createForRectangle(50, 50, 100, 100);
		surface2.writeToPngStream(File.write("output3.png"));

		//var surface3 = CairoSurface.createForSvgStream(File.write("output4.svg"), 100, 100);
		//var context = surface3.getContext();
		//context.setSourceRgb(1, 0, 0);
		//context.rectangle(0, 0, 100, 100);
		//context.fill();
	}

	static private function testRegions() {
		var region = CairoRegion.create();
		trace('numRects', region.getNumRectangles());
		region.unionRectangle(new CairoRectangleInt(0, 0, 100, 100));
		trace('numRects', region.getNumRectangles());
		trace('contains', region.containsRectangle(new CairoRectangleInt(0, 0, 50, 50)));
		trace('contains', region.containsRectangle(new CairoRectangleInt(-10, -10, 50, 50)));
		trace('contains', region.containsRectangle(new CairoRectangleInt(-50, -50, 50, 50)));
		region.xorRectangle(new CairoRectangleInt(50, 50, 100, 100));
		trace('extent', region.getExtents());
		trace('rectangles', region.getRectangles());
	}
}
