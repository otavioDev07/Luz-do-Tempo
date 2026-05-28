extends Control

@onready var label = $Label
@onready var audio_player = $AudioStreamPlayer

# Variáveis para guardar o que está sendo falado no momento
# (Isso serve para caso o aluno clique no botão para repetir)
var texto_atual: String = ""

func _ready() -> void:
	# Começa totalmente invisível e limpo, esperando a fase mandar o comando
	label.text = ""
	label.visible_characters = 0

# ESTA É A FUNÇÃO QUE A SUA FASE VAI CHAMAR VIA CÓDIGO!
# Você passa o Texto, o Arquivo de Áudio, e escolhe se quer esperar 2 segundos ou não
func mudar_fala(novo_texto: String, novo_audio: AudioStream, esperar_2s: bool = false) -> void:
	# Salva os dados atuais
	texto_atual = novo_texto
	label.text = novo_text
	audio_player.stream = novo_audio
	
	# Zera o texto para a animação
	label.visible_characters = 0
	
	# Se você marcou 'true', o jogo espera os 2 segundos antes de começar
	if esperar_2s:
		await get_tree().create_timer(2.0).timeout
	
	# Executa a narração com a animação
	_iniciar_animacao()

# Função interna para rodar o áudio e o efeito typewriter
func _iniciar_animacao() -> void:
	if audio_player.stream:
		audio_player.play()
		label.visible_characters = 0
		
		var duracao_audio = audio_player.stream.get_length()
		var tween = create_tween()
		tween.tween_property(label, "visible_characters", label.text.length(), duracao_audio)
	else:
		# Caso mude o texto por código mas não coloque áudio, o texto aparece direto
		label.visible_characters = -1

# Se o aluno clicar no Avatar, ele repete apenas o áudio da fala atual
func _on_texture_button_pressed() -> void:
	if audio_player.stream:
		audio_player.play()
		label.visible_characters = -1 # Mantém o texto todo visível
