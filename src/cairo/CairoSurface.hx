package cairo;

class CairoSurface {
	private var handle:Dynamic;
	public var format(get, never):CairoSurfaceFormat;
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var stride(get, never):Int;

	public function new(handle:Dynamic) {
		if (handle == null) throw "Couldn't create surface";
		this.handle = handle;
	}

	private function get_format() return cast(CairoRaw.cairo_image_surface_get_format(handle), CairoSurfaceFormat);
	private function get_width() return CairoRaw.cairo_image_surface_get_width(handle);
	private function get_height() return CairoRaw.cairo_image_surface_get_height(handle);
	private function get_stride() return CairoRaw.cairo_image_surface_get_stride(handle);

	static public function create(format:CairoSurfaceFormat, width:Int, height:Int):CairoSurface {
		return new CairoSurface(CairoRaw.cairo_image_surface_create(format, width, height));
	}

	static public function createFromPng(filename:String):CairoSurface {
		return new CairoSurface(CairoRaw.cairo_image_surface_create_from_png(filename));
	}

	//static public function createForPDF(filename:String, width:Float, height:Float):CairoSurface {
	//	return new CairoSurface(CairoRaw.cairo_pdf_surface_create(filename, width, height));
	//}

	public function getContext():CairoContext {
		return new CairoContext(CairoRaw.cairo_create(this.handle));
	}

	public function writeToPng(path:String) {
		CairoRaw.cairo_surface_write_to_png(this.handle, path);
	}

	public function toString() {
		return 'CairoSurface(format=$format, ${width}x${height}, stride=$stride)';
	}
}
