extends Node

enum EnemyDebuffStates {
	STUNNED,
	SNARED,
	FREEZED,
	SLOWED,
	BLEEDING, 
	IMMUNE,
	NO_DEBUFF
}

enum EnemyStates {
	IDLE,
	CAN_DASH,
	CAN_ATTACK,
	CANT_ATTACK,
	ATTACKED
}
