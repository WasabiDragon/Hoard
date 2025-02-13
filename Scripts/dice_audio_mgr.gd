extends Node
class_name dice_audio_mgr

@onready var _attackSound = $AttackSound as audio_bank
@onready var _lockedSound = $LockedSound as audio_bank
@onready var _rollSound = $RollSound as audio_bank

func rollSound() -> void:
	_rollSound.play_from_list()

func attackSound() -> void:
	_attackSound.play_from_list()

func lockedSound() -> void:
	_lockedSound.play_from_list()