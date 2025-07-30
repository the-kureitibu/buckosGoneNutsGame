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

var boss_state = EnemyStates.IDLE

enum EnemyStates {
	IDLE,
	CAN_DASH,
	CAN_ATTACK,
	CANT_ATTACK,
	ATTACKED,
	BOSS_DEATH,
	BOSS_SPAWNED
}
