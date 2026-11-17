extends Control
signal alterado(valor: float)
@export var cor := Color("#7958f2")
@export_range(1, 10, 1) var valor_inicial := 8
@onready var barra: HSlider = $Barra
@onready var numero: Label = $Numero

func _ready() -> void:
    var fundo := StyleBoxFlat.new()
    fundo.bg_color = Color("#bdd6eb")
    fundo.set_corner_radius_all(5)
    fundo.content_margin_top = 3.0
    fundo.content_margin_bottom = 3.0
    var cheio := StyleBoxFlat.new()
    cheio.bg_color = cor
    cheio.set_corner_radius_all(5)
    cheio.content_margin_top = 3.0
    cheio.content_margin_bottom = 3.0
    barra.add_theme_stylebox_override("slider", fundo)
    barra.add_theme_stylebox_override("grabber_area", cheio)
    barra.add_theme_stylebox_override("grabber_area_highlight", cheio)
    var esfera := _esfera()
    barra.add_theme_icon_override("grabber", esfera)
    barra.add_theme_icon_override("grabber_highlight", esfera)
    barra.value = valor_inicial
    barra.value_changed.connect(_mudar)
    _mudar(barra.value)

func _esfera() -> ImageTexture:
    var img := Image.create(24, 24, false, Image.FORMAT_RGBA8)
    img.fill(Color.TRANSPARENT)
    for y in range(24):
        for x in range(24):
            var r := Vector2(x - 11.5, y - 11.5).length()
            if r <= 9.5:
                img.set_pixel(x, y, cor)
            elif r <= 11.5:
                img.set_pixel(x, y, Color.WHITE)
    return ImageTexture.create_from_image(img)

func _mudar(valor: float) -> void:
    numero.text = str(int(valor))
    alterado.emit(valor)

func obter_valor() -> float:
    return barra.value
