class_name GodConsts
extends RefCounted

enum GodKind { SI_CHEN, GOD, NONE }


static func is_si_chen(kind: GodKind) -> bool:
	if kind == GodKind.SI_CHEN:
		return true
	return false


static func is_god(kind: GodKind) -> bool:
	if kind == GodKind.GOD:
		return true
	return false
