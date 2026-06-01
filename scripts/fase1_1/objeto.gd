extends Area2D

var arrastando: bool = false
var posicao_inicial: Vector2

# Variáveis de identidade
var nome_do_objeto: String = ""
var grupo_correto: String = ""

# Variável nova: Impede que o jogador arraste de novo depois que acertar
var fixado: bool = false 

# --- REFERÊNCIA DO ÁUDIO ---
@onready var tocador_de_audio = $AudioStreamPlayer2D

func _ready() -> void:
	# Conecta o sinal de passar o mouse automaticamente via código!
	mouse_entered.connect(_on_mouse_entered)


# --- ATUALIZADO: Agora recebe o 4º parâmetro (audio_obj) ---
func configurar_objeto(nome: String, tipo_grupo: String, textura: Texture2D, audio_obj: AudioStream) -> void:
	nome_do_objeto = nome
	grupo_correto = tipo_grupo
	posicao_inicial = global_position
	$Sprite2D.texture = textura
	
	# Coloca o áudio recebido da Fase 1.1 dentro do tocador do objeto
	if tocador_de_audio != null:
		tocador_de_audio.stream = audio_obj
	
	# Ajusta o tamanho da imagem para um máximo de 250 pixels na tela
	if textura != null:
		var tamanho_original = textura.get_size()
		var tamanho_maximo = 250.0 
		var maior_lado = max(tamanho_original.x, tamanho_original.y)
		var fator_escala = tamanho_maximo / maior_lado
		
		$Sprite2D.scale = Vector2(fator_escala, fator_escala)
		$CollisionShape2D.shape.size = tamanho_original * fator_escala

func _process(_delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position()

# Essa função só funciona quando o mouse está EM CIMA do objeto
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# --- TRAVA DE INTERAÇÃO ---
	# Se o objeto estiver fixado OU a Fase disser que NÃO PODE interagir, ignora o clique!
	if fixado or not get_parent().pode_interagir: 
		return 
		
	# Detecta APENAS quando o jogador APERTA o botão esquerdo
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando = true

# Essa função ouve TUDO o que acontece na tela inteira
func _input(event: InputEvent) -> void:
	# Se o objeto estava sendo arrastado e o botão do mouse foi SOLTO em qualquer lugar
	if arrastando and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			arrastando = false
			verificar_soltura()

func verificar_soltura() -> void:
	var areas_tocadas = get_overlapping_areas()
	var acertou = false
	
	for area in areas_tocadas:
		if area.is_in_group(grupo_correto): 
			acertou = true
			fixado = true # Trava o objeto
			
			# Desliga a colisão de forma segura para não atrapalhar outros objetos
			$CollisionShape2D.set_deferred("disabled", true) 
			
			# Avisa a Fase 1.1 e manda a si mesmo (self) como parâmetro
			if get_parent().has_method("_on_objeto_acertou"):
				get_parent()._on_objeto_acertou(self) 
			
			break
			
		elif area.is_in_group("antigo") or area.is_in_group("novo"): 
			if get_parent().has_method("_on_objeto_errou"):
				get_parent()._on_objeto_errou()
			
			global_position = posicao_inicial 
			break
	
	if not acertou and areas_tocadas.size() == 0:
		global_position = posicao_inicial


# --- NOVA FUNÇÃO: Toca o áudio ---
# --- NOVA FUNÇÃO: Toca o áudio ---
func _on_mouse_entered() -> void:
	# --- TRAVA DE ÁUDIO ---
	# Adicionamos "not arrastando" para o som não repetir enquanto o jogador move o objeto
	if not fixado and not arrastando and get_parent().pode_interagir and tocador_de_audio != null and tocador_de_audio.stream != null:
		# Verifica se não está tocando no momento, para não encavalar o áudio
		if not tocador_de_audio.playing:
			tocador_de_audio.play()
