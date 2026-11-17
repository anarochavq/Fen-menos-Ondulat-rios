extends Control
class_name Onda
@export var amplitude := 24.0:
    set(v):
        amplitude = v
        queue_redraw()
@export var comprimento := 90.0:
    set(v):
        comprimento = v
        queue_redraw()
@export var fase := 0.0:
    set(v):
        fase = v
        queue_redraw()

func _draw() -> void:
    var pontos := PackedVector2Array()
    for i in range(401):
        var x := size.x * float(i) / 400.0
        pontos.append(Vector2(x, size.y * 0.5 - amplitude * sin(TAU * x / comprimento - fase)))
    draw_polyline(pontos, Color("#9fdcff"), 8.0, true)
    draw_polyline(pontos, Color("#008df7"), 4.0, true)
