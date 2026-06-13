extends Node2D

# ---------------------------------------------------------
# IMPORTAÇÃO DOS ÁUDIOS 
# (Verifique se o caminho "res://..." está correto de acordo com a sua pasta)
# ---------------------------------------------------------
var audio_relatorio = preload("res://sprites/audios/relatorio/relatorio.mp3")
var audio_nota = preload("res://sprites/audios/relatorio/nota.mp3")
var audio_tot_erros = preload("res://sprites/audios/relatorio/tot_erros.mp3")
var audio_tempo_medio = preload("res://sprites/audios/relatorio/tempo_medio.mp3")
var audio_maior_tempo = preload("res://sprites/audios/relatorio/maior_tempo.mp3")
var audio_menor_tempo = preload("res://sprites/audios/relatorio/menor_tempo.mp3")

# Nome do seu nó de áudio (ajuste se o nome na cena for diferente)
@onready var tocador_audio = $AudioStreamPlayer2D 

func _ready() -> void:
	gerar_relatorio()

func gerar_relatorio() -> void:
	# 1. CÁLCULO DE ERROS TOTAIS
	var total_erros = PlayerName.erros_fase1 + PlayerName.erros_fase1_2 + PlayerName.erros_fase2

	# 2. CÁLCULO DO TEMPO MÉDIO
	var tempo_total = PlayerName.tempo_fase1 + PlayerName.tempo_fase1_2 + PlayerName.tempo_fase2
	var tempo_medio = tempo_total / 3.0

	# 3. PIOR (MAIOR) E MELHOR (MENOR) TEMPO
	var lista_tempos = [PlayerName.tempo_fase1, PlayerName.tempo_fase1_2, PlayerName.tempo_fase2]
	var pior_tempo_valor = lista_tempos.max()
	var melhor_tempo_valor = lista_tempos.min()

	# 4. EXIBIR OS DADOS NOS LABELS (FORMATO RELÓGIO MM:SS)
	$PorAcerto.text += " " + str(total_erros)
	$MedTempo.text += " " + formatar_tempo_relogio(tempo_medio)
	$MaiorTempo.text += " " + formatar_tempo_relogio(pior_tempo_valor)
	$MenorTempo.text += " " + formatar_tempo_relogio(melhor_tempo_valor)

	# 5. INICIAR A SEQUÊNCIA DE FALA E ÁUDIOS!
	tocar_sequencia_audios(total_erros, tempo_medio, pior_tempo_valor, melhor_tempo_valor)


# ---------------------------------------------------------
# FUNÇÕES DE SEQUÊNCIA DE ÁUDIO E INTELIGÊNCIA ARTIFICIAL
# ---------------------------------------------------------

func tocar_sequencia_audios(erros: int, t_medio: float, t_maior: float, t_menor: float) -> void:
	# 1. Relatório
	await tocar_audio_gravado(audio_relatorio)
	
	# 2. Nota (Como você não calculou uma nota em números no script, ele só vai tocar o áudio)
	await tocar_audio_gravado(audio_nota)
	
	# 3. Total de Erros
	await tocar_audio_gravado(audio_tot_erros)
	falar_valor(str(erros)) # IA fala o número de erros
	await esperar_tts()
	
	# 4. Tempo Médio
	await tocar_audio_gravado(audio_tempo_medio)
	falar_valor(formatar_tempo_fala(t_medio)) # IA fala o tempo por extenso
	await esperar_tts()
	
	# 5. Maior Tempo
	await tocar_audio_gravado(audio_maior_tempo)
	falar_valor(formatar_tempo_fala(t_maior))
	await esperar_tts()
	
	# 6. Menor Tempo
	await tocar_audio_gravado(audio_menor_tempo)
	falar_valor(formatar_tempo_fala(t_menor))
	await esperar_tts()

# Toca o MP3 e espera ele terminar
func tocar_audio_gravado(audio_stream: AudioStream) -> void:
	if tocador_audio != null and audio_stream != null:
		tocador_audio.stream = audio_stream
		tocador_audio.play()
		await tocador_audio.finished
		await get_tree().create_timer(0.2).timeout # Pausa rápida entre o áudio humano e a IA

# Chama a IA do Godot para ler o texto
# Substitua a função antiga por esta:
func falar_valor(texto: String) -> void:
	var todas_vozes = DisplayServer.tts_get_voices()
	
	# --- DETETIVE: Printa tudo no console para sabermos o que está acontecendo ---
	print("\n=== [DEBUG TTS] BUSCANDO VOZES NO SEU SISTEMA ===")
	for v in todas_vozes:
		print("- ID: ", v.get("id"), " | Nome: ", v.get("name"), " | Idioma: ", v.get("language"))
	print("================================================\n")
	
	var voz_id = ""
	
	# Busca ultra agressiva por qualquer pista de português
	for voz in todas_vozes:
		var lang = voz.get("language", "").to_lower()
		var nome = voz.get("name", "").to_lower()
		
		# Verifica se tem 'pt', 'por', 'brazil', 'portugal' ou os nomes das vozes padrão da Microsoft/Google
		if "pt" in lang or "por" in lang or "brazil" in nome or "portugal" in nome or "maria" in nome or "daniel" in nome or "francisca" in nome:
			voz_id = voz.get("id", "")
			print("✅ SUCESSO: Encontrei e usei a voz: ", voz.get("name"))
			break # Para no primeiro que achar
			
	if voz_id == "":
		print("❌ AVISO: Nenhuma voz em português foi detectada. O Godot foi obrigado a usar a padrão em inglês.")
	
	DisplayServer.tts_speak(texto, voz_id, 100, 1.0, 1.0, 0, true)

# Trava o código enquanto a IA estiver falando
func esperar_tts() -> void:
	await get_tree().create_timer(0.2).timeout # Tempo pra engine processar o início da fala
	while DisplayServer.tts_is_speaking():
		await get_tree().process_frame # Espera frame por frame até a voz calar a boca
	await get_tree().create_timer(0.5).timeout # Pausa de meio segundo antes do próximo áudio


# ---------------------------------------------------------
# FUNÇÕES DE FORMATAÇÃO DE TEMPO
# ---------------------------------------------------------

# Formato visual para o texto na tela (ex: 02:30)
func formatar_tempo_relogio(tempo_em_segundos: float) -> String:
	var minutos = int(tempo_em_segundos) / 60
	var segundos = int(tempo_em_segundos) % 60
	return "%02d:%02d" % [minutos, segundos]

# Formato por extenso para a IA falar (ex: "2 minutos e 30 segundos")
func formatar_tempo_fala(tempo_em_segundos: float) -> String:
	var minutos = int(tempo_em_segundos) / 60
	var segundos = int(tempo_em_segundos) % 60
	var texto = ""
	
	if minutos > 0:
		if minutos == 1:
			texto += "1 minuto"
		else:
			texto += str(minutos) + " minutos"
			
		if segundos > 0:
			texto += " e "
			
	if segundos > 0 or minutos == 0:
		if segundos == 1:
			texto += "1 segundo"
		else:
			texto += str(segundos) + " segundos"
			
	return texto


# ---------------------------------------------------------
# BOTÕES 
# ---------------------------------------------------------

func _on_botao_continuar_pressed() -> void:
	# Como precaução, fazemos a IA calar a boca caso o jogador pule de tela enquanto ela fala!
	DisplayServer.tts_stop() 
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_botao_continuar_mouse_entered() -> void:
	if $botao != null:
		$botao.stop()
		$botao.play()
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)

func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)
