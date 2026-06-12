extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $Avatar/Mensagem
@onready var mensagem_acerto = $Avatar/MensagemDeAcerto
@onready var mensagem_erro = $Avatar/MensagemDeErro
@onready var botao_carro = $BotaoCarro
@onready var botao_carroca = $BotaoCarroca
@onready var node_carro = $Carro
@onready var node_carroca = $Carroca
#Você vai arrastar as imagens "centralizadas" para estes campos no Inspetor

func _ready():
	mensagem_acerto.hide()
	mensagem_erro.hide()

func _on_botao_carro_pressed():
	mensagem_pergunta.hide()
	botao_carro.hide()
	botao_carroca.hide()
	
	mensagem_acerto.show()
	node_carro.show() # Mostra apenas o nó do carro
	node_carroca.hide() # Garante que a carroça continue escondida
		
	await get_tree().create_timer(3.0).timeout
	# ... (lógica de troca de cena)
	get_tree().change_scene_to_file("res://scenes/fase2/fase2_2.tscn")

func _on_botao_carroca_pressed():
	mensagem_pergunta.hide()
	botao_carro.hide()
	botao_carroca.hide()
	
	mensagem_erro.show()
	node_carroca.show() # Mostra apenas o nó da carroça
	node_carro.hide()   # Garante que o carro continue escondido
		
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()


func _on_botao_carroca_mouse_entered() -> void:
	$BotaoCarroca/AudioCarroca.play()


func _on_botao_carro_mouse_entered() -> void:
	$BotaoCarro/AudioCarro.play()
