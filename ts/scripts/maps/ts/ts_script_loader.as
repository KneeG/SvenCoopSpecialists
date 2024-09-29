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
#include "weapon_ts_contender"
#include "weapon_ts_gold_colts"

#include "weapon_ts_tmp"
#include "weapon_ts_mp5sd"
#include "weapon_ts_mp5k"
#include "weapon_ts_ump45"
#include "weapon_ts_mp7"
#include "weapon_ts_skorpion"

#include "weapon_ts_benelli"
#include "weapon_ts_spas"
#include "weapon_ts_mossberg"
#include "weapon_ts_usas12"

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
    TS_Contender    ::Register_Weapon();
    TS_GoldColts    ::Register_Weapon();
    
    TS_TMP          ::Register_Weapon();
    TS_MP5SD        ::Register_Weapon();
    TS_MP5K         ::Register_Weapon();
    TS_UMP45        ::Register_Weapon();
    TS_MP7          ::Register_Weapon();
    TS_Skorpion     ::Register_Weapon();
    
    TS_Benelli      ::Register_Weapon();
    TS_Spas         ::Register_Weapon();
    TS_Mossberg     ::Register_Weapon();
    TS_USAS12       ::Register_Weapon();

}