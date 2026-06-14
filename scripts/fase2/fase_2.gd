extends Node2D

@export var proxima_fase: PackedScene 

# --- REFERÊNCIAS ---
@onready var fundo = $Background
@onready var opcoes_container = $OpcoesContainer
@onready var interface_trofeus = $InterfaceTrofeus
@onready var avatar = $Avatar
@onready var audio_hover = $AudioHover # Tocador de áudio para os botões

@onready var caixa_certa = $OpcoesContainer/CaixaCerta
@onready var caixa_errada = $OpcoesContainer/CaixaErrada
@onready var botao_certo = $OpcoesContainer/CaixaCerta/BotaoCerto
@onready var botao_errado = $OpcoesContainer/CaixaErrada/BotaoErrado

# --- VARIÁVEIS DE CONTROLE ---
var pode_interagir: bool = false 
var tempo_decorrido: float = 0.0
var erros_cometidos: int = 0
var jogo_rodando: bool = false 
var rodada_atual: int = 0 # Vai de 0 a 4 (Total de 5 rodadas)

# Posições originais das caixas para podermos embaralhar!
var pos_esquerda: Vector2
var pos_direita: Vector2

# --- BANCO DE DADOS DAS 5 RODADAS ---
var rodadas = [
	{
		"img_avatar": preload("res://sprites/avatares/brenno.png"), # <-- ATENÇÃO: Troque pelo avatar do cenário 1
		"fundo_padrao": preload("res://sprites/telas/quarto.png"),
		"fundo_acerto": preload("res://sprites/telas/quarto_lampada.png"),
		"fundo_erro": preload("res://sprites/telas/quarto_velas.png"),
		"img_certo": preload("res://sprites/objetos/lampada.png"),
		"img_errado": preload("res://sprites/objetos/vela.png"),
		"audio_nome_certo": preload("res://sprites/audios/objetos/lampada.mp3"), 
		"audio_nome_errado": preload("res://sprites/audios/objetos/vela.mp3"),
		"texto_instrucao": "Este quarto está muito escuro.\nQual objeto pode iluminar melhor o ambiente?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario1_instrucao.mp3"),
		"texto_acerto": "Muito bem!\nA lâmpada ilumina o quarto todo.\nÓtima escolha!",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario1_acerto.mp3"),
		"texto_erro": "A vela ajuda a iluminar.\nMas ela ilumina apenas uma pequena área.\nExiste uma opção melhor.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario1_erro.mp3")
	},
	{
		"img_avatar": preload("res://sprites/avatares/brenno.png"), # <-- ATENÇÃO: Troque pelo avatar do cenário 2
		"fundo_padrao": preload("res://sprites/telas/garagem.png"),
		"fundo_acerto": preload("res://sprites/telas/garagem_carro.png"),
		"fundo_erro": preload("res://sprites/telas/garagem_carroca.png"),
		"img_certo": preload("res://sprites/objetos/carro.png"),
		"img_errado": preload("res://sprites/objetos/carroca.png"),
		"audio_nome_certo": preload("res://sprites/audios/objetos/carro.mp3"), 
		"audio_nome_errado": preload("res://sprites/audios/objetos/carroca.mp3"),
		"texto_instrucao": "Você precisa ir para a escola rapidamente.\nQual meio de transporte você escolhe?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario2_instrucao.mp3"), 
		"texto_acerto": "Excelente!\nO carro é mais rápido e prático.\nVocê acertou!",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario2_acerto.mp3"), 
		"texto_erro": "A carroça pode transportar pessoas.\nMas ela é mais lenta.\nExiste uma opção melhor.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario2_erro.mp3") 
	},
	{
		"img_avatar": preload("res://sprites/avatares/vinicius.png"), # <-- ATENÇÃO: Troque pelo avatar do cenário 3
		"fundo_padrao": preload("res://sprites/telas/ligacao.png"),
		"fundo_acerto": preload("res://sprites/telas/ligacao_celular.png"),
		"fundo_erro": preload("res://sprites/telas/ligacao_fixo.png"),
		"img_certo": preload("res://sprites/objetos/celular.png"),
		"img_errado": preload("res://sprites/objetos/telefone_fixo.png"),
		"audio_nome_certo": preload("res://sprites/audios/objetos/celular.mp3"), 
		"audio_nome_errado": preload("res://sprites/audios/objetos/telefone.mp3"),
		"texto_instrucao": "João quer conversar com sua mãe.\nQual meio de comunicação é a melhor escolha?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario3_instrucao.mp3"), 
		"texto_acerto": "Muito bem!\nO celular facilita a comunicação.\nVocê acertou!",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario3_acerto.mp3"), 
		"texto_erro": "O telefone fixo pode fazer ligações.\nMas existe uma opção mais prática.\nTente novamente.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario3_erro.mp3") 
	},
	{
		"img_avatar": preload("res://sprites/avatares/pedro.png"), # <-- ATENÇÃO: Troque pelo avatar do cenário 4
		"fundo_padrao": preload("res://sprites/telas/rua.png"),
		"fundo_acerto": preload("res://sprites/telas/rua_poste.png"),
		"fundo_erro": preload("res://sprites/telas/rua_lampiao.png"),
		"img_certo": preload("res://sprites/objetos/poste.png"),
		"img_errado": preload("res://sprites/objetos/lampiao.png"),
		"audio_nome_certo": preload("res://sprites/audios/objetos/posteSolar.mp3"), 
		"audio_nome_errado": preload("res://sprites/audios/objetos/lampiao.mp3"),
		"texto_instrucao": "O engenheiro quer iluminar esta rua.\nAjude ele a escolher a melhor opção para a cidade?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario4_instrucao.mp3"), 
		"texto_acerto": "Excelente escolha!\nOs postes iluminam melhor a rua.\nE ainda usam energia sustentável.",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario4_acerto.mp3"), 
		"texto_erro": "Os lampiões iluminam a rua.\nMas a iluminação é limitada.\nExiste uma opção melhor.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario4_erro.mp3") 
	},
	{
		"img_avatar": preload("res://sprites/avatares/adrian.png"), # <-- ATENÇÃO: Troque pelo avatar do cenário 5
		"fundo_padrao": preload("res://sprites/telas/cozinha.png"),
		"fundo_acerto": preload("res://sprites/telas/cozinha_microondas.png"),
		"fundo_erro": preload("res://sprites/telas/cozinha_fogao.png"),
		"img_certo": preload("res://sprites/objetos/microondas.png"),
		"img_errado": preload("res://sprites/objetos/fogao.png"),
		"audio_nome_certo": preload("res://sprites/audios/objetos/microondas.mp3"), 
		"audio_nome_errado": preload("res://sprites/audios/objetos/fogao.mp3"),
		"texto_instrucao": "Maria está com fome.\nQual é a melhor opção para esquentar sua comida?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario5_instrucao.mp3"), 
		"texto_acerto": "Muito bem!\nO micro-ondas aquece a comida rapidamente.\nVocê acertou!",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario5_acerto.mp3"), 
		"texto_erro": "O fogão a lenha funciona bem.\nMas demora mais para aquecer a comida.\nExiste uma opção mais rápida.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario5_erro.mp3") 
	},
]

