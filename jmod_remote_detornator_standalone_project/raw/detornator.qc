$modelname "weapons/w_remotedetonator.mdl"

$bodygroup "Body" {
	studio "detonator.smd"
}

$surfaceprop "weapon"
$contents "solid"

$illumposition 0 0 0

$cdmaterials "models/Weapons/V_slam/"

$sequence "idle" "detonator.smd" fps 30

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0.000000 0.000000 0.000000 -0.000000 0.000000 0.000000
$bonemerge "ValveBiped.Bip01_R_Hand"

$collisionmodel "phys_detonator.smd" {
	$mass 4
}
