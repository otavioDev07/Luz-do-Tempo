extends Node2D

@onready var fundo = $Fundo
@onready var mensagem_pergunta = $CaixaDeTexto/Mensagem
@onready var mensagem_acerto = $CaixaDeTexto/MensagemDeAcerto
@onready var mensagem_erro = $CaixaDeTexto/MensagemDeErro
@onready var botao_carro = $BotaoCarro
@onready var botao_carroca = $BotaoCarroca
@onready var trofeus = [$BarraDeTrofeus/Trofeu1, $BarraDeTrofeus/Trofeu2, $BarraDeTrofeus/Trofeu3]
@onready var node_carro = $Carro
@onready var node_carroca = $Carroca
#Você vai arrastar as imagens "centralizadas" para estes campos no Inspetor

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
	GameManager.registrar_erro()
	mensagem_pergunta.hide()
	botao_carro.hide()
	botao_carroca.hide()
	
	mensagem_erro.show()
	node_carroca.show() # Mostra apenas o nó da carroça
	node_carro.hide()   # Garante que o carro continue escondido
		
	atualizar_trofeus()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
