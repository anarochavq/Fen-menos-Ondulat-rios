extends Button
signal alternar
func _ready() -> void:
	pressed.connect(func() -> void: alternar.emit())
