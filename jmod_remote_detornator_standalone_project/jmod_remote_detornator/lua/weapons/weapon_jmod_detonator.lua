AddCSLuaFile()

SWEP.PrintName = "Remote Detonator"
SWEP.Author = "Isemenuk27"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModelFlip = true

SWEP.ViewModel = Model( "models/weapons/c_slam.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_remotedetonator.mdl" )
SWEP.ViewModelFOV = 45

SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.DrawAnim	=	"detonator_draw"
SWEP.IdleAnim	=	"detonator_idle"
SWEP.FireAnim	=	"detonator_detonate"

if ( SERVER ) then
	hook.Add("JMod_PostLuaConfigLoad","DETONATOR.MergeCFG",function( CFG )
	CFG.Craftables["Remote Detonator"] = {
		results="weapon_jmod_detonator",
		craftingReqs={
			[JMod.EZ_RESOURCE_TYPES.BASICPARTS] = 7,
			[JMod.EZ_RESOURCE_TYPES.PLASTIC] = 7
		},
		category = "Tools",
		craftingType = "workbench",
		description = "Blow them up."
	}
	end )
end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 0, "Mode" )
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )
end

SWEP.Switch = {
	[0] = function(ply) JMod.EZ_Remote_Trigger(ply) end,
	[1] = function(ply) JMod.EZ_BombDrop(ply) end,
	[2] = function(ply) JMod.EZ_WeaponLaunch(ply) end
}

SWEP.Modes = {
	[0] = "*trigger*",
	[1] = "*bomb*",
	[2] = "*launch*"
}

function SWEP:PrimaryAttack( right )
	if !self.Owner:KeyPressed(IN_ATTACK) then return end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( self.FireAnim ) )

	self:EmitSound( "weapons/slam/mine_mode.wav" )

	self:UpdateNextIdle()

	if SERVER then
		local f = self.Switch[self:GetMode()]
		if f then f(self.Owner) end
	end

	self:SetNextPrimaryFire( CurTime() + 0.2 )
end

function SWEP:SecondaryAttack()
	if !self.Owner:KeyPressed(IN_ATTACK2) then return end
	self:SetNextSecondaryFire( CurTime() + 0.1 )
	self:EmitSound("Weapon_AR2.Empty")
	if CLIENT then return end
	local len = #self.Modes + 1
	self:SetMode( (self:GetMode() + 1)%len )
end

function SWEP:OnDrop()

	self:Remove()

end

function SWEP:Deploy()
	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( self.DrawAnim ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	return true
end

local c1 = Color(255, 255, 255, 50)

local l1x = 0.83
local l2x = 0.85
local l3x = 0.87

function SWEP:DrawHUD()
	local CM = self:GetMode()
	local len = #self.Modes + 1
	local t = FrameTime() * 0.01

	local n1 = (CM - 1)%len
	local n2 = CM
	local n3 = (CM + 1)%len

	draw.DrawText( self.Modes[n1], "DefaultFixed", ScrW() * 0.5, ScrH() * l1x, c1, TEXT_ALIGN_CENTER )
	draw.DrawText( self.Modes[n2], "TargetID", ScrW() * 0.5, ScrH() * l2x, color_white, TEXT_ALIGN_CENTER )
	draw.DrawText( self.Modes[n3], "DefaultFixed", ScrW() * 0.5, ScrH() * l3x, c1, TEXT_ALIGN_CENTER )
end

function SWEP:Holster() return true end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( self.IdleAnim ) )

		self:UpdateNextIdle()

	end
end
