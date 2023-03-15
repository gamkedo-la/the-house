extends StaticBody

onready var _mixing_area: Area = $mixing_area

class Ingredients:
	var ear : BodyEar
	var hand : BodyHand
	var foot : BodyFoot
	var eye : EyeBall
	var mushroom : Mushroom
	var gold : GoldBar
	
	func is_complete() -> bool:
		return ear and hand and foot and eye and mushroom and gold
	
	func all_ingredients() -> Array:
		return utility.without_null([ ear, hand, foot, eye, mushroom, gold ])
	
	
var _valid_ingredients : Ingredients

func _ready() -> void:
	_mixing_area.set_collision_mask_bit(CollisionLayers.player_interraction_raycast_layer_bit, true) # Try to detect only items which interracts with the player.
	_mixing_area.connect("body_entered", self, "_on_something_in_cauldron")


func _on_something_in_cauldron(thing) -> void:
	if thing is InteractiveItem:
		print("Something new in the cauldron: %s " % thing.name)
		if _is_recipe_complete():
			print("Recipe is complete: POUF!")
			_transform_into_golden_handshake()
		else:
			print("Recipe is not complete.")
			if _valid_ingredients:
				print("What we have that's in the recipe:")
				for ingredient in _valid_ingredients.all_ingredients():
					print("  - %s" % ingredient.name)
		
	

func _is_recipe_complete() -> bool:
	_valid_ingredients = Ingredients.new()
	var ingredients = _mixing_area.get_overlapping_bodies()
	for ingredient in ingredients:
		if ingredient is InteractiveItem:
			if ingredient is BodyEar:
				_valid_ingredients.ear = ingredient
			elif ingredient is BodyFoot:
				_valid_ingredients.foot = ingredient
			elif ingredient is EyeBall:
				_valid_ingredients.eye = ingredient
			elif ingredient is BodyHand:
				_valid_ingredients.hand = ingredient
			elif ingredient is GoldBar:
				_valid_ingredients.gold = ingredient
			elif ingredient is Mushroom and ingredient.is_magic_mushroom():
				_valid_ingredients.mushroom = ingredient
			if _valid_ingredients.is_complete():
				return true
	return false

const golden_hand_scene = preload("res://items/golden_hand.tscn")
func _transform_into_golden_handshake() -> void:
	assert(_valid_ingredients)
	for ingredient in _valid_ingredients.all_ingredients():
		ingredient.get_parent().remove_child(ingredient)
	# TODO: play some kind of effect here

	var golden_hand = golden_hand_scene.instance()
	$golden_hand_position.add_child(golden_hand)
