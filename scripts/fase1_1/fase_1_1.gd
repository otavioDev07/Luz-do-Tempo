extends Node2D

# 1. Indicamos o caminho EXATO de cada áudio dentro da pasta do projeto
# O caminho sempre começa com "res://"
var audio_instrucao = preload("res://sprites/audios/fase1_1/instrucao.mp3")
var audio_acerto: AudioStream #= preload("res://pasta_dos_audios/acerto.mp3")
var audio_erro: AudioStream # = preload("res://pasta_dos_audios/erro.mp3")

func _ready() -> void:
	# O resto do código continua exatamente igual!
	$Avatar.mudar_fala(
		"Separe o objeto antigo do novo!", 
		audio_instrucao, 
		true
	)

func _on_objeto_acertou() -> void:
	$Avatar.mudar_fala(
		"Muito bem! Você acertou!", 
		audio_acerto, 
		false
	)

func _on_objeto_errou() -> void:
	$Avatar.mudar_fala(
		"Tente novamente! Esse objeto pertence à outra caixa.", 
		audio_erro, 
		false
	)
