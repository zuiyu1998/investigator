class_name GameStateManager
extends Node2D


func start_game():
	GlobalVar.get_single_scene_manager().change_scene("res://src/level/level.tscn")


func goto_game_end():
	GlobalVar.get_single_game_end().show_game_end()


func restart_game():
	GlobalVar.get_single_player_data().reset()
	GlobalVar.get_single_scene_manager().change_scene("res://src/level/level.tscn")


func goto_main_menu():
	GlobalVar.get_single_player_data().reset()
	GlobalVar.get_single_scene_manager().change_scene("res://src/ui/main_menu/main_menu.tscn")
