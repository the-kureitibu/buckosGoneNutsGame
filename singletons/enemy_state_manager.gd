extends Node

enum EnemyDebuffStates {
	CAN_BE_STUNNED,
	CAN_BE_SNARED,
	CAN_BE_FREEZED,
	CAN_BE_SLOWED,
	CAN_BLEED
}

enum EnemyStates {
	IDLE,
	CAN_DASH,
	CAN_ATTACK,
	CANT_ATTACK
}
