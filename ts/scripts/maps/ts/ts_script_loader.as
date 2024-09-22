//////////////////////////////////////////////////////
// File         : ts_script_loader.as               //
// Author       : Knee                              //
// Description  : Loads all the ts related scripts  //
//////////////////////////////////////////////////////

#include "weapon_kungfu"
#include "weapon_ts_katana"
#include "weapon_ts_seal_knife"
#include "weapon_ts_combat_knife"

#include "weapon_ts_glock18"

#include "weapon_ts_tmp"

void TS_LoadWeapons()
{
    RegisterKungFu();
    
    TS_Katana::Register_Weapon();
    TS_SealKnife::Register_Weapon();
    TS_CombatKnife::Register_Weapon();
    
    TS_Glock18::Register_Weapon();
    
    TS_TMP::Register_Weapon();
}