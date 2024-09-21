//////////////////////////////////////////////////////
// File         : ts_script_loader.as               //
// Author       : Knee                              //
// Description  : Loads all the ts related scripts  //
//////////////////////////////////////////////////////

#include "ts/weapon_kungfu"
#include "ts/weapon_ts_katana"
#include "ts/weapon_ts_seal_knife"
#include "ts/weapon_ts_combat_knife"

void TS_LoadWeapons()
{
    RegisterKungFu();
    TS_Katana::Register_TS_Katana();
    TS_SealKnife::Register_TS_SealKnife();
    TS_CombatKnife::Register_TS_CombatKnife();
}