func _process(delta: float) -> void:
	if jogo_rodando:
		tempo_decorrido += delta

func _ready() -> void:
	MusicManager.tocar_jogo()
	pos_esquerda = caixa_certa.position
	pos_direita = caixa_errada.position
	
	if interface_trofeus != null:
		interface_trofeus.inicializar(0.0, 0, 5)
		
	jogo_rodando = true 
	
	botao_certo.mouse_entered.connect(_on_botao_certo_mouse_entered)
	botao_errado.mouse_entered.connect(_on_botao_errado_mouse_entered)
	
	carregar_rodada(rodada_atual)


func carregar_rodada(indice: int) -> void:
	# Bloqueia a interação durante a montagem visual da tela e enquanto o áudio toca
	pode_interagir = false
	var dados = rodadas[indice]
	
	fundo.texture = dados["fundo_padrao"]
	botao_certo.texture_normal = dados["img_certo"]
	botao_errado.texture_normal = dados["img_errado"]
	
	if randi() % 2 == 0:
		caixa_certa.position = pos_esquerda
		caixa_errada.position = pos_direita
	else:
		caixa_certa.position = pos_direita
		caixa_errada.position = pos_esquerda
		
	opcoes_container.show()
	
	# Usando a imagem do avatar de dentro do banco de dados (dados["img_avatar"])
	avatar.mudar_fala(dados["texto_instrucao"], dados["audio_instrucao"], dados["img_avatar"], true)
	
	# Calcula o tempo do áudio da instrução e aguarda ele terminar
	var tempo_instrucao = 2.0
	if dados["audio_instrucao"] != null:
		tempo_instrucao = dados["audio_instrucao"].get_length()
		
	await get_tree().create_timer(tempo_instrucao).timeout
	
	pode_interagir = true


