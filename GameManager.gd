extends Node

var erros = 0

func registrar_erro():
	erros += 1

func get_erros():
	return erros

func resetar_erros():
	erros = 0
