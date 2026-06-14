extends Control

@export var avatar_inicial: Texture2D
@onready var label = $Label
@onready var audio_player = $AudioStreamPlayer
@onready var botao_avatar = $TextureButton 

var texto_atual: String = ""

# --- VARIÁVEIS NOVAS PARA CORRIGIR O BUG ---
var tween_atual: Tween # Vai guardar a animação para podermos parar ela
var id_fala: int = 0 # Uma "senha" para evitar que áudios velhos toquem depois do 'await'

func _ready() -> void:
	if avatar_inicial != null and botao_avatar != null:
		botao_avatar.texture_normal = avatar_inicial


func mudar_fala(novo_texto: String, novo_audio: AudioStream, nova_imagem: Texture2D = null, esperar_1s: bool = false) -> void:
	# 1. Troca a senha para abortar qualquer espera (await) antiga que esteja rolando
	id_fala += 1
	var minha_senha = id_fala
	
	# 2. Mata a animação antiga se ela ainda estiver acontecendo!
	if tween_atual != null and tween_atual.is_valid():
		tween_atual.kill()
		
	# 3. Para o áudio antigo para não encavalar
	audio_player.stop()
	
	if nova_imagem != null:
		botao_avatar.texture_normal = nova_imagem
	
	# 4. Salva e aplica o texto e áudio
	texto_atual = novo_texto
	label.text = novo_texto
	audio_player.stream = novo_audio
	
	label.visible_characters = 0
	
	# Tempo de espera ajustado para 1.0 segundo
	if esperar_1s:
		await get_tree().create_timer(1.0).timeout
	
	# 5. Se o jogador clicou em outra coisa durante esse 1 segundo, a senha mudou! 
	# Então abortamos essa função velha para não tocar o áudio errado.
	if id_fala != minha_senha:
		return
		
	_iniciar_animacao()


func _iniciar_animacao() -> void:
	# Prevenção extra
	if tween_atual != null and tween_atual.is_valid():
		tween_atual.kill()
		
	if audio_player.stream:
		audio_player.play()
		label.visible_characters = 0
		
		var duracao_audio = audio_player.stream.get_length()
		
		# 6. Salva o Tween na variável para podermos ter controle sobre ele
		tween_atual = create_tween()
		tween_atual.tween_property(label, "visible_characters", label.text.length(), duracao_audio)
	else:
		# Caso mude o texto por código mas não coloque áudio, o texto aparece direto
		label.visible_characters = -1


func _on_texture_button_pressed() -> void:
	# Se o jogador clicar no avatar para repetir, mata a animação de digitação
	if tween_atual != null and tween_atual.is_valid():
		tween_atual.kill()
		
	if audio_player.stream:
		audio_player.stop() # Para e toca de novo para não bugar
		audio_player.play()
		label.visible_characters = -1 # Mantém o texto todo visível
