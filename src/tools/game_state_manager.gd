class_name GameStateManager
extends Node2D


func start_game():
	GlobalVar.get_single_scene_manager().change_scene("res://src/level/level.tscn")


func goto_main_menu():
	GlobalVar.get_single_player_data().reset()
	GlobalVar.get_single_scene_manager().change_scene("res://src/ui/main_menu/main_menu.tscn")
