extends Node2D

# --- RECOLOCADO: Campo para arrastar a Fase 1.2 pelo Inspector ---
@export var proxima_fase: PackedScene 
@export var cena_objeto_base: PackedScene 

# --- REFERÊNCIAS ---
@onready var feedback_joia = $FeedbackJoia 
@onready var feedback_erro = $FeedbackErro 
@onready var interface_trofeus = $InterfaceTrofeus # Chama a cena inteira dos troféus!

# --- VARIÁVEL DE TRAVA GLOBAL ---
var pode_interagir: bool = false 

# --- VARIÁVEIS DE CONTROLE DE TEMPO E ERROS (INTERNOS DA FASE) ---
var tempo_decorrido: float = 0.0
var erros_cometidos: int = 0
var jogo_rodando: bool = false # Controla se o cronômetro está ativo

# --- CONFIGURAÇÃO DA ESTANTE ---
var inicio_antigo: Vector2 = Vector2(120, 280)  
var inicio_novo: Vector2 = Vector2(1150, 280)   

var espacamento_x: float = 250.0
var espacamento_y: float = 250.0

var total_antigo: int = 0
var total_novo: int = 0

# --- BANCO DE DADOS DE OBJETOS ---
var lista_de_objetos = [
	{"nome": "Vela", "tipo": "antigo", "imagem": preload("res://sprites/objetos/vela.png"), "audio_nome": preload("res://sprites/audios/objetos/vela.mp3"), "usado": false},
	{"nome": "Carroça", "tipo": "antigo", "imagem": preload("res://sprites/objetos/carroca.png"), "audio_nome": preload("res://sprites/audios/objetos/carroca.mp3"), "usado": false},
	{"nome": "Fogão", "tipo": "antigo", "imagem": preload("res://sprites/objetos/fogao.png"), "audio_nome": preload("res://sprites/audios/objetos/fogao.mp3"), "usado": false},
	{"nome": "Lampião", "tipo": "antigo", "imagem": preload("res://sprites/objetos/lampiao.png"), "audio_nome": preload("res://sprites/audios/objetos/lampiao.mp3"), "usado": false},
	{"nome": "Mapa", "tipo": "antigo", "imagem": preload("res://sprites/objetos/mapa.png"), "audio_nome": preload("res://sprites/audios/objetos/mapa.mp3"), "usado": false},
	{"nome": "Telefone Fixo", "tipo": "antigo", "imagem": preload("res://sprites/objetos/telefone_fixo.png"), "audio_nome": preload("res://sprites/audios/objetos/telefone.mp3"), "usado": false},
	{"nome": "Microondas", "tipo": "novo", "imagem": preload("res://sprites/objetos/microondas.png"), "audio_nome": preload("res://sprites/audios/objetos/microondas.mp3"), "usado": false},
	{"nome": "Poste", "tipo": "novo", "imagem": preload("res://sprites/objetos/poste.png"), "audio_nome": preload("res://sprites/audios/objetos/posteSolar.mp3"), "usado": false},
	{"nome": "Lâmpada", "tipo": "novo", "imagem": preload("res://sprites/objetos/lampada.png"), "audio_nome": preload("res://sprites/audios/objetos/lampada.mp3"), "usado": false},
	{"nome": "GPS", "tipo": "novo", "imagem": preload("res://sprites/objetos/gps.png"), "audio_nome": preload("res://sprites/audios/objetos/gps.mp3"), "usado": false},
	{"nome": "Carro", "tipo": "novo", "imagem": preload("res://sprites/objetos/carro.png"), "audio_nome": preload("res://sprites/audios/objetos/carro.mp3"), "usado": false},
	{"nome": "Celular", "tipo": "novo", "imagem": preload("res://sprites/objetos/celular.png"), "audio_nome": preload("res://sprites/audios/objetos/celular.mp3"), "usado": false}
]

# --- VARIÁVEIS DO AVATAR ---
var imgavatar = preload("res://sprites/avatares/adrian.png")
var audio_instrucao = preload("res://sprites/audios/fase1_1/instrucao.mp3")

var audio_acerto = preload("res://sprites/audios/fase1_1/acerto.mp3")
var audio_erro = preload("res://sprites/audios/fase1_1/erro.mp3")
var audio_concluido = preload("res://sprites/audios/fase1_1/concluido.mp3")



