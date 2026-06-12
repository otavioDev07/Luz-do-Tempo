extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $Avatar/Mensagem
@onready var mensagem_acerto = $Avatar/MensagemDeAcerto
@onready var mensagem_erro = $Avatar/MensagemDeErro
@onready var botao_lampada = $BotaoLampada
@onready var botao_vela = $BotaoVela

@export var imagem_lampada: Texture2D
@export var imagem_vela: Texture2D

func _ready():
	mensagem_acerto.hide()
	mensagem_erro.hide()

func _on_botao_lampada_pressed():
	mensagem_pergunta.hide()
	mensagem_acerto.show()
	botao_lampada.hide()
	botao_vela.hide()
	fundo.texture = imagem_lampada
	
	# REMOVI O GameManager.resetar_erros() DAQUI
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/fase2/fase2_1.tscn")

func _on_botao_vela_pressed():
	mensagem_pergunta.hide()
	mensagem_erro.show()
	botao_lampada.hide()
	botao_vela.hide()
	fundo.texture = imagem_vela
	
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
