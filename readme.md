# Sven Co-Op Specialists

***

This project is eventually going to become full of The Specialists Mod 3.0 assets.
Hopefully their functionality is also implemented as well.

# Table of Contents
1. [Progress Legend](#progresslegend)
2. [Weapon list](#weaponlist)
3. [Weapon Features](#weaponfeatures)
4. [Entity list](#entitylist)
5. [Miscellaneous entity list](#miscellaneousentitylist)
6. [Quick useful links](#quickusefullinks)

#### Current problems
- Crosshair sprite is missing and or incomplete
- Don't know how to move the player's view to simulate recoil
  all I know how to do currently is use punchangle, but the player's view will return to the center of the screen which is not the desired behavior
- Making proper use of the melee weapons' block function, deflect bullets? Is that even possible?
- Need to add a "useitems" command to toggle laser sight and flashlight
- Need to figure out how to add weapon attachments

<a name="progresslegend"></a>
## 1. Progress Legend
| Item                  | Description                                                   |
| --------------------- | ------------------------------------------------------------- |
| Not started           | Expected to be done but I have not started progress yet       |
| Started               | Progress has been started but is not complete or functional   |
| Functionally complete | Item is nearly complete but has bugs needing to be worked out |
| Complete              | Item is complete as expected and no more work to be done      |
| Not doing             | Item will not be implemented                                  |

<a name="weaponlist"></a>
## 2. Weapon list:
| \# | Entity Name                      | Progress              | To do notes                       |
| -- | -------------------------------- | --------------------- | --------------------------------- |
| 1  | weapon_ts_kungfu                 | Functionally complete | Refactor this mess of code        |
| 2  | weapon_ts_katana                 | Functionally complete | Add throwable blades              |
| 3  | weapon_ts_seal_knife             | Functionally complete | Add throwable blades              |
| 4  | weapon_ts_combat_knife           | Functionally complete | Add throwable blades              |
| 5  | weapon_ts_glock18                | Functionally complete | Add suppressor, laser, flashlight |
| 6  | weapon_ts_glock22                | Functionally complete | Add suppressor, laser, flashlight |
| 7  | weapon_ts_fiveseven              | Functionally complete | Add suppressor, laser, flashlight |
| 8  | weapon_ts_fiveseven_akimbo       | Not started           | To do                             |
| 9  | weapon_ts_beretta                | Functionally complete | Add suppressor, laser, flashlight |
| 10 | weapon_ts_beretta_akimbo         | Not started           | To do                             |
| 11 | weapon_ts_socom                  | Functionally complete | Add suppressor, laser, flashlight |
| 12 | weapon_ts_socom_akimbo           | Not started           | To do                             |
| 13 | weapon_ts_ruger                  | Functionally complete | Add laser, flashlight             |
| 14 | weapon_ts_deagle                 | Functionally complete | Add suppressor, laser, flashlight |
| 15 | weapon_ts_raging_bull            | Functionally complete | Add laser                         |
| 16 | weapon_ts_contender              | Functionally complete | Add laser, scope                  |
| 17 | weapon_ts_gold_colts             | Complete              | Done                              |
| 18 | weapon_ts_mp5sd                  | Functionally complete | Add laser, scope                  |
| 19 | weapon_ts_mp5k                   | Functionally complete | Add suppressor, laser, flashlight |
| 20 | weapon_ts_ump45                  | Functionally complete | Add suppressor, laser, flashlight |
| 21 | weapon_ts_mp7                    | Functionally complete | Add suppressor, laser, flashlight |
| 22 | weapon_ts_tmp                    | Functionally complete | Figure out ammo types             |
| 23 | weapon_ts_mac10                  | Not started           | Can't find files, might not do    |
| 24 | weapon_ts_skorpion               | Complete              | Done                              |
| 25 | weapon_ts_skorpion_akimbo        | Not started           | To do                             |
| 26 | weapon_ts_benelli                | Functionally complete | Add laser, flashlight             |
| 27 | weapon_ts_spas                   | Functionally complete | Add laser, flashlight             |
| 28 | weapon_ts_mossberg               | Functionally complete | Add laser, flashlight             |
| 29 | weapon_ts_usas12                 | Not started           | To do                             |
| 30 | weapon_ts_double_barrel_shotgun  | Not started           | To do                             |
| 31 | weapon_ts_ak47                   | Not started           | To do                             |
| 32 | weapon_ts_m4a1                   | Not started           | To do                             |
| 33 | weapon_ts_m16                    | Not started           | To do                             |
| 34 | weapon_ts_aug                    | Not started           | To do                             |
| 35 | weapon_ts_barrett                | Not started           | To do                             |
| 36 | weapon_ts_m60                    | Not started           | To do                             |
| 37 | weapon_ts_grenade                | Not started           | To do                             |

<a name="weaponfeatures"></a>
## 3. Weapon features:
| \# | Item Description                 | Progress              | To do notes                   |
| -- | -------------------------------- | --------------------- | ----------------------------- |
| 1  | Lasersight attachments           | Not started           | To do: might be tricky        |
| 2  | Silencers                        | Not started           | To do: should be easy         |
| 3  | Flashlight attachments           | Not started           | To do: should be easy         |
| 4  | Scoped attachments               | Not started           | To do: should be easy         |
| 5  | Weapon firemodes                 | Not started           | To do: should be easy         |
| 6  | Akimbo alternating fire          | Not started           | To do: should be easy         |

<a name="entitylist"></a>
## 4. Entity list:
| \# | Entity Name                      | To do | Progress                                                      |
| -- | -------------------------------- | ----- | ------------------------------------------------------------- |
| 1  | ts_bomb                          | No    | Not doing, no plans of implementation                         |
| 2  | ts_briefcase                     | No    | Not doing, no plans of implementation                         |
| 3  | ts_dmhill                        | No    | Not doing                                                     |
| 4  | ts_emitter                       | No    | Not doing unless I really need it                             |
| 5  | ts_fog                           | No    | Not doing since there's already fog entities                  |
| 6  | ts_groundweapon                  | No    | Not doing, but might consider                                 |
| 7  | ts_groundammo                    | Yes   | Not started                                                   |
| 8  | ts_hack                          | No    | Not doing                                                     |
| 9  | ts_mapgoals                      | No    | Not doing                                                     |
| 10 | ts_model                         | Yes   | Not started                                                   |
| 11 | ts_objective_manager             | No    | Not doing                                                     |
| 12 | ts_objective_ptr                 | No    | Not doing                                                     |
| 13 | ts_particle                      | Yes   | Not started                                                   |
| 14 | ts_playeramount                  | No    | Not doing                                                     |
| 15 | ts_powerup                       | No    | Not doing, but might consider                                 |
| 16 | ts_scoregiver                    | No    | Not doing                                                     |
| 17 | ts_sellzone                      | No    | Not doing, was never finished anyway                          |
| 18 | ts_slowmotion                    | No    | Not doing unless I can conceptualize how to implement this    |
| 19 | ts_teamescape                    | No    | Not doing                                                     |
| 20 | ts_timer                         | No    | Not doing unless I really need it                             |
| 21 | ts_trigger                       | No    | Not doing                                                     |
| 22 | ts_wind                          | No    | Not doing until I learn more about what this does             |
| 23 | ts_wingiver                      | No    | Not doing                                                     |
| 24 | tsattackerteamlist               | No    | Not doing                                                     |
| 25 | tsobjective                      | No    | Not doing, was never implemented anyway                       |
| 26 | tsweaponlist                     | No    | Not doing                                                     |
| 27 | tswinnerteamlist                 | No    | Not doing                                                     |

<a name="miscellaneousentitylist"></a>
## 5. Miscellaneous entity list:
| \# | Entity Name                      | To do | Progress                                                      |
| -- | -------------------------------- | ----- | ------------- |
| 1  | entity_ts_blood_particle         | Yes   | Not started   |

<a name="quickusefullinks"></a>
## 6. Quick useful links:
- To help with understanding of the underlying implementation of most things are
    - https://github.com/ValveSoftware/halflife/blob/master/dlls/
- Helpful existing sample scripts
    - https://github.com/KernCore91/-SC-Counter-Strike-1.6-Weapons-Project
    - https://github.com/baso88/SC_AngelScript/blob/SC_AngelScript/samples/scripts/maps
    - https://github.com/DrAbcOfficial/AngelScripts
- Sven Coop Angelscript API
    - https://github.com/baso88/SC_AngelScript/wiki/Script-Fundamentals
    - Ammo types: https://github.com/baso88/SC_AngelScript/wiki/Default-Ammo-Types
