extends Node2D

@export var proxima_fase: PackedScene

@onready var feedback_joia = $FeedbackJoia 
@onready var interface_trofeus = $InterfaceTrofeus
@onready var avatar = $Avatar
#--------------------------------------------------------------------------------
@onready var foto_1 = $paginaEsquerda/VBoxContainer/linhaObjeto1/Obj1
@onready var lacuna_1 = $paginaEsquerda/VBoxContainer/linhaObjeto1/Lacuna
@onready var sufixo_1 = $paginaEsquerda/VBoxContainer/linhaObjeto1/restoNome

@onready var foto_2 = $paginaEsquerda/VBoxContainer/linhaObjeto2/Obj2
@onready var lacuna_2 = $paginaEsquerda/VBoxContainer/linhaObjeto2/Lacuna
@onready var sufixo_2 = $paginaEsquerda/VBoxContainer/linhaObjeto2/restoNome

@onready var foto_3 = $paginaEsquerda/VBoxContainer/linhaObjeto3/Obj3
@onready var lacuna_3 = $paginaEsquerda/VBoxContainer/linhaObjeto3/Lacuna
@onready var sufixo_3 = $paginaEsquerda/VBoxContainer/linhaObjeto3/restoNome

@onready var pagina_direita = $paginaDireita
#--------------------------------------------------------------------------------

var pode_interagir: bool = false
var ja_avisou_erros: bool = false
var rodada_atual: int = 1
var acertos_na_rodada: int = 0
var total_acertos_fase: int = 0

var dados_jogador = {
	"tempo_decorrido": 0.0,
	"erros_cometidos": 0
}

var banco_desafios = [
	# --- RODADA 1 (Índices 0, 1, 2) ---
	{"imagem": preload("res://sprites/objetos/carro.png"), "sufixo": "ARRO", "resposta": "C"},
	{"imagem": preload("res://sprites/objetos/fogao.png"), "sufixo": "OGÃO", "resposta": "F"},
	{"imagem": preload("res://sprites/objetos/mapa.png"), "sufixo": "APA", "resposta": "M"},
	# --- RODADA 2 (Índices 3, 4, 5) ---
	{"imagem": preload("res://sprites/objetos/vela.png"), "sufixo": "ELA", "resposta": "V"},
	{"imagem": preload("res://sprites/objetos/lampada.png"), "sufixo": "AMPADA", "resposta": "L"},
	{"imagem": preload("res://sprites/objetos/telefone_fixo.png"), "sufixo": "ELEFONE", "resposta": "T"}
]

# Guardar as posições originais das letras da direita para resetar depois
var posicoes_originais_letras: Dictionary = {}

@export var audio_acerto: AudioStream 
@export var audio_erro: AudioStream
@export var audio_proximo: AudioStream
@export var audio_fimFase: AudioStream

var audio_instrucao = preload("res://sprites/audios/fase1_2/instrucao.mp3")

func _ready() -> void:
	pode_interagir = false
	if feedback_joia != null:
		feedback_joia.hide()
		
	# Salva a posição inicial de cada letra da página direita para poder resetar
	for letra_node in pagina_direita.get_children():
		posicoes_originais_letras[letra_node.name] = letra_node.global_position
		
	avatar.mudar_fala("Agora vamos completar palavras. Escolha a letra inicial correta para completar a palavra. Boa sorte!", audio_instrucao, null, true)
	if audio_instrucao != null:
		await get_tree().create_timer(audio_instrucao.get_length()).timeout
	else:
		await get_tree().create_timer(2.0).timeout
		
	carregar_rodada(1)
	
func _process(delta: float) -> void:
	dados_jogador["tempo_decorrido"] += delta
	
func carregar_rodada(numero_rodada : int) -> void:
	pode_interagir = false
	acertos_na_rodada = 0
	rodada_atual = numero_rodada
	var indice_inicio = 0 if numero_rodada == 1 else 3
	
	# linha 1
	var d1 = banco_desafios[indice_inicio]
	foto_1.texture = d1["imagem"]
	sufixo_1.text = d1["sufixo"]
	lacuna_1.configurar_lacuna(d1["resposta"])
	
	# linha 2
	var d2 = banco_desafios[indice_inicio + 1]
	foto_2.texture = d2["imagem"]
	sufixo_2.text = d2["sufixo"]
	lacuna_2.configurar_lacuna(d2["resposta"])
	
	# linha 3
	var d3 = banco_desafios[indice_inicio + 2]
	foto_3.texture = d3["imagem"]
	sufixo_3.text = d3["sufixo"]
	lacuna_3.configurar_lacuna(d3["resposta"])
	
	resetar_posicao_letras()
	pode_interagir = true

func resetar_posicao_letras() -> void:
	for letra_node in pagina_direita.get_children():
		if letra_node.name in posicoes_originais_letras:
			letra_node.global_position = posicoes_originais_letras[letra_node.name]
			letra_node.show()

# --- VALIDAR DRAG AND DROP ---
func validar_resposta(letra_arrastada: String, lacuna_node: Label) -> void:
	if not pode_interagir or lacuna_node.preenchida:
		return
	
	if letra_arrastada == lacuna_node.letra_correta:
		# --- CASO: ACERTO ---
		pode_interagir = false
		lacuna_node.text = letra_arrastada
		lacuna_node.preenchida = true
		acertos_na_rodada += 1
		total_acertos_fase += 1
		
		if feedback_joia != null:
			feedback_joia.show()
		
		avatar.mudar_fala("Parabéns! Você acertou a letra. A palavra está correta!", audio_acerto, null, false)
		await get_tree().create_timer(2.0).timeout
		if feedback_joia != null:
			feedback_joia.hide()
			
		pode_interagir = true
		
		# Verifica se a rodada/fase acabou
		if acertos_na_rodada == 3:
			pode_interagir = false
			if total_acertos_fase == 6:
				concluir_fase()
			else:
				avatar.mudar_fala("Ótimo! Vamos para as próximas palavras.", audio_proximo, null, false)
				await get_tree().create_timer(2.0).timeout
				carregar_rodada(2)
	else:
		# --- CASO: ERRO (CORRIGIDO: Agora alinhado corretamente com o if de cima) ---
		pode_interagir = false
		dados_jogador["erros_cometidos"] += 1
		
		# Chegou em 5 erros, tira troféu
		if dados_jogador["erros_cometidos"] >= 5 and not ja_avisou_erros:
			ja_avisou_erros = true
			if interface_trofeus != null and interface_trofeus.has_method("perder_trofeu_erros"):
				interface_trofeus.perder_trofeu_erros()
				
		avatar.mudar_fala("Essa não é a letra certa. Observe a palavra e tente novamente.", audio_erro, null, false)
		await get_tree().create_timer(2.0).timeout
		pode_interagir = true
			
func concluir_fase() -> void:
	pode_interagir = false
	avatar.mudar_fala("Parabéns! Você completou o livro!", audio_fimFase, null, false)
	if interface_trofeus != null and interface_trofeus.has_method("ganhar_fase"):
		interface_trofeus.ganhar_fase()
	await get_tree().create_timer(3.0).timeout
	
	if proxima_fase != null:
		get_tree().change_scene_to_packed(proxima_fase)
	else:
		print("proxima fase não configurada")
