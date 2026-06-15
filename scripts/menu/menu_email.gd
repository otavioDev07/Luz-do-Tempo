extends Control

# 🌟 CONFIRA O CAMINHO DO SEU NÓ: Certifique-se de que o input de texto se chama exatamente 'input_email' no seu editor
@onready var campo_email = $caixa_de_texto/input_email 

# Nó de internet do Godot criado via código para enviar os dados em background
var http_request: HTTPRequest = null


func _ready() -> void:
	$woosh.play()
	
	# Inicializa o nó de requisições HTTP e adiciona ele na árvore de nós
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Conecta o sinal de resposta da internet à função que monitora se deu certo ou errado
	http_request.request_completed.connect(_on_request_completed)


func _process(delta: float) -> void:
	pass


func _on_botao_continuar_pressed() -> void:
	var email_digitado = campo_email.text.strip_edges()
	
	# CASO A: Se o campo estiver vazio, apenas volta pro menu normalmente
	if email_digitado == "":
		print("ℹ️ Campo de e-mail vazio. Voltando para o menu principal...")
		_voltar_para_o_menu_e_resetar()
		return
	
	$botao_continuar.disabled = true
	enviar_relatorio_background_api(email_digitado)
	await http_request.request_completed
	_voltar_para_o_menu_e_resetar()


func enviar_relatorio_background_api(email_destino: String) -> void:
	# 1. Coleta e cálculos matemáticos para o relatório pedagógico (idênticos à planilha)
	var total_erros = PlayerName.erros_fase1 + PlayerName.erros_fase1_2 + PlayerName.erros_fase2
	var tempo_total = PlayerName.tempo_fase1 + PlayerName.tempo_fase1_2 + PlayerName.tempo_fase2
	var tempo_medio = tempo_total / 3.0
	
	var acertos_brutos = 23 - total_erros
	var porcentagem_acertos = (float(acertos_brutos) / 23.0) * 100.0
	porcentagem_acertos = clamp(porcentagem_acertos, 0.0, 100.0)
	
	var tempo_extra_total = max(0.0, PlayerName.tempo_fase1 - 300.0) + max(0.0, PlayerName.tempo_fase1_2 - 300.0) + max(0.0, PlayerName.tempo_fase2 - 300.0)
	var pontuacao: float = clamp(100.0 - (total_erros * 3.5) - (tempo_extra_total / 5.0), 0.0, 100.0)
	
	var nota_conceito = "F"
	if pontuacao >= 90.0: nota_conceito = "A"
	elif pontuacao >= 75.0: nota_conceito = "B"
	elif pontuacao >= 60.0: nota_conceito = "C"
	elif pontuacao >= 45.0: nota_conceito = "D"
	elif pontuacao >= 25.0: nota_conceito = "E"
	
	var feedback = PlayerName.obter_feedback_pedagogico(nota_conceito)
	
	# 2. Montagem do corpo de texto formatado que vai cair dentro da sua tag {{message}}
	var corpo_texto = "=== RELATÓRIO DE DESEMPENHO PEDAGÓGICO ===\n\n"
	corpo_texto += "Aluno: %s\n" % PlayerName.player_name
	corpo_texto += "Nota Conceito: %s\n" % nota_conceito
	corpo_texto += "Porcentagem de Acertos: %.1f%%\n" % porcentagem_acertos
	corpo_texto += "Erros Totais Cometidos: %d\n" % total_erros
	corpo_texto += "Tempo Médio por Fase: %s\n\n" % formatar_tempo_tela(tempo_medio)
	corpo_texto += "Feedback Pedagógico:\n%s" % feedback

	# 🌟 3. CONFIGURAÇÃO DO EMAILJS: Coloque as suas chaves reais entre as aspas aqui embaixo:
	var url = "https://api.emailjs.com/api/v1.0/email/send"
	var dados_json = {
		"service_id": "service_uvpwexh",
		"template_id": "template_k6okz7k",
		"user_id": "eCviszlGN0Xvear21",
		"template_params": {
			"to_email": email_destino,
			"subject": "Relatório Luz do Tempo",
			"name": PlayerName.player_name,     
			"message": corpo_texto             
		}
	}
	
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(dados_json))
	print("🚀 Enviando dados em background para o EmailJS...")


func _voltar_para_o_menu_e_resetar() -> void:
	# Guarda o e-mail digitado no histórico antes de limpar as variáveis (caso queira usar em planilhas futuras)
	PlayerName.player_email = campo_email.text.strip_edges()
	
	# Limpa o jogador atual para a próxima rodada da fila
	PlayerName.resetar_jogador_atual()
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func formatar_tempo_tela(tempo_em_segundos: float) -> String:
	var minutos = int(tempo_em_segundos) / 60
	var segundos = int(tempo_em_segundos) % 60
	return "%02d:%02d" % [minutos, segundos]


# 🌟 MONITOR DE REDE: Imprime no console do Godot se a internet enviou de verdade ou se deu erro de credenciais
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("✅ EMAILJS: Relatório enviado com sucesso para a caixa de entrada!")
	else:
		print("❌ EMAILJS: Erro ao enviar. Código de resposta HTTP: ", response_code)
		print("Resposta do servidor: ", body.get_string_from_utf8())


# --- ANIMAÇÕES E EFEITOS SONOROS MANTIDOS DO SEU JOGO ---

func _on_botao_continuar_mouse_entered() -> void:
	$botao.stop()
	$botao.play()
	
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.1, 1.1), 0.15)


func _on_botao_continuar_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($botao_continuar, "scale", Vector2(1.0, 1.0), 0.15)


func _on_imput_email_text_changed(new_text: String) -> void:
	$digitando.stop()
	$digitando.play()
