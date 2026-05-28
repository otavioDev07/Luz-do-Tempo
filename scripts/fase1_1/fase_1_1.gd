extends Node2D

@export var cena_objeto_base: PackedScene 

# --- REFERÊNCIAS DOS TROFÉUS ---
# Certifique-se de que a estrutura na sua árvore está assim: InterfaceTrofeus -> HBoxContainer -> Trofeu...
@onready var trofeu_1 = $InterfaceTrofeus/HBoxContainer/Trofeu1 # Fixo
@onready var trofeu_2 = $InterfaceTrofeus/HBoxContainer/Trofeu2 # Tempo
@onready var trofeu_3 = $InterfaceTrofeus/HBoxContainer/Trofeu3 # Erros

# --- DADOS DO JOGADOR ---
var dados_jogador = {
	"nome": "Jogador Vazio", # Depois a gente puxa isso do Menu!
	"tempo_decorrido": 0.0,
	"erros_cometidos": 0
}

var perdeu_trofeu_tempo: bool = false
var perdeu_trofeu_erros: bool = false


# --- CONFIGURAÇÃO DA ESTANTE ---
# Altere estes valores para definir onde a "linha 1, coluna 1" de cada lado vai começar na sua tela
var inicio_antigo: Vector2 = Vector2(120, 230)  
var inicio_novo: Vector2 = Vector2(1200, 230)   

var espacamento_x: float = 150.0
var espacamento_y: float = 150.0

var total_antigo: int = 0
var total_novo: int = 0


# --- BANCO DE DADOS DE OBJETOS ---
var lista_de_objetos = [
	{
		"nome": "Vela",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/vela.png"),
		"usado": false
	},
	{
		"nome": "Carroça",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/carroca.png"),
		"usado": false
	},
	{
		"nome": "Fogão",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/fogao.png"),
		"usado": false
	},
	{
		"nome": "Lampião",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/lampiao.png"),
		"usado": false
	},
	{
		"nome": "Mapa",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/mapa.png"),
		"usado": false
	},
	{
		"nome": "Telefone Fixo",
		"tipo": "antigo",
		"imagem": preload("res://sprites/objetos/telefone_fixo.png"),
		"usado": false
	},
	{
		"nome": "Microondas",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/microondas.png"),
		"usado": false
	},
	{
		"nome": "Poste",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/poste.png"),
		"usado": false
	},
	{
		"nome": "Lâmpada",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/lampada.png"),
		"usado": false
	},
	{
		"nome": "GPS",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/gps.png"),
		"usado": false
	},
	{
		"nome": "Carro",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/carro.png"),
		"usado": false
	},
	{
		"nome": "Tablet",
		"tipo": "novo",
		"imagem": preload("res://sprites/objetos/celular.png"),
		"usado": false
	}
]


# --- VARIÁVEIS DO AVATAR ---
var imgavatar = preload("res://sprites/avatares/adrian.png")
var audio_instrucao = preload("res://sprites/audios/fase1_1/instrucao.mp3")

# Remova o "#" da frente e coloque o caminho correto quando criar os áudios
var audio_acerto: AudioStream # = preload("res://sprites/audios/fase1_1/acerto.mp3")
var audio_erro: AudioStream # = preload("res://sprites/audios/fase1_1/erro.mp3")


func _ready() -> void:
	$Avatar.mudar_fala(
		"Separe o objeto antigo do novo!", 
		audio_instrucao, 
		imgavatar, 
		true
	)
	sortear_novo_objeto()

# --- RELÓGIO DA FASE (TROFÉU 2) ---
func _process(delta: float) -> void:
	# Soma o tempo (em segundos)
	dados_jogador["tempo_decorrido"] += delta
	
	# Passou de 5 minutos (300 segs) e ainda tem o troféu?
	if dados_jogador["tempo_decorrido"] >= 300.0 and not perdeu_trofeu_tempo:
		perdeu_trofeu_tempo = true
		if trofeu_2 != null:
			trofeu_2.hide()


func sortear_novo_objeto() -> void:
	var objetos_disponiveis = []
	for objeto in lista_de_objetos:
		if not objeto["usado"]:
			objetos_disponiveis.append(objeto)
			
	if objetos_disponiveis.size() == 0:
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
	
	# Posição onde o objeto aparece inicialmente
	novo_objeto.global_position = Vector2(885, 465) 
	
	novo_objeto.configurar_objeto(
		objeto_sorteado["nome"], 
		objeto_sorteado["tipo"], 
		objeto_sorteado["imagem"]
	)


# O objeto manda 'si mesmo' nesta função para sabermos quem mover
func _on_objeto_acertou(objeto_instanciado: Node2D) -> void:
	# Ajustei aqui para ter os 4 parâmetros e não dar erro!
	$Avatar.mudar_fala(
		"Muito bem! Você acertou!", 
		audio_acerto,
		null,
		false
	)
	
	var coluna: int = 0
	var linha: int = 0
	var posicao_final: Vector2 = Vector2.ZERO
	
	# Lógica Matemática para montar a estante de 3 colunas
	if objeto_instanciado.grupo_correto == "antigo":
		coluna = total_antigo % 4
		linha = int(total_antigo / 4)
		
		posicao_final.x = inicio_antigo.x + (coluna * espacamento_x)
		posicao_final.y = inicio_antigo.y + (linha * espacamento_y)
		
		total_antigo += 1 
		
	else:
		coluna = total_novo % 4
		linha = int(total_novo / 4)
		
		posicao_final.x = inicio_novo.x + (coluna * espacamento_x)
		posicao_final.y = inicio_novo.y + (linha * espacamento_y)
		
		total_novo += 1
		
	# Envia o objeto para a vaga calculada na estante
	objeto_instanciado.global_position = posicao_final
	
	# Aguarda 1 segundo e sorteia o próximo
	await get_tree().create_timer(1.0).timeout
	sortear_novo_objeto()


func _on_objeto_errou() -> void:
	# --- LÓGICA DO TROFÉU 3 (ERROS) ---
	dados_jogador["erros_cometidos"] += 1
	
	# Chegou a 5 erros e ainda tem o troféu?
	if dados_jogador["erros_cometidos"] >= 5 and not perdeu_trofeu_erros:
		perdeu_trofeu_erros = true
		if trofeu_3 != null:
			trofeu_3.hide()
			
	# --- FALA DO AVATAR ---
	$Avatar.mudar_fala(
		"Tente novamente! Esse objeto pertence à outra caixa.", 
		audio_erro, 
		null, 
		false
	)
