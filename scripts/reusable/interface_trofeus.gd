extends CanvasLayer 

@onready var trofeu_1 = $HBoxContainer/Trofeu1 
@onready var trofeu_2 = $HBoxContainer/Trofeu2 
@onready var trofeu_3 = $HBoxContainer/Trofeu3 

var imagem_trofeu_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

var perdeu_tempo: bool = false
var perdeu_erros: bool = false

func perder_trofeu_tempo() -> void:
	if not perdeu_tempo:
		perdeu_tempo = true
		if trofeu_2 != null:
			trofeu_2.texture = imagem_trofeu_vazio

func perder_trofeu_erros() -> void:
	if not perdeu_erros:
		perdeu_erros = true
		if trofeu_3 != null:
			trofeu_3.texture = imagem_trofeu_vazio
