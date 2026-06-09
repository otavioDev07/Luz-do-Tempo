extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $CaixaDeTexto/Mensagem
@onready var mensagem_acerto = $CaixaDeTexto/MensagemDeAcerto
@onready var mensagem_erro = $CaixaDeTexto/MensagemDeErro

@onready var botao_celular = $BotaoCelular
@onready var botao_telefone = $BotaoTelefone

@onready var trofeus = [$BarraDeTrofeus/Trofeu1, $BarraDeTrofeus/Trofeu2, $BarraDeTrofeus/Trofeu3]

#Novas variáveis para os fundos (arraste as imagens no Inspetor!)

@export var fundo_acerto: Texture2D
@export var fundo_erro: Texture2D

var tex_cheio = preload("res://sprites/avatares/trofeu_completo.png")
var tex_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

func _ready():
	mensagem_acerto.hide()
	mensagem_erro.hide()
	atualizar_trofeus()

func atualizar_trofeus():
	var erros = GameManager.get_erros()
	for i in range(3):
		if (i == 0 and erros >= 8) or (i == 1 and erros >= 5) or (i == 2 and erros >= 3):
			trofeus[i].texture = tex_vazio
		else:
			trofeus[i].texture = tex_cheio

func _on_botao_celular_pressed():
# ACERTO
	mensagem_pergunta.hide()
	botao_celular.hide()
	botao_telefone.hide()

	mensagem_acerto.show()
	

# Troca o fundo pelo cenário de acerto
	if fundo_acerto:
		fundo.texture = fundo_acerto
	await get_tree().create_timer(2.0).timeout
# get_tree().change_scene_to_file("res://fase_3.tscn")
	get_tree().change_scene_to_file("res://scenes/TelaFinal/Final.tscn")


func _on_botao_telefone_pressed():
# ERRO
	GameManager.registrar_erro()
	mensagem_pergunta.hide()
	botao_celular.hide()
	botao_telefone.hide()

	mensagem_erro.show()

# Troca o fundo pelo cenário de erro
	if fundo_erro:
		fundo.texture = fundo_erro
	
	atualizar_trofeus()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
