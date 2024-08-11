class_name PerlinNoise

class PerlinNoiseLayer:
	var grid_size : Vector2i
	var cell_size : float
	var volume : int
	var gradients : Array[Vector2]
	
	func smootherstep(a0 : float, a1 : float, p : float) -> float:
		return (a1 - a0) * ((p * (p * 6.0 - 15.0) + 10.0) * p * p * p) + a0

	func _init(grid_size : Vector2i, cell_size : float):
		self.grid_size = grid_size
		self.cell_size = cell_size
		volume = (grid_size.x + 1) * (grid_size.y + 1)
		gradients.resize(volume)
		for i in range(0, volume):
			gradients[i] = Vector2.UP.rotated(randf_range(0, 2 * PI))

	func get_gradient(x : int, y : int, p : Vector2) -> float:
		return Vector2(p.x - x, p.y - y).dot(gradients[y * grid_size.x + x])

	func value(point : Vector2) -> float:
		var px : float = point.x / cell_size
		var py : float = point.y / cell_size
		var p : Vector2 = Vector2(px, py)
		var x : int = min(grid_size.x - 1, max(floor(px), 0))
		var y : int = min(grid_size.y - 1, max(floor(py), 0))
		px -= x
		py -= y
		var p00 : float = get_gradient(x, y, p)
		var p10 : float = get_gradient(x + 1, y, p)
		var p01 : float = get_gradient(x, y + 1, p)
		var p11 : float = get_gradient(x + 1, y + 1, p)
		return smootherstep(
			smootherstep(p00, p10, p.x - x),
			smootherstep(p01, p11, p.x - x),
			p.y - y
		)

var layers: Array[PerlinNoiseLayer]
var depth : int
var amplitudes : Array[float]
var normalization_coefficient : float
var base_cell_size : float
var base_resolution : Vector2i
var transformer : Callable


func _init(depth : int, base_resolution : Vector2i, base_cell_size : float,
		amplitudes : Array[float], transformer : Callable) -> void:
	self.depth = depth
	self.base_resolution = base_resolution
	self.base_cell_size = base_cell_size
	assert(amplitudes.size() == depth)
	self.amplitudes = amplitudes
	for a in amplitudes:
		normalization_coefficient += a
	self.transformer = transformer


func generate():
	layers.clear()
	var power : int = 1
	for i in range(depth):
		var new_layer : PerlinNoiseLayer = \
				PerlinNoiseLayer.new(base_resolution * power, base_cell_size)
		layers.push_back(new_layer)
		power *= 2
		base_cell_size /= 2


func value(point : Vector2) -> float:
	var v : float = 0
	for i in range(depth):
		v += amplitudes[i] * layers[i].value(point)
	return transformer.call(v / normalization_coefficient)
