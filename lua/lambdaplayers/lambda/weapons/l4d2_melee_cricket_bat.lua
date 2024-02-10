local random = math.random

local rofTbl = { 0.8, 1.0 }
local dmgTbl = { 40, 50 }
local dmgForceTbl = { Forward = 150, Right = -75, Up = 125 }
local hitSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_01.mp3",
    "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_02.mp3",
    "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_03.mp3"
}

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_cricket_bat = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_cricket_bat.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Cricket Bat",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_cricket_bat",
        ismelee = true,
        keepdistance = 40,
        attackrange = 80,
        bonemerge = true,
        islethal = true,

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
            wepent.L4D2Data.RateOfFire = rofTbl
            wepent.L4D2Data.HitDelay = 0.275
            wepent.L4D2Data.Range = 65
            wepent.L4D2Data.Damage = dmgTbl
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.DamageForce = dmgForceTbl
            wepent.L4D2Data.HitSound = hitSndTbl

            if random( 1, 3 ) == 1 then 
                local skinCount = wepent:SkinCount()
                if skinCount > 0 then wepent:SetSkin( random( 0, skinCount - 1 ) ) end
            end
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})