local random = math.random

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_cricket_bat = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_cricket_bat.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Cricket Bat",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_cricket_bat",
        ismelee = true,
        keepdistance = 10,
        attackrange = 80,
        bonemerge = true,
        islethal = true,

        OnEquip = function( self, wepent )
            wepent.L4D2Data = {}
            wepent.L4D2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
            wepent.L4D2Data.RateOfFire = { 0.8, 0.9 }
            wepent.L4D2Data.Sound = {
                "lambdaplayers/weapons/l4d2/melee/bat/bat_swing_miss1.mp3",
                "lambdaplayers/weapons/l4d2/melee/bat/bat_swing_miss2.mp3"
            }
            wepent.L4D2Data.HitDelay = 0.275
            wepent.L4D2Data.Range = 65
            wepent.L4D2Data.Damage = { 40, 50 }
            wepent.L4D2Data.DamageType = DMG_CLUB
            wepent.L4D2Data.HitSound = {
                "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_01.mp3",
                "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_02.mp3",
                "lambdaplayers/weapons/l4d2/melee/bat/melee_cricket_bat_03.mp3"
            }

            if random( 1, 5 ) == 1 then wepent:SetSkin( 1 ) end
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/melee_deploy_1.mp3", 60, 100, 1, CHAN_ITEM )
        end,

        callback = function( self, wepent, target )
            LAMBDA_L4D2:SwingMeleeWeapon( self, wepent, target )
            return true
        end
    }
})