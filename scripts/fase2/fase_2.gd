extends Node2D

@export var proxima_fase: PackedScene 

# --- REFERÊNCIAS ---
@onready var fundo = $Background
@onready var opcoes_container = $OpcoesContainer
@onready var interface_trofeus = $InterfaceTrofeus
@onready var avatar = $Avatar

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
var imgavatar = preload("res://sprites/avatares/brenno.png")

# Posições originais das caixas para podermos embaralhar!
var pos_esquerda: Vector2
var pos_direita: Vector2

# --- BANCO DE DADOS DAS 5 RODADAS ---
# Preencha com os caminhos corretos das suas imagens e áudios
var rodadas = [
	{
		"fundo_padrao": preload("res://sprites/telas/quarto.png"),
		"fundo_acerto": preload("res://sprites/telas/quarto_lampada.png"),
		"fundo_erro": preload("res://sprites/telas/quarto_velas.png"),
		"img_certo": preload("res://sprites/objetos/lampada.png"),
		"img_errado": preload("res://sprites/objetos/vela.png"),
		"texto_instrucao": "Este quarto está muito escuro.
Qual objeto pode iluminar melhor o ambiente?",
		"audio_instrucao": preload("res://sprites/audios/fase2/cenario1_instrucao.mp3"),
		"texto_acerto": "Muito bem!
		A lâmpada ilumina o quarto todo.
		Ótima escolha!",
		"audio_acerto": preload("res://sprites/audios/fase2/cenario1_acerto.mp3"),
		"texto_erro": "A vela ajuda a iluminar.
		Mas ela ilumina apenas uma pequena área.
		Existe uma opção melhor.",
		"audio_erro": preload("res://sprites/audios/fase2/cenario1_erro.mp3")
	},
	# COPIE O BLOCO ACIMA E COLE AQUI PARA CRIAR A RODADA 2, 3, 4 e 5...
]

func _process(delta: float) -> void:
	if jogo_rodando:
		tempo_decorrido += delta

func _ready() -> void:
	# Salva onde as caixas estão na tela para podermos trocar elas de lugar depois
	pos_esquerda = caixa_certa.position
	pos_direita = caixa_errada.position
	
	if interface_trofeus != null:
		interface_trofeus.inicializar(0.0, 0, 5)
		
	jogo_rodando = true 
	
	# Começa o jogo carregando a primeira rodada (índice 0)
	carregar_rodada(rodada_atual)


func carregar_rodada(indice: int) -> void:
	pode_interagir = false
	var dados = rodadas[indice]
	
	# 1. Configura as imagens desta rodada
	fundo.texture = dados["fundo_padrao"]
	botao_certo.texture_normal = dados["img_certo"]
	botao_errado.texture_normal = dados["img_errado"]
	
	# 2. Embaralha a posição para o jogador não decorar onde fica o certo!
	if randi() % 2 == 0:
		caixa_certa.position = pos_esquerda
		caixa_errada.position = pos_direita
	else:
		caixa_certa.position = pos_direita
		caixa_errada.position = pos_esquerda
		
	opcoes_container.show()
	
	# 3. Avatar fala a instrução da rodada
	avatar.mudar_fala(dados["texto_instrucao"], dados["audio_instrucao"], imgavatar, true)
	
	var tempo_espera = 3.0
	if dados["audio_instrucao"] != null:
		tempo_espera = dados["audio_instrucao"].get_length()
		
	await get_tree().create_timer(tempo_espera).timeout
	pode_interagir = true


func _on_botao_errado_pressed() -> void:
	if not pode_interagir: return
	pode_interagir = false 
	erros_cometidos += 1
	var dados = rodadas[rodada_atual]
	
	# 1. Mostra a tela de erro
	opcoes_container.hide()
	fundo.texture = dados["fundo_erro"]
	
	if interface_trofeus != null:
		interface_trofeus.registrar_erro()
		
	avatar.mudar_fala(dados["texto_erro"], dados["audio_erro"], null, false)
	
	var tempo_espera_erro = 3.0
	if dados["audio_erro"] != null:
		tempo_espera_erro = max(3.0, dados["audio_erro"].get_length())
		
	await get_tree().create_timer(tempo_espera_erro).timeout
	
	# 2. Volta para a tela de escolha da MESMA rodada
	fundo.texture = dados["fundo_padrao"]
	opcoes_container.show()
	
	# 3. REPETE O ENUNCIADO!
	avatar.mudar_fala(dados["texto_instrucao"], dados["audio_instrucao"], imgavatar, true)
	
	# 4. Espera o áudio do enunciado terminar para liberar o clique de novo
	var tempo_espera_instrucao = 3.0
	if dados["audio_instrucao"] != null:
		tempo_espera_instrucao = dados["audio_instrucao"].get_length()
		
	await get_tree().create_timer(tempo_espera_instrucao).timeout
	
	pode_interagir = true


func _on_botao_certo_pressed() -> void:
	if not pode_interagir: return
	pode_interagir = false 
	var dados = rodadas[rodada_atual]
	
	opcoes_container.hide()
	fundo.texture = dados["fundo_acerto"]
	
	avatar.mudar_fala(dados["texto_acerto"], dados["audio_acerto"], null, false)
	
	var tempo_espera = 3.5
	if dados["audio_acerto"] != null:
		tempo_espera = max(3.5, dados["audio_acerto"].get_length())
		
	await get_tree().create_timer(tempo_espera).timeout
	
	# Passa para a próxima rodada!
	rodada_atual += 1
	
	if rodada_atual < rodadas.size():
		# Se ainda tem rodadas, carrega a próxima
		carregar_rodada(rodada_atual)
	else:
		# Se acabaram as rodadas, vence a Fase 2 inteira!
		jogo_rodando = false
		if interface_trofeus != null:
			interface_trofeus.ganhar_fase()
			
		PlayerName.tempo_fase2 = tempo_decorrido
		PlayerName.erros_fase2 = erros_cometidos
		
		print("Fase 2 Totalmente Concluída! Erros: ", erros_cometidos, " | Tempo: ", tempo_decorrido)
		
		if proxima_fase != null:
			get_tree().change_scene_to_packed(proxima_fase)
