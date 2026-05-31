extends CanvasLayer

# --- CONFIGURAÇÃO DO FUTURO MENU ---
@export var cena_do_menu: PackedScene

# --- REFERÊNCIAS DOS NÓS ---
@onready var timer_5_min = $Timer5min
@onready var timer_2_min = $Timer2min
@onready var som_alerta = $AudioStreamPlayer2D
@onready var audio_voz = $AudioVoz # <-- ADICIONADO: O player dedicado para as falas reutilizáveis

# --- BANCO DE ÁUDIOS REUTILIZÁVEIS ---
var som_pergunta = preload("res://sprites/audios/reusable/perguntaAFK.mp3")
var som_sim = preload("res://sprites/audios/reusable/sim.mp3")
var som_nao = preload("res://sprites/audios/reusable/nao.mp3")

func _ready() -> void:
	self.hide()
	
	# Conexões dos cliques que você já tinha
	$Panel/ButtonSim.pressed.connect(_on_botao_sim_pressed)
	$Panel/ButtonNao.pressed.connect(_on_botao_nao_pressed)
	
	# --- ADICIONADO: Destrava os filtros de mouse para garantir o hover ---
	$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
	$Panel/ButtonSim.mouse_filter = Control.MOUSE_FILTER_STOP
	$Panel/ButtonNao.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# --- ADICIONADO: Conecta os sinais de passar o mouse automaticamente ---
	$Panel.mouse_entered.connect(_on_panel_mouse_entered)
	$Panel/ButtonSim.mouse_entered.connect(_on_sim_mouse_entered)
	$Panel/ButtonNao.mouse_entered.connect(_on_nao_mouse_entered)

func _input(_event: InputEvent) -> void:
	if not self.visible:
		timer_5_min.start()


# --- SINAIS DOS TIMERS ---

func _on_timer_5_min_timeout() -> void:
	self.show() 
	som_alerta.play() 
	
	# --- ADICIONADO: Toca a pergunta AFK imediatamente ao aparecer na tela! ---
	_tocar_fala_reusable(som_pergunta)
	
	timer_2_min.start() 

func _on_timer_2_min_timeout() -> void:
	executar_saida()


# --- SINAIS DE PASSAR O MOUSE (HOVER) ---

func _on_panel_mouse_entered() -> void:
	# Só toca se a tela estiver visível e se a voz da pergunta já não estiver rodando
	if self.visible and audio_voz != null and audio_voz.stream != som_pergunta:
		_tocar_fala_reusable(som_pergunta)

func _on_sim_mouse_entered() -> void:
	if self.visible:
		_tocar_fala_reusable(som_sim)

func _on_nao_mouse_entered() -> void:
	if self.visible:
		_tocar_fala_reusable(som_nao)

# --- FUNÇÃO AUXILIAR PARA TROCAR DE ÁUDIO INSTANTANEAMENTE ---
func _tocar_fala_reusable(audio_clipe: AudioStream) -> void:
	if audio_voz != null:
		audio_voz.stop() # Corta a voz anterior na hora (ex: passa o mouse do painel pro botão)
		audio_voz.stream = audio_clipe
		audio_voz.play()


# --- SINAIS DOS BOTÕES ---

func _on_botao_sim_pressed() -> void:
	print("O BOTAO SIM FOI CLICADO!") 
	if som_alerta.playing:
		som_alerta.stop()
		
	# --- ADICIONADO: Para a voz caso ela ainda esteja rodando ao clicar ---
	if audio_voz.playing:
		audio_voz.stop()
		
	self.hide() 
	timer_2_min.stop() 
	timer_5_min.start() 

func _on_botao_nao_pressed() -> void:
	if audio_voz.playing:
		audio_voz.stop()
	executar_saida()


# --- FUNÇÃO INTELIGENTE DE SAÍDA ---
func executar_saida() -> void:
	if cena_do_menu != null:
		get_tree().change_scene_to_file("res://scenes/fase1_1/fase_1_1.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/fase1_1/fase_1_1.tscn")
