extends Control

@export var avatar_inicial: Texture2D
@onready var label = $Label
@onready var audio_player = $AudioStreamPlayer
@onready var botao_avatar = $TextureButton 

var texto_atual: String = ""

func _ready() -> void:
	if avatar_inicial != null and botao_avatar != null:
		botao_avatar.texture_normal = avatar_inicial

func mudar_fala(novo_texto: String, novo_audio: AudioStream, nova_imagem: Texture2D = null, esperar_2s: bool = false) -> void:
	if nova_imagem != null:
		botao_avatar.texture_normal = nova_imagem
	
	# 2. Salva e aplica o texto e áudio
	texto_atual = novo_texto
	label.text = novo_texto
	audio_player.stream = novo_audio
	
	label.visible_characters = 0
	
	if esperar_2s:
		await get_tree().create_timer(2.0).timeout
	
	_iniciar_animacao()

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

func _on_texture_button_pressed() -> void:
	if audio_player.stream:
		audio_player.play()
		label.visible_characters = -1 # Mantém o texto todo visível
