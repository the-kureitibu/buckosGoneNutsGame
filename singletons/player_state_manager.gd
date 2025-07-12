extends Node

enum RageState {
	IDLE,
	RAGING,
	RAGE_RECOVERING,
	RAGE_DONE
}

enum PlayerState {
	IDLE,
	CAN_ATTACK,
	CANT_ATTACK,
	STUNNED,
	SLOWED,
	BLEEDING
}