# --- CRONÔMETRO INTERNO ---
func _process(delta: float) -> void:
	if jogo_rodando:
		tempo_decorrido += delta


func _ready() -> void:
	MusicManager.tocar_jogo()
	pode_interagir = false 
	
	# --- OS DOIS CRONÔMETROS COMEÇAM IMEDIATAMENTE AQUI! ---
	if interface_trofeus != null:
		interface_trofeus.inicializar(0.0, 0, 5) # Inicia o relógio visual na tela
		
	jogo_rodando = true # Inicia o relógio matemático invisível
	
	$Avatar.mudar_fala(
		"Vamos aprender sobre objetos novos e velhos.
		Veja o objeto no centro da tela e arraste ele para a opção correta: Novo ou Velho.
		Vamos começar!", 
		audio_instrucao, 
		imgavatar, 
		true
	)
	
	# Espera o áudio das instruções terminar apenas para liberar o clique do jogador...
	if audio_instrucao != null:
		await get_tree().create_timer(audio_instrucao.get_length()).timeout
	else:
		await get_tree().create_timer(3.0).timeout 
		
	sortear_novo_objeto()


func sortear_novo_objeto() -> void:
	var objetos_disponiveis = []
	for objeto in lista_de_objetos:
		if not objeto["usado"]:
			objetos_disponiveis.append(objeto)
			
	# --- CONDIÇÃO DE VITÓRIA ---
	if objetos_disponiveis.size() == 0:
		pode_interagir = false 
		jogo_rodando = false # Para o cronômetro imediatamente!
		
		if interface_trofeus != null:
			interface_trofeus.ganhar_fase()
			
		# Salva os dados processados internamente direto no Autoload Global (Fase 1)
		PlayerName.tempo_fase1 = tempo_decorrido
		PlayerName.erros_fase1 = erros_cometidos
		
		$Avatar.mudar_fala(
			"Parabeéns, você separou todos os objetos", 
			audio_concluido, 
			null, 
			false
		)
		print("Fase 1 Concluída! Erros Totais: ", erros_cometidos, " | Tempo Total: ", tempo_decorrido)
		
		# --- RECOLOCADO: Espera o parabéns terminar e muda para a próxima fase ---
		await get_tree().create_timer(3.5).timeout
		if proxima_fase != null:
			get_tree().change_scene_to_packed(proxima_fase)
		else:
			print("⚠️ AVISO: A cena da proxima_fase não foi arrastada no Inspector da Fase 1.1!")
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
	
	pode_interagir = true 


func _on_objeto_acertou(objeto_instanciado: Node2D) -> void:
	pode_interagir = false 
	
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
	
	await get_tree().create_timer(2.0).timeout
	if feedback_joia != null:
		feedback_joia.hide()
	
	var tempo_restante = 0.1
	if audio_acerto != null:
		tempo_restante = max(0.1, audio_acerto.get_length() - 1.0)
		
	await get_tree().create_timer(tempo_restante).timeout
	sortear_novo_objeto()


func _on_objeto_errou() -> void:
	pode_interagir = false 
	
	# Soma +1 no contador de erros interno
	erros_cometidos += 1
	
	if feedback_erro != null:
		feedback_erro.show()
	
	# Mantido caso sua interface de troféus atualize alguma barrinha visual na tela
	if interface_trofeus != null:
		interface_trofeus.registrar_erro()
			
	$Avatar.mudar_fala(
		"Ops! Não foi dessa vez.
		Esse objeto não pertence a essa opção.", 
		audio_erro, 
		null, 
		false
	)
	
	var tempo_espera = 2.0
	if audio_erro != null:
		tempo_espera = audio_erro.get_length()
		
	await get_tree().create_timer(tempo_espera).timeout
	
	if feedback_erro != null:
		feedback_erro.hide()
		
	pode_interagir = true



func _on_label_velho_mouse_entered() -> void:
	if pode_interagir and not $audio_velho.is_playing() and not $audio_novo.is_playing():
		$audio_velho.play()


func _on_label_novo_mouse_entered() -> void:
	if pode_interagir and not $audio_novo.is_playing() and not $audio_velho.is_playing():
		$audio_novo.play()
