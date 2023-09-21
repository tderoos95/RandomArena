class RandomArenaClientReplication extends LinkedReplicationInfo;

var MutatorReplicationInfo MRI;

replication
{
    reliable if (Role == ROLE_Authority) MRI;
}

simulated function AnnounceNextWeaponCountdown(int SecondsRemaining)
{
    PlayerController(Owner).ReceiveLocalizedMessage(class'WeaponSwitchCountDownMessage',SecondsRemaining,,,self);
}

defaultproperties {
}