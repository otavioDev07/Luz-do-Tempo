extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $Avatar/Mensagem
@onready var mensagem_acerto = $Avatar/MensagemDeAcerto
@onready var mensagem_erro = $Avatar/MensagemDeErro

@onready var botao_celular = $BotaoCelular
@onready var botao_telefone = $BotaoTelefone

# Carregamos as imagens diretamente via código
var fundo_acerto_img = preload("res://sprites/telas/ligacao_celular.png")
var fundo_erro_img = preload("res://sprites/telas/ligacao_fixo.png")

func _ready():
	mensagem_acerto.hide()
	mensagem_erro.hide()

func _on_botao_celular_pressed():
	# 1. Esconde a pergunta e os botões
	mensagem_pergunta.hide()
	botao_celular.hide()
	botao_telefone.hide()
	
	# 2. Mostra a mensagem de acerto
	mensagem_acerto.show()
	
	# 3. Troca o fundo
	fundo.texture = fundo_acerto_img
		
	# 4. Espera e muda de cena
	await get_tree().create_timer(3.0).timeout

func _on_botao_telefone_pressed():
	# 1. Esconde a pergunta e os botões
	mensagem_pergunta.hide()
	botao_celular.hide()
	botao_telefone.hide()
	
	# 2. Mostra a mensagem de erro
	mensagem_erro.show()
	
	# 3. Troca o fundo
	fundo.texture = fundo_erro_img
		
	# 4. Espera e reinicia
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
