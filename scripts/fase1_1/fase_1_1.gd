extends Node2D

@export var cena_objeto_base: PackedScene 

# --- CONFIGURAÇÃO DA ESTANTE ---
# Altere estes valores para definir onde a "linha 1, coluna 1" de cada lado vai começar na sua tela
var inicio_antigo: Vector2 = Vector2(27, 124)  
var inicio_novo: Vector2 = Vector2(670, 125)   

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
		"nome": "Lampião ",
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
	# Adicione mais objetos copiando e colando os blocos {} acima
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
		return
		
	var objeto_sorteado = objetos_disponiveis.pick_random()
	objeto_sorteado["usado"] = true
	
	var novo_objeto = cena_objeto_base.instantiate()
	add_child(novo_objeto)
	
	# Posição onde o objeto aparece inicialmente (ideal ser no centro/embaixo da tela)
	novo_objeto.global_position = Vector2(510, 250) 
	
	novo_objeto.configurar_objeto(
		objeto_sorteado["nome"], 
		objeto_sorteado["tipo"], 
		objeto_sorteado["imagem"]
	)

# O objeto manda 'si mesmo' nesta função para sabermos quem mover
func _on_objeto_acertou(objeto_instanciado: Node2D) -> void:
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
		
	# Envia o objeto para a vaga calculada na estante
	objeto_instanciado.global_position = posicao_final
	
	# Aguarda 1 segundo e sorteia o próximo
	await get_tree().create_timer(1.0).timeout
	sortear_novo_objeto()

func _on_objeto_errou() -> void:
	$Avatar.mudar_fala(
		"Tente novamente! Esse objeto pertence à outra caixa.", 
		audio_erro, 
		null, 
		false
	)
