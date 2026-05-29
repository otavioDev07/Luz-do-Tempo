extends Node2D

@export var cena_objeto_base: PackedScene 

# --- REFERÊNCIAS DOS TROFÉUS E FEEDBACK ---
@onready var trofeu_1 = $InterfaceTrofeus/HBoxContainer/Trofeu1 
@onready var trofeu_2 = $InterfaceTrofeus/HBoxContainer/Trofeu2 
@onready var trofeu_3 = $InterfaceTrofeus/HBoxContainer/Trofeu3 
@onready var feedback_joia = $FeedbackJoia 

# --- VARIÁVEL DE TRAVA GLOBAL ---
var pode_interagir: bool = false # Controla se o jogador pode mexer no jogo

# --- DADOS DO JOGADOR ---
var dados_jogador = {
	"nome": "Jogador Vazio", 
	"tempo_decorrido": 0.0,
	"erros_cometidos": 0
}

var imagem_trofeu_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

var perdeu_trofeu_tempo: bool = false
var perdeu_trofeu_erros: bool = false

# --- CONFIGURAÇÃO DA ESTANTE ---
var inicio_antigo: Vector2 = Vector2(120, 280)  
var inicio_novo: Vector2 = Vector2(1150, 280)   

var espacamento_x: float = 250.0
var espacamento_y: float = 250.0

var total_antigo: int = 0
var total_novo: int = 0


# --- BANCO DE DADOS DE OBJETOS ---
var lista_de_objetos = [
	{
		"nome": "Vela",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/vela.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Carroça",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/carroca.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Fogão",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/fogao.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Lampião",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/lampiao.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Mapa",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/mapa.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Telefone Fixo",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/telefone_fixo.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Microondas",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/microondas.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Poste",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/poste.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Lâmpada",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/lampada.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "GPS",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/gps.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Carro",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/carro.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	},
	{
		"nome": "Tablet",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/celular.png"),
		"audio_nome": preload("res://sprites/audios/objetos/teste.mp3"),
		"usado": false
	}
]


# --- VARIÁVEIS DO AVATAR ---
var imgavatar = preload("res://sprites/avatares/adrian.png")
var audio_instrucao = preload("res://sprites/audios/fase1_1/instrucao.mp3")

# Depois, se for adicionar áudio aqui, não esqueça de colocar preload()
var audio_acerto: AudioStream 
var audio_erro: AudioStream 


func _ready() -> void:
	pode_interagir = false # Trava o jogo no início
	
	$Avatar.mudar_fala(
		"Separe o objeto antigo do novo!", 
		audio_instrucao, 
		imgavatar, 
		true
	)
	
	# --- ESPERA O ÁUDIO DE INSTRUÇÃO ACABAR ---
	if audio_instrucao != null:
		await get_tree().create_timer(audio_instrucao.get_length()).timeout
	else:
		await get_tree().create_timer(3.0).timeout 
		
	sortear_novo_objeto()


func _process(delta: float) -> void:
	# O tempo soma continuamente, mesmo se o avatar estiver falando
	dados_jogador["tempo_decorrido"] += delta
	
	# Se passar de 5 minutos (300 segundos), perde o troféu de tempo
	if dados_jogador["tempo_decorrido"] >= 300.0 and not perdeu_trofeu_tempo:
		perdeu_trofeu_tempo = true
		if trofeu_2 != null:
			trofeu_2.texture = imagem_trofeu_vazio


func sortear_novo_objeto() -> void:
	var objetos_disponiveis = []
	for objeto in lista_de_objetos:
		if not objeto["usado"]:
			objetos_disponiveis.append(objeto)
			
	if objetos_disponiveis.size() == 0:
		pode_interagir = false 
		$Avatar.mudar_fala(
			"Parabéns! Você organizou todos os objetos muito bem!", 
			audio_acerto, 
			null, 
			false
		)
		print("Fase Concluída! Erros: ", dados_jogador["erros_cometidos"], " | Tempo: ", dados_jogador["tempo_decorrido"])
		return
		
	var objeto_sorteado = objetos_disponiveis.pick_random()
	objeto_sorteado["usado"] = true
	
	var novo_objeto = cena_objeto_base.instantiate()
	add_child(novo_objeto)
	
	novo_objeto.global_position = Vector2(885, 465) 
	
	novo_objeto.configurar_objeto(
		objeto_sorteado["nome"], 
		objeto_sorteado["tipo"], 
		objeto_sorteado["imagem"],
		objeto_sorteado["audio_nome"] 
	)
	
	pode_interagir = true # Libera o jogo!


func _on_objeto_acertou(objeto_instanciado: Node2D) -> void:
	pode_interagir = false # Trava o jogo enquanto comemora
	
	# --- MOSTRA A IMAGEM DO JOIA ---
	if feedback_joia != null:
		feedback_joia.show()
	
	$Avatar.mudar_fala(
		"Muito bem! Você acertou!", 
		audio_acerto,
		null,
		false
	)
	
	var coluna: int = 0
	var linha: int = 0
	var posicao_final: Vector2 = Vector2.ZERO
	
	if objeto_instanciado.grupo_correto == "antigo":
		coluna = total_antigo % 3
		linha = int(total_antigo / 3)
		posicao_final.x = inicio_antigo.x + (coluna * espacamento_x)
		posicao_final.y = inicio_antigo.y + (linha * espacamento_y)
		total_antigo += 1 
	else:
		coluna = total_novo % 3
		linha = int(total_novo / 3)
		posicao_final.x = inicio_novo.x + (coluna * espacamento_x)
		posicao_final.y = inicio_novo.y + (linha * espacamento_y)
		total_novo += 1
		
	objeto_instanciado.global_position = posicao_final
	
	# --- ESPERA 1 SEGUNDO E ESCONDE O JOIA ---
	await get_tree().create_timer(1.0).timeout
	if feedback_joia != null:
		feedback_joia.hide()
	
	# --- ESPERA O RESTO DO ÁUDIO ANTES DE CHAMAR O PRÓXIMO ---
	var tempo_restante = 0.1
	if audio_acerto != null:
		# Pega a duração total do áudio e subtrai o 1 segundo que o joia já esperou
		tempo_restante = max(0.1, audio_acerto.get_length() - 1.0)
		
	await get_tree().create_timer(tempo_restante).timeout
	sortear_novo_objeto()


func _on_objeto_errou() -> void:
	pode_interagir = false # Trava o jogo durante a bronca
	dados_jogador["erros_cometidos"] += 1
	
	if dados_jogador["erros_cometidos"] >= 5 and not perdeu_trofeu_erros:
		perdeu_trofeu_erros = true
		if trofeu_3 != null:
			trofeu_3.texture = imagem_trofeu_vazio
			
	$Avatar.mudar_fala(
		"Tente novamente! Esse objeto pertence à outra caixa.", 
		audio_erro, 
		null, 
		false
	)
	
	# --- ESPERA O ÁUDIO DE ERRO TERMINAR ---
	var tempo_espera = 2.0
	if audio_erro != null:
		tempo_espera = audio_erro.get_length()
		
	await get_tree().create_timer(tempo_espera).timeout
	pode_interagir = true # Libera o jogo de volta para o jogador tentar
