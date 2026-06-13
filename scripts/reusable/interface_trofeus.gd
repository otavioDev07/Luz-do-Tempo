extends CanvasLayer 

@onready var trofeu_1 = $HBoxContainer/Trofeu1 
@onready var trofeu_2 = $HBoxContainer/Trofeu2 
@onready var trofeu_3 = $HBoxContainer/Trofeu3 

@onready var label_relogio = $Relogio 

var imagem_trofeu_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

var perdeu_tempo: bool = false
var perdeu_erros: bool = false

# --- VARIÁVEIS INTERNAS DE CONTAGEM ---
var tempo_decorrido: float = 0.0
var erros_cometidos: int = 0
var timer_rodando: bool = false

# --- LIMITES ---
const LIMITE_TEMPO: float = 300.0 # 5 minutos fixos
var limite_erros_fase: int = 5 # Variável (padrão é 5)

# ---------------------------------------------------------
# INICIALIZAÇÃO
# Os parâmetros de tempo e erro já decorridos são opcionais (= 0).
# O limite de erros também pode ser ajustado aqui.
# ---------------------------------------------------------
func inicializar(tempo_inicial: float = 0.0, erros_iniciais: int = 0, limite_de_erros: int = 5) -> void:
	tempo_decorrido = tempo_inicial
	erros_cometidos = erros_iniciais
	limite_erros_fase = limite_de_erros
	
	perdeu_tempo = false
	perdeu_erros = false
	timer_rodando = true
	
	atualizar_relogio()
	# Verifica logo de cara caso o tempo/erros iniciais passados já estourem o limite
	verificar_estado()

func _process(delta: float) -> void:
	# A contagem do tempo e a validação do limite acontecem 100% aqui dentro
	if timer_rodando:
		tempo_decorrido += delta
		atualizar_relogio()
		
		if not perdeu_tempo and tempo_decorrido >= LIMITE_TEMPO:
			perder_trofeu_tempo()

func atualizar_relogio() -> void:
	if label_relogio != null:
		var minutos = int(tempo_decorrido) / 60
		var segundos = int(tempo_decorrido) % 60
		label_relogio.text = "%02d:%02d" % [minutos, segundos]

# ---------------------------------------------------------
# VALIDAÇÃO DE ERROS
# A cena principal só precisa chamar essa função quando o jogador errar.
# ---------------------------------------------------------
func registrar_erro() -> void:
	erros_cometidos += 1
	verificar_estado()

# Função centralizada que valida se o jogador perdeu algum troféu
func verificar_estado() -> void:
	if not perdeu_tempo and tempo_decorrido >= LIMITE_TEMPO:
		perder_trofeu_tempo()
		
	if limite_erros_fase > 0 and not perdeu_erros and erros_cometidos >= limite_erros_fase:
		perder_trofeu_erros()

func perder_trofeu_tempo() -> void:
	perdeu_tempo = true
	if trofeu_2 != null:
		trofeu_2.texture = imagem_trofeu_vazio

func perder_trofeu_erros() -> void:
	perdeu_erros = true
	if trofeu_3 != null:
		trofeu_3.texture = imagem_trofeu_vazio

func ganhar_fase() -> void:
	timer_rodando = false 
	print("--- FIM DA FASE ---")
	print("Tempo total: ", label_relogio.text, " | Erros totais: ", erros_cometidos)
