#tool
extends MultiMeshInstance

export var extents := Vector2.ONE setget _set_extents

var _is_ready := false

func _ready() -> void:
	multimesh = multimesh.duplicate(true)
	_is_ready = true
	_update()
	
func _update()-> void:
	if not _is_ready:
		return
		
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var theta := 0
	var increase := 1
	var center: Vector3 = global_transform.origin

	for i in multimesh.instance_count:
		var transform := Transform().rotated(Vector3.UP, rng.randf_range(-PI / 2, PI / 2))
		var x: float
		var z: float

		x = rng.randf_range(-extents.x, extents.x)
		z = rng.randf_range(-extents.y, extents.y)
		transform.origin = Vector3(x , 0, z)

		multimesh.set_instance_transform(i, transform)
		multimesh.set_instance_custom_data(i, Color(rng.randf(), 0, rng.randf(), 0))

func _set_extents(value: Vector2) -> void:
	extents = value
	_update()
