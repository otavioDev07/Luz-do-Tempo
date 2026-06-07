extends AudioStreamPlayer


var musica_menu = preload("res://sprites/audios/reusable/musica_menu.mp3")
var musica_jogo = preload("res://sprites/audios/reusable/musica_jogo.mp3")

func tocar_menu():
	volume_db = -25
	stream = musica_menu
	play()

func tocar_jogo():
	volume_db = -35
	stream = musica_jogo
	play()
