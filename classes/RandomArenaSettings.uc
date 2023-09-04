class RandomArenaSettings extends Object
    config(RandomArena);

var globalconfig int WeaponSwitchIntervalInSeconds;
var globalconfig array<class<Weapon> > Weapons;
var globalconfig bool bRemoveBonusPickups;

defaultproperties {
    WeaponSwitchIntervalInSeconds=15
    Weapons(0)=class'ShieldGun'
    Weapons(1)=class'AssaultRifle'
    Weapons(2)=class'BioRifle'
    Weapons(3)=class'ShockRifle'
    Weapons(4)=class'LinkGun'
    Weapons(5)=class'MiniGun'
    Weapons(6)=class'FlakCannon'
    Weapons(7)=class'RocketLauncher'
    Weapons(8)=class'SniperRifle'
    Weapons(9)=class'ClassicSniperRifle'
    Weapons(10)=class'SuperShockRifle'
    bRemoveBonusPickups=true
}