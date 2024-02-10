local IsValid = IsValid
local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local DamageInfo = DamageInfo
local CreateSound = CreateSound
local trLine = util.TraceLine
local trHull = util.TraceHull
local trTbl = { mask = MASK_SHOT_HULL, mins = Vector( -4, -4, -2 ), maxs = Vector( 4, 4, 2 ) }

local function KillSounds( self )
    self:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_die_01.mp3", 70 )
    self:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_01.mp3" )
    self:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_02.mp3" )

    if self.IdleSound then self.IdleSound:Stop(); self.IdleSound = nil end
    if self.AttackSound then self.AttackSound:Stop(); self.AttackSound = nil end 
end

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    l4d2_melee_chainsaw = {
        model = "models/lambdaplayers/weapons/l4d2/melee/w_chainsaw.mdl",
        origin = "Left 4 Dead 2",
        prettyname = "Chainsaw",
        holdtype = "physgun",
        killicon = "lambdaplayers/killicons/icon_l4d2_melee_chainsaw",
        ismelee = true,
        keepdistance = 30,
        attackrange = 70,
        bonemerge = true,
        islethal = true,

        OnDeploy = function( self, wepent )
            self.l_WeaponUseCooldown = CurTime() + 2.5
            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_0" .. random( 1, 2 ) .. ".mp3", 80, nil, 0.66 )

            local layerID = self:AddGestureSequence( self:LookupSequence( "reload_revolver_base_layer" ), true )
            self:SetLayerCycle( layerID, 0.25 ); self:SetLayerBlendOut( layerID, 0.25 )

            wepent.IsDeploying = true
            wepent.AttackTime = CurTime() + 2.5

            wepent.IdleSound = CreateSound( wepent, "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_idle_lp_01.wav" )
            wepent.AttackSound = CreateSound( wepent, "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_high_speed_lp_01.wav" )

            if random( 1, 3 ) == 1 then 
                local skinCount = wepent:SkinCount()
                if skinCount > 0 then wepent:SetSkin( random( 0, skinCount - 1 ) ) end
            end

            wepent:CallOnRemove( "LambdaChainsaw_KillSounds" .. wepent:EntIndex(), KillSounds )
        end,

        OnThink = function( self, wepent, isdead )
            if isdead then
                if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end 
            else
                if CurTime() > wepent.AttackTime then
                    wepent.IsDeploying = false
                    if wepent.IdleSound and !wepent.IdleSound:IsPlaying() then wepent.IdleSound:PlayEx( 0.5, 100 ) end
                    if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end
                end

                if !wepent.IsDeploying then
                    if !self:IsPlayingGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 ) then
                        local shakeLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true )
                        self:SetLayerPlaybackRate( shakeLayer, 2.0 ); self:SetLayerBlendOut( shakeLayer, 2.0 )
                    end

                    if CurTime() <= wepent.AttackTime then 
                        if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                        if wepent.AttackSound and !wepent.AttackSound:IsPlaying() then wepent.AttackSound:Play() end

                        local attackLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM, true )
                        self:SetLayerCycle( attackLayer, 0.2 ) self:SetLayerBlendOut( attackLayer, 1.25 )

                        local fireSrc = self:GetAttachmentPoint( "eyes" ).Pos
                        local enemy = self:GetEnemy()
                        local fireDir = ( LambdaIsValid( enemy ) and ( enemy:WorldSpaceCenter() - fireSrc ):Angle() or self:GetAngles() )

                        trTbl.start = fireSrc
                        trTbl.endpos = ( fireSrc + fireDir:Forward() * 56 )
                        trTbl.filter = { self, wepent }
                        local tr = trLine( trTbl )
                        if !LambdaIsValid( tr.Entity ) then tr = trHull( trTbl ) end

                        local hitEnt = tr.Entity
                        if tr.Hit and IsValid( hitEnt ) then
                            local dmginfo = DamageInfo()
                            dmginfo:SetDamage( 2 )
                            dmginfo:SetDamageType( DMG_SLASH )
                            dmginfo:SetDamagePosition( tr.HitPos )
                            dmginfo:SetDamageForce( fireDir:Forward() * 2000 - fireDir:Up() * 2000)
                            dmginfo:SetInflictor( wepent )
                            dmginfo:SetAttacker( self )
                            hitEnt:DispatchTraceAttack( dmginfo, tr )
                        end
                    end
                end
            end
        end,

        OnTakeDamage = function( self, wepent, dmginfo ) 
            dmginfo:ScaleDamage( ( CurTime() <= wepent.AttackTime ) and 0.5 or 0.8 ) 
        end,
        
        OnAttack = function( self, wepent, target ) 
            if !wepent.IsDeploying then wepent.AttackTime = CurTime() + Rand( 0.33, 0.66 )  end
            return true 
        end,

        OnHolster = function( self, wepent )
            wepent.IsDeploying = nil
            wepent.AttackTime = nil

            wepent:EmitSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_die_01.mp3", 70 )
            wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_01.mp3" )
            wepent:StopSound( "lambdaplayers/weapons/l4d2/melee/chainsaw/chainsaw_start_02.mp3" )

            if wepent.IdleSound then wepent.IdleSound:Stop(); wepent.IdleSound = nil end
            if wepent.AttackSound then wepent.AttackSound:Stop(); wepent.AttackSound = nil end 
        end
    }
} )