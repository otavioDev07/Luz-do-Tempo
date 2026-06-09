extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $CaixaDeTexto/Mensagem
@onready var mensagem_acerto = $CaixaDeTexto/MensagemDeAcerto
@onready var mensagem_erro = $CaixaDeTexto/MensagemDeErro
@onready var botao_lampada = $BotaoLampada
@onready var botao_vela = $BotaoVela
@onready var trofeus = [$BarraDeTrofeus/Trofeu1, $BarraDeTrofeus/Trofeu2, $BarraDeTrofeus/Trofeu3]

# AQUI ESTÁ O SEGREDO:
@export var imagem_lampada: Texture2D
@export var imagem_vela: Texture2D

var tex_cheio = preload("res://sprites/avatares/trofeu_completo.png")
var tex_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

func _ready():
	mensagem_acerto.hide()
	mensagem_erro.hide()
	atualizar_trofeus()

func atualizar_trofeus():
	var erros = GameManager.get_erros()
	if erros >= 8:
		trofeus[0].texture = tex_vazio
		trofeus[1].texture = tex_vazio
		trofeus[2].texture = tex_vazio
	elif erros >= 5:
		trofeus[0].texture = tex_cheio
		trofeus[1].texture = tex_vazio
		trofeus[2].texture = tex_vazio
	elif erros >= 3:
		trofeus[0].texture = tex_cheio
		trofeus[1].texture = tex_cheio
		trofeus[2].texture = tex_vazio
	else:
		trofeus[0].texture = tex_cheio
		trofeus[1].texture = tex_cheio
		trofeus[2].texture = tex_cheio

func _on_botao_lampada_pressed():
	mensagem_pergunta.hide()
	mensagem_acerto.show()
	botao_lampada.hide()
	botao_vela.hide()
	fundo.texture = imagem_lampada # Vai usar a imagem que você arrastar
	GameManager.resetar_erros()
	await get_tree().create_timer(2.0).timeout
	# Esta é a linha que pula para a próxima fase:
	get_tree().change_scene_to_file("res://scenes/fase2/fase2_1.tscn")

func _on_botao_vela_pressed():
	GameManager.registrar_erro()
	mensagem_pergunta.hide()
	mensagem_erro.show()
	botao_lampada.hide()
	botao_vela.hide()
	fundo.texture = imagem_vela # Vai usar a imagem que você arrastar
	atualizar_trofeus()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
