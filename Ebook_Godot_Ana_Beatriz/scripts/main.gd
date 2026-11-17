extends Control
const TAMANHO := Vector2(768, 1024)
const FALAS := [
	"Fenômenos Ondulatórios e Acústica. Explore como as ondas se comportam e como o som chega até você. Ana Beatriz Oliveira Vanderlei, dois mil e vinte e seis, segundo semestre.",
	"As ondas são perturbações que se propagam por um meio ou pelo espaço, transportando energia de um lugar para outro, sem transportar matéria de forma líquida junto com sua propagação.
	Elas estão presentes em diversas situações do nosso cotidiano, como o som que ouvimos e as ondas que se formam na água.
	Amplitude é a altura de cada onda em relação à linha de equilíbrio. Quanto maior a amplitude, maior a intensidade do som. 
	Frequência é a quantidade de oscilações que acontecem por segundo. Quanto maior a frequência, mais agudo é o som. 
	Comprimento da onda É a distância entre duas cristas (ou velas) consecutivas. Quanto maior o comprimento da onda, menor a frequência. 
	Fonte: Borges e Rodrigues (2013).",
	"Referências. Borges e Rodrigues, Introdução à física acústica, dois mil e treze. Lazzarini, Elementos de acústica, mil novecentos e noventa e oito. Möser, Engineering acoustics, dois mil e nove.",
    "Fenômenos Ondulatórios e Acústica. Explore como as ondas se comportam e como o som chega até você. Orientador, professor Ewerton Mendonça. Ana Beatriz Oliveira Vanderlei, dois mil e vinte e seis, segundo semestre. Disciplina, Computação Gráfica e Sistemas Multimídia."
]
@onready var conteudo: Control = $Conteudo
@onready var paginas: Array[Control] = [$Conteudo/Capa, $Conteudo/Ondas, $Conteudo/Referencias, $Conteudo/Contracapa]
@onready var amplitude: Control = $Conteudo/Ondas/ControleAmplitude
@onready var frequencia: Control = $Conteudo/Ondas/ControleFrequencia
@onready var comprimento: Control = $Conteudo/Ondas/ControleComprimento
@onready var grafico: Onda = $Conteudo/Ondas/OndaInterativa
@onready var animacao: AnimationPlayer = $Conteudo/Ondas/AnimacaoOnda
var pagina_atual := 0
var audio_ativo := true
var voz := ""

func _ready() -> void:
	resized.connect(_ajustar)
	for pagina in paginas:
		pagina.get_node("BotaoAudio").alternar.connect(_alternar_audio)
	for botao in get_tree().get_nodes_in_group("navegacao"):
		botao.navegar.connect(_abrir)
	amplitude.alterado.connect(_atualizar_onda)
	frequencia.alterado.connect(_atualizar_onda)
	comprimento.alterado.connect(_atualizar_onda)
	voz = _escolher_voz()
	_ajustar()
	_atualizar_onda(0.0)
	_abrir(0)

func _escolher_voz() -> String:
	if not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		return ""
	var alternativa := ""
	for item in DisplayServer.tts_get_voices():
		var idioma := str(item.get("language", "")).to_lower().replace("_", "-")
		if idioma.begins_with("pt-br"):
			return str(item.get("id", ""))
		if idioma.begins_with("pt") and alternativa.is_empty():
			alternativa = str(item.get("id", ""))
	return alternativa

func _narrar() -> void:
	if not audio_ativo or not DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		return
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(FALAS[pagina_atual], voz, 75, 1.0, 1.0, pagina_atual, true)

func _abrir(indice: int) -> void:
	if indice < 0 or indice >= paginas.size():
		return
	DisplayServer.tts_stop()
	pagina_atual = indice
	for i in range(paginas.size()):
		paginas[i].visible = i == indice
	if indice == 1:
		animacao.play("movimento")
	else:
		animacao.stop()
	_narrar()

func _alternar_audio() -> void:
	audio_ativo = not audio_ativo
	if audio_ativo:
		DisplayServer.tts_resume()
	else:
		DisplayServer.tts_pause()

func _atualizar_onda(_valor: float) -> void:
	grafico.amplitude = 9.0 + amplitude.obter_valor() * 3.2
	grafico.comprimento = 160.0 - frequencia.obter_valor() * 9.0 + comprimento.obter_valor() * 6.0
	animacao.speed_scale = 0.4 + frequencia.obter_valor() * 0.2

func _ajustar() -> void:
	var escala := minf(size.x / TAMANHO.x, size.y / TAMANHO.y)
	conteudo.scale = Vector2.ONE * escala
	conteudo.position = (size - TAMANHO * escala) / 2.0

func _exit_tree() -> void:
	DisplayServer.tts_stop()
