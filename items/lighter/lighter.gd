extends InteractiveItem

var _used_at_least_once := false

func _ready():
	connect("on_taken_by_player", self, "_on_taken_by_player")
	connect("on_dropped_by_player", self, "_on_dropped_by_player")
	connect("use_item", self, "_on_activated")

func _on_taken_by_player(_lighter) -> void:
	if not _used_at_least_once:
		global.current_player.info_display.display_text_sequence(["Right Mouse Button -> [b]Activate or deactivate item[/b]"])

func _on_dropped_by_player(_lighter) -> void:
	if not _used_at_least_once:
		global.current_player.info_display.stop_display_sequence()

func _on_activated(_lighter) -> void:
	if not _used_at_least_once:
		_used_at_least_once = true
		global.current_player.info_display.stop_display_sequence()
