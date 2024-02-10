local rofTbl = { 0.9, 1.1 }
local swingSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_swing_miss1.mp3",
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_swing_miss2.mp3"
}
local dmgTbl = { 50, 55 }
local hitSndTbl = {
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_impact_flesh1.mp3",
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_impact_flesh2.mp3",
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_impact_flesh3.mp3",
    "lambdaplayers/weapons/l4d2/melee/shovel/shovel_impact_flesh4.mp3"
}
local random = math.random

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_shovel = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_shovel.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Shovel",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_shovel",
        ismelee = true,
        keepdistance = 40,
        attackrange = 80,
        bonemerge = true,
        islethal = true,

        OnDeploy = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
            wepent.L4D2Data.RateOfFire = rofTbl
            wepent.L4D2Data.Sound = swingSndTbl
            wepent.L4D2Data.HitDelay = 0.25
            wepent.L4D2Data.Range = 87
            wepent.L4D2Data.Damage = dmgTbl
            wepent.L4D2Data.DamageType = DMG_CLUB
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