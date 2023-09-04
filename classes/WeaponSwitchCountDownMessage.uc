class WeaponSwitchCountDownMessage extends CriticalEventPlus
	abstract;

var const string MessagePrefix;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string NextWeaponName;
    // may need to be replicated in MP
    NextWeaponName = class'MutRandomArena'.default.NextWeaponName;
    return NextWeaponName $" in "$ Switch;
}

defaultproperties
{
    DrawColor=(R=52,G=79,B=235)
    StackMode=SM_Down
    PosY=0.15
}
