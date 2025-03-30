class_name PlayerHealthBulletTarget
extends Node2D


func on_helath_update(update: int):
	var play_data := GlobalVar.get_single_player_data()
	play_data.on_update_helath(update)
