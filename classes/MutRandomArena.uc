//=============================================================================
// RandomArena, mutator originally made for UT99
// Recreated for UT2004 by Infy, Unreal Universe.
//=============================================================================
class MutRandomArena extends Mutator
    config(RandomArena);

var RandomArenaSettings Settings;
var class<Weapon> CurrentWeapon;
var class<Weapon> NextWeapon;
var int NextWeaponSwitch;
var int NextWeaponSwitchCountdown;

function PreBeginPlay()
{
    Super.PreBeginPlay();

    log("Initializing RandomArena mutator", 'RandomArena');

    Settings = new class'RandomArenaSettings';
    Settings.SaveConfig();
    SaveConfig();

    log("Settings loaded, weapon switch interval is configured to " $Settings.WeaponSwitchIntervalInSeconds$ ", using " 
        $Settings.Weapons.Length$ " weapons.", 'RandomArena');
    
    PickNextWeapon();
    HandleWeaponSwitch();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local bool bIsCurrentWeapon;

    bIsCurrentWeapon = CurrentWeapon != None && string(Other.Class) == string(CurrentWeapon);

    if(Weapon(Other) != None && !bIsCurrentWeapon)
        return false;
    else if (WeaponPickup(Other) != None)
        return false;
    else if(Settings.bRemoveBonusPickups && Pickup(Other) != None)
        return false;

    return true;
}

function PickNextWeapon()
{
    if(Settings.Weapons.Length == 1)
    {
        NextWeapon = Settings.Weapons[0];
        return;
    }

    while (NextWeapon == None || NextWeapon == CurrentWeapon)
        NextWeapon = Settings.Weapons[Rand(Settings.Weapons.Length)];
}

function MatchStarting()
{
    CalculateNextWeaponSwitch();
    SetTimer(1, true);
}

function CalculateNextWeaponSwitch()
{
    NextWeaponSwitch = Level.TimeSeconds + Settings.WeaponSwitchIntervalInSeconds;
    NextWeaponSwitchCountdown = NextWeaponSwitch - 3;
}

function ModifyPlayer(Pawn Other)
{
    local InfiniteAmmoInventory InfAmmoInv;

    Super.ModifyPlayer(Other);
    RemoveAllWeapons(Other);

    InfAmmoInv = Spawn(class'InfiniteAmmoInventory', Other);
    Other.GiveWeapon(string(CurrentWeapon));
    Other.AddInventory(InfAmmoInv);
}

function RemoveAllWeapons(Pawn Other)
{
    local Inventory Inv;

    if(Other.Inventory == None)
        return;

    for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
    {
        if(Weapon(Inv) != None)
        {
            Other.DeleteInventory(Inv);
            Inv.Destroy();
        }
    }
}

function Timer()
{
    if(Level.Game.bGameEnded)
        return;
    
    if(Level.TimeSeconds >= NextWeaponSwitchCountdown && Level.TimeSeconds < NextWeaponSwitch)
        HandleWeaponSwitchCountdown();
    else if(Level.TimeSeconds >= NextWeaponSwitch)
        HandleWeaponSwitch();
}

function HandleWeaponSwitchCountdown()
{
    local int TimeRemaining;

    TimeRemaining = NextWeaponSwitch - Level.TimeSeconds;
    TimeRemaining++; // HandleWeaponSwitchCountdown is called a second later
    AnnounceNextWeaponCountdown(TimeRemaining);
}

function AnnounceNextWeaponCountdown(int SecondsRemaining)
{
    local WeaponSwitchCountDownMessageArgs Args;

    Args = new class'WeaponSwitchCountDownMessageArgs';
    Args.NextWeaponName = NextWeapon.default.ItemName;
	BroadcastLocalizedMessage(class'WeaponSwitchCountDownMessage',SecondsRemaining,,,Args);
}

function HandleWeaponSwitch() 
{
    local Controller C;
    local Pawn Other;

    CalculateNextWeaponSwitch();

    CurrentWeapon = NextWeapon;
    PickNextWeapon();

    for(C = Level.ControllerList; C != None; C = C.NextController)
    {
        Other = C.Pawn;

        if(Other == None)
            continue;

        RemoveAllWeapons(Other);
        Other.GiveWeapon(string(CurrentWeapon));
    }
}

defaultproperties {
    FriendlyName="Random Arena"
    GroupName="RandomArena"
    Description="Gives players random weapons every x seconds. The time between weapon switches and the used weapons can be configured in the mutator's configuration file."
}