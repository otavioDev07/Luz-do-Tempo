extends CanvasLayer # Ou Node2D, dependendo de qual nó raiz você usou para a cena dos troféus

# Como o script agora está NA PRÓPRIA CENA dos troféus, o caminho fica mais curto
@onready var trofeu_1 = $HBoxContainer/Trofeu1 
@onready var trofeu_2 = $HBoxContainer/Trofeu2 
@onready var trofeu_3 = $HBoxContainer/Trofeu3 

var imagem_trofeu_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

# O próprio troféu controla se já foi perdido ou não
var perdeu_tempo: bool = false
var perdeu_erros: bool = false

# Função para a fase chamar quando o tempo esgotar
func perder_trofeu_tempo() -> void:
	if not perdeu_tempo:
		perdeu_tempo = true
		if trofeu_2 != null:
			trofeu_2.texture = imagem_trofeu_vazio

# Função para a fase chamar quando o limite de erros for atingido
func perder_trofeu_erros() -> void:
	if not perdeu_erros:
		perdeu_erros = true
		if trofeu_3 != null:
			trofeu_3.texture = imagem_trofeu_vazio

# (Se no futuro o Troféu 1 for perdido por dicas, você cria uma função aqui também!)
