package.path = package.path .. ";data/scripts/lib/?.lua"

include("galaxy")
include("randomext")
include("weapontype")

-- local WeaponGenerator = {} is is needed?

function WeaponGenerator.generateRocketLauncher(rand, dps, tech, material, rarity)
    local weapon = Weapon()
    weapon:setProjectile()

    local fireDelay = rand:getFloat(0.5, 1.5)
    local reach = rand:getFloat(1300, 1800)
    local damage = dps * fireDelay
    local speed = rand:getFloat(150, 200)
    local existingTime = reach / speed

    weapon.fireDelay = fireDelay
    weapon.reach = reach
    weapon.appearanceSeed = rand:getInt()
    weapon.seeker = false
    weapon.appearance = WeaponAppearance.RocketLauncher
    weapon.name = "Rocket Launcher /* Weapon Name*/"%_T
    weapon.prefix = "Launcher /* Weapon Prefix*/"%_T
    weapon.icon = "data/textures/icons/rocket-launcher.png" -- previously missile-swarm.png
    weapon.sound = "launcher"
    weapon.accuracy = 0.99 - rand:getFloat(0, 0.02)

    weapon.damage = damage
    weapon.damageType = DamageType.Physical
    weapon.impactParticles = ImpactParticles.Explosion
    weapon.impactSound = 1
    weapon.impactExplosion = true

    -- 10 % chance for anti matter damage
    if rand:test(0.1) then
        WeaponGenerator.addAntiMatterDamage(rand, weapon, rarity, 2, 0.15, 0.2)
    end

    weapon.psize = rand:getFloat(0.2, 0.4)
    weapon.pmaximumTime = existingTime
    weapon.pvelocity = speed
    weapon.pcolor = ColorHSV(rand:getFloat(10, 60), 0.7, 1)
    weapon.pshape = ProjectileShape.Rocket

    if rand:test(0.05) then
        local shots = {2, 2, 2, 2, 2, 3, 4}
        weapon.shotsFired = shots[rand:getInt(1, #shots)]
        weapon.damage = (weapon.damage * 1.5) / weapon.shotsFired
    end

    WeaponGenerator.adaptWeapon(rand, weapon, tech, material, rarity)

    -- these have to be assigned after the weapon was adjusted since the damage might be changed
    weapon.recoil = weapon.damage * 2
    weapon.explosionRadius = math.sqrt(weapon.damage * 5)

    return weapon
end