func _on_botao_errado_pressed() -> void:
	if not pode_interagir: return
	pode_interagir = false 
	erros_cometidos += 1
	var dados = rodadas[rodada_atual]
	
	opcoes_container.hide()
	fundo.texture = dados["fundo_erro"]
	
	if interface_trofeus != null:
		interface_trofeus.registrar_erro()
		
	avatar.mudar_fala(dados["texto_erro"], dados["audio_erro"], null, false)
	
	# Aguarda o áudio de feedback do erro terminar (+1s de respiro)
	var tempo_espera_erro = 1.0
	if dados["audio_erro"] != null:
		tempo_espera_erro = dados["audio_erro"].get_length() + 1.0
		
	await get_tree().create_timer(tempo_espera_erro).timeout
	
	# Se o jogador já avançou de fase ou mudou de tela durante a espera, evita rodar o resto
	if not jogo_rodando: return
	
	fundo.texture = dados["fundo_padrao"]
	opcoes_container.show()
	
	# Toca a instrução de novo usando o avatar específico da rodada
	avatar.mudar_fala(dados["texto_instrucao"], dados["audio_instrucao"], dados["img_avatar"], true)
	
	# Calcula o tempo da instrução repetida e aguarda ela terminar antes de liberar
	var tempo_instrucao_repetida = 2.0
	if dados["audio_instrucao"] != null:
		tempo_instrucao_repetida = dados["audio_instrucao"].get_length()
		
	await get_tree().create_timer(tempo_instrucao_repetida).timeout
	
	pode_interagir = true


func _on_botao_certo_pressed() -> void:
	if not pode_interagir: return
	pode_interagir = false 
	var dados = rodadas[rodada_atual]
	
	opcoes_container.hide()
	fundo.texture = dados["fundo_acerto"]
	
	avatar.mudar_fala(dados["texto_acerto"], dados["audio_acerto"], null, false)
	
	# Aguarda o áudio de acerto terminar (+1s de respiro)
	var tempo_espera = 1.0
	if dados["audio_acerto"] != null:
		tempo_espera = dados["audio_acerto"].get_length() + 1.0
		
	await get_tree().create_timer(tempo_espera).timeout
	
	rodada_atual += 1
	
	if rodada_atual < rodadas.size():
		carregar_rodada(rodada_atual)
	else:
		jogo_rodando = false
		if interface_trofeus != null:
			interface_trofeus.ganhar_fase()
			
		PlayerName.tempo_fase2 = tempo_decorrido
		PlayerName.erros_fase2 = erros_cometidos
		
		print("Fase 2 Totalmente Concluída! Erros: ", erros_cometidos, " | Tempo: ", tempo_decorrido)
		
		if proxima_fase != null:
			get_tree().change_scene_to_packed(proxima_fase)

# --- FUNÇÕES DE HOVER (PASSAR O MOUSE) ---
func _on_botao_certo_mouse_entered() -> void:
	if audio_hover != null and pode_interagir:
		var dados = rodadas[rodada_atual]
		if dados["audio_nome_certo"] != null:
			audio_hover.stream = dados["audio_nome_certo"]
			audio_hover.play()

func _on_botao_errado_mouse_entered() -> void:
	if audio_hover != null and pode_interagir:
		var dados = rodadas[rodada_atual]
		if dados["audio_nome_errado"] != null:
			audio_hover.stream = dados["audio_nome_errado"]
			audio_hover.play()
