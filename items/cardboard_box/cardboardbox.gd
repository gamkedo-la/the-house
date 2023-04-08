extends Spatial

export var can_be_taken : bool = true

onready var _box = $"%cardboardbox"
onready var _mesh = $"%cardboard_box_mesh"


func _ready():
	_box.can_be_taken = can_be_taken
	if not can_be_taken:
		_box.mode = RigidBody.MODE_STATIC

	if Engine.editor_hint:
		return

	yield(global, "game_ready")
	assert(global.current_player)

	if not can_be_taken:
		if not global.cardboard_material_darker:
			global.cardboard_material_darker = _mesh.get_active_material(0).duplicate()
			var albedo = global.cardboard_material_darker.albedo_color
			global.cardboard_material_darker.albedo_color = albedo.darkened(0.5)
		_mesh.set_surface_material(0, global.cardboard_material_darker)
