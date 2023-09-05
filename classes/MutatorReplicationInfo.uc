class MutatorReplicationInfo extends ReplicationInfo;

var string NextWeaponName;

replication
{
    reliable if (Role == ROLE_Authority) NextWeaponName;
}

defaultproperties {
    bNetNotify=true
    NetUpdateFrequency=1
}