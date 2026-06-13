extends CanvasLayer 

@onready var trofeu_1 = $HBoxContainer/Trofeu1 
@onready var trofeu_2 = $HBoxContainer/Trofeu2 
@onready var trofeu_3 = $HBoxContainer/Trofeu3 

var imagem_trofeu_vazio = preload("res://sprites/avatares/trofeu_vazio.png")

var perdeu_tempo: bool = false
var perdeu_erros: bool = false

# --- VARIÁVEIS DO TIMER INTERNO ---
var tempo_decorrido: float = 0.0
var limite_de_tempo: float = 5.0 # 5 minutos (300 segundos)
var timer_rodando: bool = true # Controla se o cronômetro está ativo

func _process(delta: float) -> void:
	# O troféu conta o próprio tempo!
	if timer_rodando and not perdeu_tempo:
		tempo_decorrido += delta
		if tempo_decorrido >= limite_de_tempo:
			perder_trofeu_tempo()

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

# Função para a fase chamar quando o jogador ganhar, para o tempo não continuar rodando à toa
func parar_timer() -> void:
	timer_rodando = false
	
func ganhar_fase() -> void:
	timer_rodando = false # Para o tempo na hora!
	
	print("--- FIM DA FASE: Contabilizando Troféus ---")
	print("Fase Concluída com Sucesso! Troféu 1 (Vitória) GARANTIDO.")
	
	# Aqui você faz uma checagem rápida para ver o que sobrou
	if not perdeu_tempo:
		print("🏆 Jogador levou o Troféu 2 (Tempo)!")
	if not perdeu_erros:
		print("🏆 Jogador levou o Troféu 3 (Sem Erros)!")
		
	# Se no futuro você quiser fazer os troféus brilharem ou piscarem na vitória,
	# o código de animação vai entrar bem aqui dentro!
