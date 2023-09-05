class RandomArenaClientReplication extends LinkedReplicationInfo;

var MutatorReplicationInfo MRI;

simulated function AnnounceNextWeaponCountdown(int SecondsRemaining)
{
    PlayerController(Owner).ReceiveLocalizedMessage(class'WeaponSwitchCountDownMessage',SecondsRemaining,,,self);
}