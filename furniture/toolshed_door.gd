tool
extends Door


func _ready():
	find_node("lock").connect("unlocked", self, "_on_lock_unlocked")
	_sounds["locked"] = null

func _on_lock_unlocked(_key_name):
	unlock()

