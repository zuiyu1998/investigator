class_name PlayerReasonBulletTarget
extends Node2D


func on_reason_update(update: int):
	var play_data := GlobalVar.get_single_player_data()
	play_data.on_update_reason(update)
