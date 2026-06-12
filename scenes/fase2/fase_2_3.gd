extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $Avatar/Mensagem
@onready var mensagem_acerto = $Avatar/MensagemDeAcerto
@onready var mensagem_erro = $Avatar/MensagemDeErro

@onready var botao_celular = $BotaoCelular
@onready var botao_telefone = $BotaoTelefone

# Caminhos atualizados para a Fase 2.3
var fundo_acerto_img = preload("res://sprites/telas/cozinha_microondas.png")
var fundo_erro_img = preload("res://sprites/telas/cozinha_fogao.png")

# Defina aqui para qual cena você quer ir após o acerto
@export_file("*.tscn") var proxima_cena_caminho: String

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
		
	# 4. Espera e muda de cena (agora usando a variável exportada)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/fase2/fase_2_4.tscn")

func _on_botao_telefone_pressed():
	# 1. Esconde a pergunta e os botões
	mensagem_pergunta.hide()
	botao_celular.hide()
	botao_telefone.hide()
	
	# 2. Mostra a mensagem de erro
	mensagem_erro.show()
	
	# 3. Troca o fundo
	fundo.texture = fundo_erro_img
		
	# 4. Espera e reinicia a fase atual
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
