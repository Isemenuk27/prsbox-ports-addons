$modelname "weapons/c_zaza.mdl"
$include c_arms_definebones.qci

$cdmaterials "models\props_prsbox\"

$attachment "muzzle" "zaza" -0.00 0.00 0.00 rotate 0 -90 0

$body wep zaza_small.smd

$sequence "draw" {
	"anims/draw.smd"
	activity "ACT_VM_DEPLOY" 1
	fps 30
}

$sequence "idle" {
	"anims/idle.smd"
	activity "ACT_VM_IDLE" 1
	fps 30
}
