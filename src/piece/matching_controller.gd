class_name MatchingController
extends RefCounted
# todo 神明相同
enum MatchType {
	# 可以匹配任何棋子
	ALL,
	# 必须相同
	SIGLE
}
var _match_type: MatchType
var _id: int = -1
var _count: int = 0


func check_match_type(match_type: MatchType, id: int) -> bool:
	if not _match_type:
		_match_type = match_type
		_id = id
		_count += 1
		return true

	if match_type == MatchType.ALL:
		_count += 1
		return true

	if _match_type == MatchType.ALL:
		_match_type = match_type
		_id = id
		_count += 1
		return true

	if _id == id:
		_count += 1
		return true

	return false


func get_match_type_count() -> int:
	return _count
