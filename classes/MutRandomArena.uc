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
var string NextWeaponName;

function PreBeginPlay()
{
    Super.PreBeginPlay();

    log("Initializing RandomArena mutator...", 'RandomArena');
    log("Loading settings...", 'RandomArena');

    Settings = new class'RandomArenaSettings';
    Settings.SaveConfig();
    SaveConfig();

    log("Settings loaded, interval configured to " $Settings.WeaponSwitchIntervalInSeconds$ ", using " 
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
    if (WeaponPickup(Other) != None)
        return false;
    else if(Settings.bRemoveBonusPickups && Pickup(Other) != None)
        return false;

    return true;
}

function PickNextWeapon()
{
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
    Super.ModifyPlayer(Other);

    RemoveAllWeapons(Other);
    Other.GiveWeapon(string(CurrentWeapon));
}

function RemoveAllWeapons(Pawn Other)
{
    local Inventory Inv;

    for (Inv=Other.Inventory; Inv != None; Inv=Inv.Inventory)
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
    SendMessageToAllPlayers(TimeRemaining);
}

function SendMessageToAllPlayers(int TimeRemaining)
{
    class'MutRandomArena'.default.NextWeaponName = NextWeapon.default.ItemName;
	BroadcastLocalizedMessage(class'WeaponSwitchCountDownMessage',TimeRemaining);
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