class InfiniteAmmoInventory extends Inventory;

function PreBeginPlay()
{
    Super.PreBeginPlay();
    SetTimer(0.1, true);
}

function Timer()
{
    if(Owner == None || Pawn(Owner) == None)
        Destroy();
    else if(Pawn(Owner).Weapon == None)
        return;

    Pawn(Owner).Weapon.SuperMaxOutAmmo();
}