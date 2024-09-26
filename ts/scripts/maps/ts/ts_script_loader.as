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
#include "weapon_ts_glock22"
#include "weapon_ts_fiveseven"
#include "weapon_ts_beretta"
#include "weapon_ts_socom"
#include "weapon_ts_ruger"
#include "weapon_ts_deagle"
#include "weapon_ts_raging_bull"

#include "weapon_ts_tmp"

void TS_LoadWeapons()
{
    RegisterKungFu();
    
    TS_Katana       ::Register_Weapon();
    TS_SealKnife    ::Register_Weapon();
    TS_CombatKnife  ::Register_Weapon();
    
    TS_Glock18      ::Register_Weapon();
    TS_Glock22      ::Register_Weapon();
    TS_Fiveseven    ::Register_Weapon();
    TS_Beretta      ::Register_Weapon();
    TS_Socom        ::Register_Weapon();
    TS_Ruger        ::Register_Weapon();
    TS_Deagle       ::Register_Weapon();
    TS_RagingBull   ::Register_Weapon();
    
    TS_TMP          ::Register_Weapon();
}