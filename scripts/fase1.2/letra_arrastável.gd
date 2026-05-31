extends Label

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _get_drag_data(_at_position):
	var preview = Label.new()
	preview.text = text
	preview.label_settings = load("res://fonts/fontefase1.2.tres")
	set_drag_preview(preview)
	
	return text
