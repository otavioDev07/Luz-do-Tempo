extends Control

@onready var label = $Label
@onready var audio_player = $AudioStreamPlayer
@onready var botao_avatar = $TextureButton # Certifique-se que o nome aqui é igual ao da sua árvore

var texto_atual: String = ""

# Adicionamos 'nova_imagem' na lista de coisas que a função recebe
func mudar_fala(novo_texto: String, novo_audio: AudioStream, nova_imagem: Texture2D = null, esperar_2s: bool = false) -> void:
	# 1. Troca a imagem do botão se você enviar uma nova
	if nova_imagem != null:
		botao_avatar.texture_normal = nova_imagem
	
	# 2. Salva e aplica o texto e áudio (como já fazíamos)
	texto_atual = novo_texto
	label.text = novo_texto
	audio_player.stream = novo_audio
	
	label.visible_characters = 0
	
	if esperar_2s:
		await get_tree().create_timer(2.0).timeout
	
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
