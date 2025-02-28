
package.path = package.path .. ";data/scripts/systems/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"
include ("basesystem")
include ("utility")
include ("randomext")

function getBonuses(seed, rarity, permanent)
    math.randomseed(seed)

    local baseAmplification = 6 -- initial 6%
    -- add flat percentage based on rarity
    local baseAmplification = baseAmplification + (rarity.value + 1) * 5 -- add 0% (worst rarity) to +120% (best rarity) (Became 30%)

    -- add randomized percentage, span is based on rarity
    local amplification = baseAmplification + math.random() * (rarity.value + 1) * 4 -- add random value between 0% (worst rarity) and +60% (best rarity) (Became 24%)

    baseAmplification = baseAmplification / 100
    amplification = amplification / 100

    energy = -baseAmplification * 0.75 / (1.05 ^ rarity.value) -- note the minus

    -- is balanced around permanent installation
    -- permanent installation reverses this factor
    amplification = amplification * 0.4
    if permanent then
        amplification = amplification * 3.5
    end

    return amplification, energy
end

function onInstalled(seed, rarity, permanent)
    local amplification, energy = getBonuses(seed, rarity, permanent)

    addBaseMultiplier(StatsBonuses.ShieldDurability, 1 + amplification)
    addBaseMultiplier(StatsBonuses.GeneratedEnergy, energy)
end
