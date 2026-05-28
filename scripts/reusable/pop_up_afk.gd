extends CanvasLayer

# --- CONFIGURAÇÃO DO FUTURO MENU ---
# Esta linha cria um campo no Inspector. 
# Quando tiveres o teu menu pronto, basta arrastá-lo para lá!
@export var cena_do_menu: PackedScene

# --- REFERÊNCIAS DOS NÓS ---
@onready var timer_5_min = $Timer5min
@onready var timer_2_min = $Timer2min
@onready var som_alerta = $AudioStreamPlayer2D

func _ready() -> void:
	self.hide()
	$Panel/ButtonSim.pressed.connect(_on_botao_sim_pressed)
	$Panel/ButtonNao.pressed.connect(_on_botao_nao_pressed)

func _input(_event: InputEvent) -> void:
	if not self.visible:
		timer_5_min.start()


# --- SINAIS DOS TIMERS ---

func _on_timer_5_min_timeout() -> void:
	self.show() 
	som_alerta.play() 
	timer_2_min.start() 

func _on_timer_2_min_timeout() -> void:
	executar_saida()


# --- SINAIS DOS BOTÕES ---

func _on_botao_sim_pressed() -> void:
	print("O BOTAO SIM FOI CLICADO!") # Adicione esta linha!
	if som_alerta.playing:
		som_alerta.stop()
		
	self.hide() 
	timer_2_min.stop() 
	timer_5_min.start() 

func _on_botao_nao_pressed() -> void:
	executar_saida()


# --- FUNÇÃO INTELIGENTE DE SAÍDA ---
func executar_saida() -> void:
	# O código verifica: "O programador já colocou a cena do menu no Inspector?"
	if cena_do_menu != null:
		# Se SIM, ele vai para o menu!
		get_tree().change_scene_to_packed(cena_do_menu)
	else:
		# Se NÃO (enquanto estás a testar agora), ele apenas reinicia a fase atual
		get_tree().reload_current_scene()
