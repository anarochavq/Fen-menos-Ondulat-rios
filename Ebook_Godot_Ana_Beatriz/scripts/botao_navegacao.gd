extends Button
signal navegar(destino: int)
@export_range(0, 3) var destino := 0
func _ready() -> void:
	pressed.connect(func() -> void: navegar.emit(destino))
