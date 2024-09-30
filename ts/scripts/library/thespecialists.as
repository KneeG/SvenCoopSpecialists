//////////////////////////////////////////////////////////////////////////////////
// File         : thespecialists.as                                             //
// Author       : Knee                                                          //
// Description  : Contains common definitions used by The Specialists weapons   //
//////////////////////////////////////////////////////////////////////////////////

/*

    Useful information:
    
        g_itemRegistry is NOT documented AT ALL in the Sven Coop AngelScript API documentation.
        It's been absolutely infuriating trying to figure this stuff out from scratch, and I don't know how all this stuff isn't in the official documentation,
        or how anyone else has been able to figure this out.
        
        Here is the RegisterWeapon function signature that I got from Kern's CS 1.6 weapon conversion project
            g_ItemRegistry.RegisterWeapon
            (
                strWeaponName   , Name of the weapon that will be referred to by the engine
                strSpriteDir    , Folder where the sprite files will be kept
                strAmmoType1    , Name of the primary ammo entity
                strAmmoType2    , Name of the secondary ammo entity
                strAmmoName     , Not sure what this is
                strAmmoEntity2    Not sure what this is
            );
            
        Example item register call:
            g_ItemRegistry.RegisterWeapon(strCLASSNAME, "ts/weapon_metadata/");
    
        Sprite text files:
        
            From what I've observed, these are the format of sprite text files
            
            Row 1 = Header row, the number here indicates how many rows of data follow after this one
            
            +-------+-----------+---------------+-------------------+-----------+-----------+-----------+-----------+
            | Row # | Text      | Display mask  | Sprite path       | x start   | y start   | width     | height    |
            +-------+-----------+---------------+-------------------+-----------+-----------+-----------+-----------+
            |   2   | weapon    |  640          | ts/combat_knife   | 0         | 0         | 128       | 48        | The image shown when the weapon is displayed on your weapon selection hud
            |   3   | weapon_s  |  640          | ts/combat_knife   | 0         | 0         | 128       | 48        | The image shown when the weapon is selected on your weapon selection hud
            |   4   | ammo      |  640          | ts/combat_knife   | 0         | 0         | 128       | 48        | The image shown on your ammo hud
            |   5   | crosshair |  640          | crosshairs        | 0         | 0         | 128       | 48        | The image shown on your reticule
            |   6   | autoaim   |  640          | crosshairs        | 0         | 72        | 24        | 24        | The image shown while the autoaim function is in action
            |   7   | zoom      |  640          | crosshairs        | 0         | 0         | 1         | 1         | The image shown while zooming
            +-------+-----------+---------------+-------------------+-----------+-----------+-----------+-----------+

*/

namespace TheSpecialists
{
    ///////////////////////////////
    // Asset paths
    const string strMODEL_PATH                  = "models/ts/"                                  ;
    const string strSOUND_PATH                  = "ts/"                                         ; // "sound" is assumed to be the base directory for sound functions
    
    // Sprites
    const string strSPRITE_ROOT                 = "sprites/"                                    ;
    const string strSPRITE_TS_PATH              = "ts/"                                         ; // "sprites" is assumed to be the base directory for sprite files
    const string strSPRITE_WEAPON_METADATA      = "weapon_metadata/"                            ; // Location of the .txt files
    const string strSPRITE_METADATA_PATH        = strSPRITE_TS_PATH + strSPRITE_WEAPON_METADATA ; // Path of the sprite weapons metadata
    
    // Weapon paths
    const string strMODEL_PATH_MELEE            = "melee/"                                      ;
    const string strMODEL_PATH_PISTOL           = "pistols/"                                    ;
    const string strMODEL_PATH_SMG              = "smgs/"                                       ;
    const string strMODEL_PATH_RIFLE            = "rifles/"                                     ;
    const string strMODEL_PATH_HEAVY            = "heavy/"                                      ;
    const string strMODEL_PATH_ORDINANCE        = "ordinance/"                                  ;
    
    // Pistol asset paths
    const string strPISTOL__SOUND__CLIPIN       = "clipin.wav"                                  ; // Name of the magazine insert file
    const string strPISTOL__SOUND__CLIPOUT      = "clipout.wav"                                 ; // Name of the magazine eject file
    const string strPISTOL__SOUND__FIRE         = "fire.wav"                                    ; // Name of the gun fire file
    const string strPISTOL__SOUND__FIRE_SILENCED= "fire_silenced.wav"                           ; // Name of the gun fire silenced  file
    const string strPISTOL__SOUND__SLIDEBACK    = "slideback.wav"                               ; // Name of the slide pull file
    const string strPISTOL__SOUND__EMPTY        = "pistol_empty.wav"                            ; // Name of the dry fire pistol sound

    // Submachine gun asset paths
    const string strSMG__SOUND__CLIPIN          = "clipin.wav"                                  ; // Name of the magazine insert file
    const string strSMG__SOUND__CLIPOUT         = "clipout.wav"                                 ; // Name of the magazine eject file
    const string strSMG__SOUND__FIRE            = "fire.wav"                                    ; // Name of the gun fire file
    const string strSMG__SOUND__FIRE_SILENCED   = "fire_silenced.wav"                           ; // Name of the gun fire silenced  file
    const string strSMG__SOUND__SLIDEBACK       = "slideback.wav"                               ; // Name of the slide pull file
    const string strSMG__SOUND__EMPTY           = "pistol_empty.wav"                            ; // Name of the dry fire pistol sound
    const string strSMG__SOUND__BOLTPULL        = "boltpull.wav"                                ; // Name of the bolt pull sound
    const string strSMG__SOUND__BOLTSLAP        = "boltslap.wav"                                ; // Name of the bolt slap sound
    const string strSMG__SOUND__CLIPSLAP        = "clipslap.wav"                                ; // Name of the magazine slap sound
    
    // Shotgun asset paths
    const string strSHOTGUN__SOUND__FIRE        = "fire.wav"                                    ; // Name of the gun fire file
    const string strSHOTGUN__SOUND__PUMP        = "pump.wav"                                    ; // Name of the pump sound file
    const string strSHOTGUN__SOUND__CLIPIN      = "clipin.wav"                                  ; // Name of the magazine insert file
    const string strSHOTGUN__SOUND__CLIPOUT     = "clipout.wav"                                 ; // Name of the magazine eject file
    const string strSHOTGUN__SOUND__SLIDEBACK   = "slideback.wav"                               ; // Name of the slide pull file
    
    // Double barreled shotgun (sawed off) asset paths
    const string strSHOTGUN__SOUND__FIRE2       = "fire2.wav"                                   ; // Name of the second barrel firing noise (sawed off)
    const string strSHOTGUN__SOUND__CLOSE       = "close.wav"                                   ; // Name of the chamber close file
    const string strSHOTGUN__SOUND__OPEN        = "close.wav"                                   ; // Name of the chamber open file
    const string strSHOTGUN__SOUND__INSERT_SHELL= "insert-shell.wav"                            ; // Name of the chambering shell file
    const string strSHOTGUN__SOUND__SHELL_DROP  = "shelldrop.wav"                               ; // Name of the shell drop file
    const string strSHOTGUN__SOUND__SHELL_OUT   = "shellout.wav"                                ; // Name of the unchambered shell file
    const string strSHOTGUN__SOUND__TAPSPAN     = "tapspan.wav"                                 ; // Name of the chamber unlock file
    
    // Rifle asset paths
    const string strRIFLE__SOUND__CLIPIN        = "clipin.wav"                                  ; // Name of the magazine insert file
    const string strRIFLE__SOUND__CLIPOUT       = "clipout.wav"                                 ; // Name of the magazine eject file
    const string strRIFLE__SOUND__BOLTPULL      = "boltpull.wav"                                ; // Name of the bolt pull sound
    const string strRIFLE__SOUND__BOLTSLAP      = "boltslap.wav"                                ; // Name of the bolt slap sound
    const string strRIFLE__SOUND__FIRE          = "fire.wav"                                    ; // Name of the gun fire file
    const string strRIFLE__SOUND__FIRE_SILENCED = "fire_silenced.wav"                           ; // Name of the gun fire silenced  file
    const string strRIFLE__SOUND__SLIDEBACK     = "slideback.wav"                               ; // Name of the slide pull file
    
    const int iSPRITE__WEAPONS__WIDTH           = 128                                           ; // [pixels] Width of the weapon sprites
    const int iSPRITE__WEAPONS__HEIGHT          = 48                                            ; // [pixels] Height of the weapon sprites
    
    ///////////////////////////////
    // Weapon slot definitions
    const int iWEAPON__SLOT__MELEE              = 0                                             ; // Melee weapons such as kungfu and blades
    const int iWEAPON__SLOT__PISTOL             = 1                                             ; // Pistols
    const int iWEAPON__SLOT__SMG                = 2                                             ; // Sub machine guns
    const int iWEAPON__SLOT__RIFLE              = 3                                             ; // Usually butted weapons, such as rifles and shotguns
    const int iWEAPON__SLOT__HEAVY              = 4                                             ; // Heavy weapons like machine guns and snipers
    const int iWEAPON__SLOT__ORDINANCE          = 5                                             ; // Grenades
    
    ///////////////////////////////
    // Weapon position definitions
    // Starting at a number above 0 since there are other default half-life weapons at those positions
    
    // Melee weapons
    const int iWEAPON__POSITION__KUNGFU             = 5 ;
    const int iWEAPON__POSITION__SEAL_KNIFE         = 6 ;
    const int iWEAPON__POSITION__COMBAT_KNIFE       = 7 ;
    const int iWEAPON__POSITION__KATANA             = 8 ;
    
    // Pistols
    const int iWEAPON__POSITION__GLOCK18            = 5 ;
    const int iWEAPON__POSITION__GLOCK22            = 6 ;
    const int iWEAPON__POSITION__FIVESEVEN          = 7 ;
    const int iWEAPON__POSITION__BERETTA            = 8 ;
    const int iWEAPON__POSITION__SOCOM              = 9 ;
    const int iWEAPON__POSITION__RUGER              = 10;
    const int iWEAPON__POSITION__DEAGLE             = 11;
    const int iWEAPON__POSITION__RAGING_BULL        = 12;
    const int iWEAPON__POSITION__CONTENDER          = 13;
    const int iWEAPON__POSITION__GOLD_COLTS         = 14;
    const int iWEAPON__POSITION__AKIMBO_FIVESEVEN   = 15;
    const int iWEAPON__POSITION__AKIMBO_BERETTA     = 16;
    const int iWEAPON__POSITION__AKIMBO_SOCOM       = 17;
    
    // Submachine guns
    const int iWEAPON__POSITION__TMP                = 5 ;
    const int iWEAPON__POSITION__MP5SD              = 6 ;
    const int iWEAPON__POSITION__MP5K               = 7 ;
    const int iWEAPON__POSITION__UMP45              = 8 ;
    const int iWEAPON__POSITION__MP7                = 9 ;
    const int iWEAPON__POSITION__SKORPION           = 10;
    const int iWEAPON__POSITION__SKORPION_AKIMBO    = 11;
    const int iWEAPON__POSITION__UZI                = 12;
    
    // Rifles/Shotguns
    const int iWEAPON__POSITION__BENELLI            = 5 ;
    const int iWEAPON__POSITION__SPAS               = 6 ;
    const int iWEAPON__POSITION__MOSSBERG           = 7 ;
    const int iWEAPON__POSITION__USAS12             = 8 ;
    const int iWEAPON__POSITION__SAWEDOFF           = 9 ;
    const int iWEAPON__POSITION__AK47               = 10;
    const int iWEAPON__POSITION__M4A1               = 11;
    const int iWEAPON__POSITION__M16                = 12;
    const int iWEAPON__POSITION__AUG                = 13;
    
    // Heavy weapons
    const int iWEAPON__POSITION__BARRETT            = 5;
    const int iWEAPON__POSITION__M60                = 6;
    
    // Ordinance
    const int iWEAPON__POSITION__GRENADE            = 5;
    
    ///////////////////////////////
    // Weapon behavior
    
    ///////////////////////////////
    // Fire modes
    namespace FireMode
    {
        const int iSEMI_AUTOMATIC   = 0;
        const int iBURST_FIRE       = 1;
        const int iAUTOMATIC        = 2;
    } // End of namespace FireMode
    
    ///////////////////////////////
    // Zoom types
    namespace ZoomType
    {
        const int iZOOM_NONE        = 0;
        const int iZOOM_2X          = 1;
        const int iZOOM_8X          = 2;
    } // End of namespace ZoomType
    
    const int           iDEFAULT_FIRE_MODE          = FireMode::iSEMI_AUTOMATIC ; // Default fire mode of a weapon
    const int           iDEFAULT_PITCH_VARIATION    = 15                        ; // Default pitch variation
    const float         iDEFAULT_PITCH              = 100                       ; // Default pitch
    const float         fDEFAULT_SOUND_DISTANCE     = 512                       ; // Default limit the sound will be transmitted
    const float         fDEFAULT_VOLUME             = 1.0                       ; // [percent] Default volume (in percentage)
    const SOUND_CHANNEL scDEFAULT_CHANNEL           = CHAN_AUTO                 ; // Default sound channel (See https://github.com/baso88/SC_AngelScript/wiki/SoundSystem)
    const float         fDEFAULT_ATTENUATION        = ATTN_NORM                 ; // Default attenuation, or sound dropoff
    const int           iMONSTER_GUN_VOLUME         = 384                       ; // Default gun fire volume, I can only assume this is distance in its implementation
    const float         fGUN_SOUND_DURATION         = 0.3                       ; // [seconds] How long the gun sound persists (in seconds)
    const float         fSWING_DISTANCE             = 48.0                      ; // Number of units the melee weapon can hit
    const float         fDEFAULT_HOSTER_TIME        = 0.5                       ; // [seconds] Time in seconds it will take for the crowbar to be holstered
    const int           iDEFAULT_WEIGHT             = 1                         ; // Not certain what the weight does for a weapon, but it is defined in other weapon scripts
    const float         fDEFAULT_NEXT_THINK         = 1.0                       ; // [seconds] Time in seconds between weapon think function calls
    const float         fDEFAULT_FIRE_ON_EMPTY_DELAY= 0.25                      ; // [seconds] Time in seconds between trigger pulls while the gun is empty
    const float         fMAXIMUM_FIRE_DISTANCE      = 8192.0                    ; // Maximum distance a bullet will do damage to targets
    const float         fDEFAULT_SHELL_LOAD_TIME    = 0.5                       ; // [seconds] Time it takes to load a shell into a shotgun
    const float         fDEFAULT_SCOPE_DELAY        = 0.2                       ; // [seconds] Cooldown time before zooming or unzooming (this will be used as a secondary attack delay, usually)
    
    // Weapon traceline rules
    // IGNORE_MONSTERS enum     Purpose
    // ---------------------------------
    // dont_ignore_monsters     Don't ignore monsters.
    // ignore_monsters          Ignore monsters.
    // missile                  The traceline bounds are set to mins -15, -15, -15 and maxs 15, 15, 15. Otherwise, the bounds are specified by the traceline operation.
    const IGNORE_MONSTERS eIGNORE_RULE              = dont_ignore_monsters;
    
    // Attack Delay Seconds = (60 seconds / Rounds Per Minute)
    
    // Melee behavior
    // A melee weapon will not have a clip size (might go back on this to implement blocking which uses the reload button)
    const int       iWEAPON__MELEE__MAX_CLIP                = 0                                 ;
    
    const int       iWEAPON__KATANA__AMMO1                  = -1                                ;
    const int       iWEAPON__KATANA__AMMO2                  = 1                                 ;
    const int       iWEAPON__KATANA__DAMAGE                 = 55                                ;
    const float     fWEAPON__KATANA__ATTACK_DELAY           = (60 / 60.0)                       ; // Time in seconds between swings
    
    const int       iWEAPON__SEAL_KNIFE__AMMO1              = -1                                ;
    const int       iWEAPON__SEAL_KNIFE__AMMO2              = 10                                ;
    const int       iWEAPON__SEAL_KNIFE__DAMAGE             = 20                                ;
    const float     fWEAPON__SEAL_KNIFE__ATTACK_DELAY       = (60 / 240.0)                      ; // Time in seconds between swings
    
    const int       iWEAPON__COMBAT_KNIFE__AMMO1            = -1                                ;
    const int       iWEAPON__COMBAT_KNIFE__AMMO2            = 5                                 ;
    const int       iWEAPON__COMBAT_KNIFE__DAMAGE           = 25                                ;
    const float     fWEAPON__COMBAT_KNIFE__ATTACK_DELAY     = (60 / 150.0)                      ; // Time in seconds between swings
    
    // Pistols behavior
    const float     fWEAPON__PISTOL__MAX_INACCURACY         = 10.0                              ;
    const float     fWEAPON__PISTOL__INACCURACY_DELTA       = 1.0                               ;
    const float     fWEAPON__PISTOL__INACCURACY_DECAY       = 0.06                              ;
    
    const int       iWEAPON__GLOCK18__CLIP                  = 18                                ; // Size of the magazine
    const int       iWEAPON__GLOCK18__AMMO1                 = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__GLOCK18__AMMO2                 = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__GLOCK18__SPREAD              = VECTOR_CONE_3DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__GLOCK18__FIRE_MODE             = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__GLOCK18__DAMAGE                = 15                                ; // Weapon damage
    const float     fWEAPON__GLOCK18__ATTACK_DELAY          = (60.0 / 900.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__GLOCK22__CLIP                  = 15                                ; // Size of the magazine
    const int       iWEAPON__GLOCK22__AMMO1                 = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__GLOCK22__AMMO2                 = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__GLOCK22__SPREAD              = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__GLOCK22__FIRE_MODE             = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__GLOCK22__DAMAGE                = 23                                ; // Weapon damage
    const float     fWEAPON__GLOCK22__ATTACK_DELAY          = (60.0 / 500.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__FIVESEVEN__CLIP                = 20                                ; // Size of the magazine
    const int       iWEAPON__FIVESEVEN__AMMO1               = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__FIVESEVEN__AMMO2               = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__FIVESEVEN__SPREAD            = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__FIVESEVEN__FIRE_MODE           = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__FIVESEVEN__DAMAGE              = 18                                ; // Weapon damage
    const float     fWEAPON__FIVESEVEN__ATTACK_DELAY        = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__BERETTA__CLIP                  = 12                                ; // Size of the magazine
    const int       iWEAPON__BERETTA__AMMO1                 = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__BERETTA__AMMO2                 = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__BERETTA__SPREAD              = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__BERETTA__FIRE_MODE             = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__BERETTA__DAMAGE                = 20                                ; // Weapon damage
    const float     fWEAPON__BERETTA__ATTACK_DELAY          = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__SOCOM__CLIP                    = 12                                ; // Size of the magazine
    const int       iWEAPON__SOCOM__AMMO1                   = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__SOCOM__AMMO2                   = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__SOCOM__SPREAD                = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__SOCOM__FIRE_MODE               = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__SOCOM__DAMAGE                  = 20                                ; // Weapon damage
    const float     fWEAPON__SOCOM__ATTACK_DELAY            = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__RUGER__CLIP                    = 17                                ; // Size of the magazine
    const int       iWEAPON__RUGER__AMMO1                   = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__RUGER__AMMO2                   = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__RUGER__SPREAD                = VECTOR_CONE_1DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__RUGER__FIRE_MODE               = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__RUGER__DAMAGE                  = 12                                ; // Weapon damage
    const float     fWEAPON__RUGER__ATTACK_DELAY            = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    const int       iWEAPON__DEAGLE__CLIP                   = 7                                 ; // Size of the magazine
    const int       iWEAPON__DEAGLE__AMMO1                  = iWEAPON__PISTOL_MAGNUM__AMMO1__MAX; // Primary ammo capacity
    const int       iWEAPON__DEAGLE__AMMO2                  = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__DEAGLE__SPREAD               = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__DEAGLE__FIRE_MODE              = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__DEAGLE__DAMAGE                 = 35                                ; // Weapon damage
    const float     fWEAPON__DEAGLE__ATTACK_DELAY           = (60.0 / 500.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__DEAGLE__RECOIL_MULTIPLIER      = 4.0                               ; // Severity of the recoil
    
    const int       iWEAPON__RAGING_BULL__CLIP              = 5                                 ; // Size of the magazine
    const int       iWEAPON__RAGING_BULL__AMMO1             = iWEAPON__PISTOL_MAGNUM__AMMO1__MAX; // Primary ammo capacity
    const int       iWEAPON__RAGING_BULL__AMMO2             = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__RAGING_BULL__SPREAD          = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__RAGING_BULL__FIRE_MODE         = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__RAGING_BULL__DAMAGE            = 45                                ; // Weapon damage
    const float     fWEAPON__RAGING_BULL__ATTACK_DELAY      = (60.0 / 300.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__RAGING_BULL__RECOIL_MULTIPLIER = 6.0                               ; // Severity of the recoil
    
    const int       iWEAPON__CONTENDER__CLIP                = 1                                 ; // Size of the magazine
    const int       iWEAPON__CONTENDER__AMMO1               = iWEAPON__PISTOL_MAGNUM__AMMO1__MAX; // Primary ammo capacity
    const int       iWEAPON__CONTENDER__AMMO2               = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__CONTENDER__SPREAD            = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon // Accuracy of the weapon
    const int       iWEAPON__CONTENDER__FIRE_MODE           = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__CONTENDER__DAMAGE              = 120                               ; // Weapon damage
    const float     fWEAPON__CONTENDER__ATTACK_DELAY        = (60.0 / 60.0)                     ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__CONTENDER__RECOIL_MULTIPLIER   = 10.0                              ; // Severity of the recoil
    
    const int       iWEAPON__GOLD_COLTS__CLIP               = 15                                ; // Size of the magazine
    const int       iWEAPON__GOLD_COLTS__AMMO1              = iWEAPON__PISTOL__AMMO1__MAX       ; // Primary ammo capacity
    const int       iWEAPON__GOLD_COLTS__AMMO2              = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__GOLD_COLTS__SPREAD           = VECTOR_CONE_4DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__GOLD_COLTS__FIRE_MODE          = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__GOLD_COLTS__DAMAGE             = 18                                ; // Weapon damage
    const float     fWEAPON__GOLD_COLTS__ATTACK_DELAY       = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    
    // Submachine guns behavior
    const int       iWEAPON__TMP__CLIP                      = 20                                ; // Size of the magazine
    const int       iWEAPON__TMP__AMMO1                     = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__TMP__AMMO2                     = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__TMP__SPREAD                  = VECTOR_CONE_4DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__TMP__FIRE_MODE                 = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__TMP__DAMAGE                    = 14                                ; // Weapon damage
    const float     fWEAPON__TMP__ATTACK_DELAY              = (60.0 / 1100.0)                   ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__TMP__RECOIL_MULTIPLIER         = 0.5                               ; // Severity of the recoil
    
    const int       iWEAPON__MP5SD__CLIP                    = 30                                ; // Size of the magazine
    const int       iWEAPON__MP5SD__AMMO1                   = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__MP5SD__AMMO2                   = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__MP5SD__SPREAD                = VECTOR_CONE_4DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__MP5SD__FIRE_MODE               = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__MP5SD__DAMAGE                  = 12                                ; // Weapon damage
    const float     fWEAPON__MP5SD__ATTACK_DELAY            = (60.0 / 700.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__MP5SD__RECOIL_MULTIPLIER       = 0.5                               ; // Severity of the recoil
    
    const int       iWEAPON__MP5K__CLIP                     = 32                                ; // Size of the magazine
    const int       iWEAPON__MP5K__AMMO1                    = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__MP5K__AMMO2                    = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__MP5K__SPREAD                 = VECTOR_CONE_4DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__MP5K__FIRE_MODE                = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__MP5K__DAMAGE                   = 10                                ; // Weapon damage
    const float     fWEAPON__MP5K__ATTACK_DELAY             = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__MP5K__RECOIL_MULTIPLIER        = 0.6                               ; // Severity of the recoil
    
    const int       iWEAPON__UMP45__CLIP                    = 25                                ; // Size of the magazine
    const int       iWEAPON__UMP45__AMMO1                   = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__UMP45__AMMO2                   = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__UMP45__SPREAD                = VECTOR_CONE_4DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__UMP45__FIRE_MODE               = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__UMP45__DAMAGE                  = 19                                ; // Weapon damage
    const float     fWEAPON__UMP45__ATTACK_DELAY            = (60.0 / 600.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__UMP45__RECOIL_MULTIPLIER       = 0.7                               ; // Severity of the recoil
    
    const int       iWEAPON__MP7__CLIP                      = 40                                ; // Size of the magazine
    const int       iWEAPON__MP7__AMMO1                     = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__MP7__AMMO2                     = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__MP7__SPREAD                  = VECTOR_CONE_6DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__MP7__FIRE_MODE                 = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__MP7__DAMAGE                    = 11                                ; // Weapon damage
    const float     fWEAPON__MP7__ATTACK_DELAY              = (60.0 / 800.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__MP7__RECOIL_MULTIPLIER         = 0.6                               ; // Severity of the recoil
    
    const int       iWEAPON__SKORPION__CLIP                 = 20                                ; // Size of the magazine
    const int       iWEAPON__SKORPION__AMMO1                = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__SKORPION__AMMO2                = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__SKORPION__SPREAD             = VECTOR_CONE_6DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__SKORPION__FIRE_MODE            = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__SKORPION__DAMAGE               = 19                                ; // Weapon damage
    const float     fWEAPON__SKORPION__ATTACK_DELAY         = (60.0 / 700.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__SKORPION__RECOIL_MULTIPLIER    = 0.6                               ; // Severity of the recoil
    
    const int       iWEAPON__UZI__CLIP                      = 32                                ; // Size of the magazine
    const int       iWEAPON__UZI__AMMO1                     = iWEAPON__SMG__AMMO1__MAX          ; // Primary ammo capacity
    const int       iWEAPON__UZI__AMMO2                     = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__UZI__SPREAD                  = VECTOR_CONE_6DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__UZI__FIRE_MODE                 = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__UZI__DAMAGE                    = 12                                ; // Weapon damage
    const float     fWEAPON__UZI__ATTACK_DELAY              = (60.0 / 850.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__UZI__RECOIL_MULTIPLIER         = 0.7                               ; // Severity of the recoil
    
    const int       iWEAPON__BENELLI__CLIP                  = 8                                 ; // Size of the magazine
    const int       iWEAPON__BENELLI__AMMO1                 = iWEAPON__SHOTGUN__AMMO1__MAX      ; // Primary ammo capacity
    const int       iWEAPON__BENELLI__AMMO2                 = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__BENELLI__SPREAD              = VECTOR_CONE_6DEGREES * 1          ; // Accuracy of the weapon
    const int       iWEAPON__BENELLI__FIRE_MODE             = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__BENELLI__DAMAGE                = 7                                 ; // Weapon damage
    const float     fWEAPON__BENELLI__ATTACK_DELAY          = (60.0 / 300.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__BENELLI__RECOIL_MULTIPLIER     = 0.6                               ; // Severity of the recoil
    const float     fWEAPON__BENELLI__PUMP_DELAY            = 0.5                               ; // Time in between pumps
    const float     fWEAPON__BENELLI__PUMP_TIME             = 0.5                               ; // Time it takes to pump
    
    const int       iWEAPON__SPAS__CLIP                     = 8                                 ; // Size of the magazine
    const int       iWEAPON__SPAS__AMMO1                    = iWEAPON__SHOTGUN__AMMO1__MAX      ; // Primary ammo capacity
    const int       iWEAPON__SPAS__AMMO2                    = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__SPAS__SPREAD                 = VECTOR_CONE_6DEGREES * 2          ; // Accuracy of the weapon
    const int       iWEAPON__SPAS__FIRE_MODE                = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__SPAS__DAMAGE                   = 9                                 ; // Weapon damage
    const float     fWEAPON__SPAS__ATTACK_DELAY             = (60.0 / 280.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__SPAS__RECOIL_MULTIPLIER        = 0.7                               ; // Severity of the recoil
    const float     fWEAPON__SPAS__PUMP_DELAY               = 0.5                               ; // Time in between pumps
    const float     fWEAPON__SPAS__PUMP_TIME                = 0.5                               ; // Time it takes to pump
    
    const int       iWEAPON__MOSSBERG__CLIP                 = 8                                 ; // Size of the magazine
    const int       iWEAPON__MOSSBERG__AMMO1                = iWEAPON__SHOTGUN__AMMO1__MAX      ; // Primary ammo capacity
    const int       iWEAPON__MOSSBERG__AMMO2                = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__MOSSBERG__SPREAD             = VECTOR_CONE_6DEGREES * 1          ; // Accuracy of the weapon
    const int       iWEAPON__MOSSBERG__FIRE_MODE            = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__MOSSBERG__DAMAGE               = 7                                 ; // Weapon damage
    const float     fWEAPON__MOSSBERG__ATTACK_DELAY         = (60.0 / 350.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__MOSSBERG__RECOIL_MULTIPLIER    = 0.9                               ; // Severity of the recoil
    const float     fWEAPON__MOSSBERG__PUMP_DELAY           = 0.5                               ; // Time in between pumps
    const float     fWEAPON__MOSSBERG__PUMP_TIME            = 0.5                               ; // Time it takes to pump
    
    const int       iWEAPON__USAS12__CLIP                   = 20                                ; // Size of the magazine
    const int       iWEAPON__USAS12__AMMO1                  = iWEAPON__SHOTGUN__AMMO1__MAX      ; // Primary ammo capacity
    const int       iWEAPON__USAS12__AMMO2                  = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__USAS12__SPREAD               = VECTOR_CONE_6DEGREES * 1          ; // Accuracy of the weapon
    const int       iWEAPON__USAS12__FIRE_MODE              = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__USAS12__DAMAGE                 = 6                                 ; // Weapon damage
    const float     fWEAPON__USAS12__ATTACK_DELAY           = (60.0 / 350.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__USAS12__RECOIL_MULTIPLIER      = 0.9                               ; // Severity of the recoil
    
    const int       iWEAPON__SAWEDOFF__CLIP                 = 2                                 ; // Size of the magazine
    const int       iWEAPON__SAWEDOFF__AMMO1                = iWEAPON__SHOTGUN__AMMO1__MAX      ; // Primary ammo capacity
    const int       iWEAPON__SAWEDOFF__AMMO2                = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__SAWEDOFF__SPREAD             = VECTOR_CONE_6DEGREES * 1          ; // Accuracy of the weapon
    const int       iWEAPON__SAWEDOFF__FIRE_MODE            = FireMode::iSEMI_AUTOMATIC         ; // Fire mode of the weapon
    const int       iWEAPON__SAWEDOFF__DAMAGE               = 15                                ; // Weapon damage
    const float     fWEAPON__SAWEDOFF__ATTACK_DELAY         = (60.0 / 400.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__SAWEDOFF__RECOIL_MULTIPLIER    = 3.0                               ; // Severity of the recoil
    
    const SOUND_CHANNEL scWEAPON__RIFLE__DEFAULT_CHANNEL    = CHAN_WEAPON                       ; // Default sound channel for rifles. Helps to preserve original sound quality.
    
    const int       iWEAPON__AK47__CLIP                     = 30                                ; // Size of the magazine
    const int       iWEAPON__AK47__AMMO1                    = iWEAPON__RIFLE__AMMO1__MAX        ; // Primary ammo capacity
    const int       iWEAPON__AK47__AMMO2                    = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__AK47__SPREAD                 = VECTOR_CONE_6DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__AK47__FIRE_MODE                = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__AK47__DAMAGE                   = 17                                ; // Weapon damage
    const float     fWEAPON__AK47__ATTACK_DELAY             = (60.0 / 650.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__AK47__RECOIL_MULTIPLIER        = 1.2                               ; // Severity of the recoil
    
    const int       iWEAPON__M4A1__CLIP                     = 30                                ; // Size of the magazine
    const int       iWEAPON__M4A1__AMMO1                    = iWEAPON__RIFLE__AMMO1__MAX        ; // Primary ammo capacity
    const int       iWEAPON__M4A1__AMMO2                    = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__M4A1__SPREAD                 = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__M4A1__FIRE_MODE                = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__M4A1__DAMAGE                   = 13                                ; // Weapon damage
    const float     fWEAPON__M4A1__ATTACK_DELAY             = (60.0 / 750.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__M4A1__RECOIL_MULTIPLIER        = 0.8                               ; // Severity of the recoil
    
    const int       iWEAPON__M16__CLIP                      = 18                                ; // Size of the magazine
    const int       iWEAPON__M16__AMMO1                     = iWEAPON__RIFLE__AMMO1__MAX        ; // Primary ammo capacity
    const int       iWEAPON__M16__AMMO2                     = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__M16__SPREAD                  = VECTOR_CONE_2DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__M16__FIRE_MODE                 = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__M16__DAMAGE                    = 21                                ; // Weapon damage
    const float     fWEAPON__M16__ATTACK_DELAY              = (60.0 / 240.0)                    ; // [seconds] Time between trigger pulls
    const float     fWEAPON__M16__BURST_DELAY               = (60.0 / 1000.0)                   ; // [seconds] Time between round fires
    const float     fWEAPON__M16__RECOIL_MULTIPLIER         = 1.4                               ; // Severity of the recoil
    
    const int       iWEAPON__AUG__CLIP                      = 30                                ; // Size of the magazine
    const int       iWEAPON__AUG__AMMO1                     = iWEAPON__RIFLE__AMMO1__MAX        ; // Primary ammo capacity
    const int       iWEAPON__AUG__AMMO2                     = -1                                ; // Secondary ammo capacity
    const Vector    vecWEAPON__AUG__SPREAD                  = VECTOR_CONE_3DEGREES              ; // Accuracy of the weapon
    const int       iWEAPON__AUG__FIRE_MODE                 = FireMode::iAUTOMATIC              ; // Fire mode of the weapon
    const int       iWEAPON__AUG__DAMAGE                    = 15                                ; // Weapon damage
    const float     fWEAPON__AUG__ATTACK_DELAY              = (60.0 / 600.0)                    ; // [seconds] Rounds per second = (Minute / Rounds Per Minute)
    const float     fWEAPON__AUG__ATTACK_DELAY__ZOOM        = (60.0 / 500.0)                    ; // [seconds] RPM of the weapon while zooming
    const float     fWEAPON__AUG__RECOIL_MULTIPLIER         = 0.9                               ; // Severity of the recoil
    const float     iWEAPON__AUG__ZOOM_MULTIPLIER           = 2                                 ; // [percentage] How close the player zooms in when scoping
    
    ///////////////////////////////
    // Ammunitions (See https://baso88.github.io/SC_AngelScript/docs/Bullet.htm)
    
    // Melee weapons
    
    // Pistols
    const string    strWEAPON__PISTOL__AMMO_TYPE            = "9mm";
    const int       iWEAPON__PISTOL__AMMO1__MAX             = 250;
    const Bullet    iWEAPON__PISTOL__BULLET__TYPE           = BULLET_PLAYER_9MM;
    
    const string    strWEAPON__PISTOL_MAGNUM__AMMO_TYPE     = "357";
    const int       iWEAPON__PISTOL_MAGNUM__AMMO1__MAX      = 70;
    const Bullet    iWEAPON__PISTOL_MAGNUM__BULLET__TYPE    = BULLET_PLAYER_357;
    
    const string    strWEAPON__PISTOL_762__AMMO_TYPE        = "m40a1";
    const int       iWEAPON__PISTOL_762__AMMO1__MAX         = 30;
    const Bullet    iWEAPON__PISTOL_762__BULLET__TYPE       = BULLET_PLAYER_EAGLE;
    
    // Submachine guns
    const string    strWEAPON__SMG__AMMO_TYPE               = "9mm";
    const int       iWEAPON__SMG__AMMO1__MAX                = 250;
    const Bullet    iWEAPON__SMG__BULLET__TYPE              = BULLET_PLAYER_MP5;
    
    // Shotguns
    const string    strWEAPON__SHOTGUN__AMMO_TYPE           = "buckshot";
    const int       iWEAPON__SHOTGUN__AMMO1__MAX            = 120;
    const Bullet    iWEAPON__SHOTGUN__BULLET__TYPE          = BULLET_PLAYER_BUCKSHOT;
    const int       iWEAPON__SHOTGUN__PELLET_COUNT          = 8;
    
    // Rifles
    const string    strWEAPON__RIFLE__AMMO_TYPE             = "556";
    const int       iWEAPON__RIFLE__AMMO1__MAX              = 600;
    const Bullet    iWEAPON__RIFLE__BULLET__TYPE            = BULLET_PLAYER_SAW;
    
    // Heavy weapons
    // M60 will use the same ammo type as the rifles
    
    const string    strWEAPON__SNIPER__AMMO_TYPE            = "m40a1";
    const int       iWEAPON__SNIPER__AMMO1__MAX             = 30;
    const Bullet    iWEAPON__SNIPER__BULLET__TYPE           = BULLET_PLAYER_SNIPER;
    
    // Ordinance
    const string    strWEAPON__GRENADE__AMMO_TYPE           = "Hand Grenade";
    const int       iWEAPON__GRENADE__AMMO1__MAX            = 10;
    
    namespace CommonFunctions
    {
        //////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::MovingBackwards                             //
        // Function:                                                                    //
        //      Determines based on a player's velocity if they are moving backwards    //
        //      1. Translate the user's view around the y axis into a point on a circle //
        //      2. Place two other points +45 and -45 degrees around the original point //
        //      3. Determine if the player's y velocity lands between the points        //
        // Parameters:                                                                  //
        //      CBasePlayer@ m_pPlayer = [IN] Player reference                          //
        // Return value:                                                                //
        //      bool                                                                    //
        //      true    = The player is moving backwards                                //
        //      false   = The player is NOT moving backwards                            //
        //////////////////////////////////////////////////////////////////////////////////
        bool MovingBackwards(CBasePlayer@ m_pPlayer)
        {
            Vector vel;
            float view = m_pPlayer.pev.angles.y;
            
            g_EngineFuncs.VecToAngles(m_pPlayer.pev.velocity, vel);

            view += 180;
            float a = view - 90;
            float b = view + 90;
            float c = vel.y;

            if (a < 0   )   a += 360;
            if (b < 0   )   b += 360;
            if (a > 360 )   a -= 360;
            if (b > 360 )   b -= 360;    

            if (a <= b) return (c >= a && c <= b);
            else        return (c >= a || c <= b);
        } // End of MovingBackwards()
        
        //////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::IsAboveWater    //
        // Function:                                        //
        //      Determines if a player is above water       //
        // Parameters:                                      //
        //      int iWaterLevel                             //
        // Return value:                                    //
        //      bool                                        //
        //////////////////////////////////////////////////////
        bool IsAboveWater(int iWaterLevel)
        {
            return iWaterLevel != WATERLEVEL_HEAD;
        } // End of IsAboveWater()
        
        //////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::AttackButtonPressed         //
        // Function:                                                    //
        //      Determines if a player is pressing the attack button    //
        // Parameters:                                                  //
        //      int iButtonPressed - Bit field                          //
        // Return value:                                                //
        //      bool                                                    //
        //////////////////////////////////////////////////////////////////
        bool AttackButtonPressed(int iButtonPressed)
        {
            return ((iButtonPressed & IN_ATTACK) != 0);
        } // End of AttackButtonPressed()
        
        //////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::SpreadDecay                                     //
        // Function:                                                                        //
        //      Handles weapon spread                                                       //
        // Parameters:                                                                      //
        //      float &fInaccuracyFactor    = [OUT] Spread scalar to apply decay            //
        //      float fInaccuracyDelta      = [IN ] How much inaccuracy to apply
        //      float fInaccuracyMaximum    = [IN ] Maximum value fInaccuracyFactor can be  //
        // Return value:                                                                    //
        //      float                                                                       //
        //////////////////////////////////////////////////////////////////////////////////////
        float SpreadIncrease(float fInaccuracyFactor, float fInaccuracyDelta, float fInaccuracyMaximum)
        {
            // Add some inaccuracy to the spread
            fInaccuracyFactor += fInaccuracyDelta;
            
            // Determine if the maximum inaccuracy factor has been reached
            if (fInaccuracyFactor > fInaccuracyMaximum)
            {
                fInaccuracyFactor = fInaccuracyMaximum;
            }
            
            return fInaccuracyFactor;
        } // End of SpreadDecay()
        
        //////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::SpreadDecay                             //
        // Function:                                                                //
        //      Handles weapon spread decay                                         //
        // Parameters:                                                              //
        //      float &fInaccuracyFactor    = [OUT] Spread scalar to apply decay    //
        //      float fInaccuracyDecay      = [IN ] Interpolation decay value       //
        // Return value:                                                            //
        //      float                                                               //
        //////////////////////////////////////////////////////////////////////////////
        float SpreadDecay(float fInaccuracyFactor, float fInaccuracyDecay)
        {
            // Decrease the spread inaccuracy
            fInaccuracyFactor -= fInaccuracyDecay;
            
            // Determine if the minimum inaccuracy factor has been reached
            if (fInaccuracyFactor < 1.0)
            {
                fInaccuracyFactor = 1.0;
            }
            
            return fInaccuracyFactor;
        } // End of SpreadDecay()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::WeaponRecoilSmooth                                                              //
        // Function:                                                                                                        //
        //      Handles weapon recoil                                                                                       //
        // Parameter:                                                                                                       //
        //      CBasePlayer@    pPlayer             = [BOTH] The player the recoil effect is applied to                     //
        //      float&          fInterpolator       = [BOTH] The interpolation value to apply to a curve smoothing function //
        // Return value:                                                                                                    //
        //      bool    - true  = Weapon still has some recoiling to do                                                     //
        //              - false = Weapon recoil function has finished                                                       //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        bool WeaponRecoilSmooth(CBasePlayer@ pPlayer, float &out fInterpolator)
        {
            // Default return value is true, or recoil interpolation can continue
            bool bReturn = true;
            
            float fInterpolationResult = 0.0;
            
            // Get the interpolated value
            fInterpolationResult = sin(fInterpolator + 0.5);
            
            // Decrease the interpolation delta
            fInterpolator += 0.2;
            
            // g_EngineFuncs.ClientPrintf(pPlayer, print_console, "1 fiveseven: player pev angles (x,y)=(" + m_pPlayer.pev.v_angle.x + ", " + m_pPlayer.pev.v_angle.y + ")\n");
            // pPlayer.pev.v_angle.x += 50.0;
            pPlayer.pev.avelocity = Vector(0.0, -fInterpolationResult, 0.0);
            // g_EngineFuncs.ClientPrintf(pPlayer, print_console, "sin(m_fInterpolator - pi/2)=" + fInterpolation_result + "\n");
            
            // Set the fixangle to 2 (or velocity based angle)
            pPlayer.pev.fixangle = 2;
            
            // Determine if the interpolative delta has reached 0
            if (fInterpolationResult < 0.0)
            {
                // Recoil interpolation has finished, return false
                bReturn = false;
            }
            
            return bReturn;
        } // End of WeaponRecoilSmooth()
        
        //////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::WeaponRecoil                                        //
        // Function:                                                                            //
        //      Handles weapon recoil                                                           //
        // Parameter:                                                                           //
        //      CBasePlayer@    pPlayer     = [BOTH] The player the recoil effect is applied to //
        //      float           fMultiplier = [IN  ] Scalar effect for recoil                   //
        // Return value:                                                                        //
        //      void                                                                            //
        //////////////////////////////////////////////////////////////////////////////////////////
        void WeaponRecoil(CBasePlayer@ pPlayer, float fMultiplier=1.0)
        {
            // View punch as a way to simulate recoil
            // TODO:
            //      Move the players cursor instead of applying a visual transformation
            // X = Up   (negative)      Down    (positive)
            // Y = Left (negative)      Right   (positive)
            
            float fRandomPunchX = Math.RandomFloat(-2, 0) * fMultiplier;
            float fRandomPunchY = Math.RandomFloat(-2, 2) * fMultiplier;
            
            Vector vecOldPunchangle = Vector(pPlayer.pev.punchangle.x, pPlayer.pev.punchangle.y, pPlayer.pev.punchangle.z);
            
            pPlayer.pev.punchangle = Vector(fRandomPunchX, fRandomPunchY, 0) + vecOldPunchangle;
        } // End of WeaponRecoil()
        
        //////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::ApplyBulletDecal                            //
        // Function:                                                                    //
        //      Generic weapon shooting handling function                               //
        // Parameters:                                                                  //
        //      CBasePlayer@    pPlayer     = [BOTH] Player who fired the weapon        //
        //      Vector          vecSrc      = [IN  ] Where the player was firing from   //    
        //      Vector          vecAiming   = [IN  ] Where the player was aiming at     //
        // Return value:                                                                //
        //      None                                                                    //
        //////////////////////////////////////////////////////////////////////////////////
        void ApplyBulletDecal(CBasePlayer@ pPlayer, Vector vecSrc, Vector vecAiming, Vector vecSpread)
        {
            // Decal tracing variables
            TraceResult tr;
            float x;
            float y;
            
            g_Utility.GetCircularGaussianSpread(x, y);
                    
            Vector vecDir = vecAiming 
                            + x * vecSpread.x * g_Engine.v_right 
                            + y * vecSpread.y * g_Engine.v_up;
            Vector vecEnd    = vecSrc + vecDir * TheSpecialists::fMAXIMUM_FIRE_DISTANCE;


            // Determine if the player hit something
            g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr);
            if (tr.flFraction < 1.0)
            {
                // The trace is valid
                
                // Determine if what was hit is a valid object
                if (tr.pHit !is null)
                {
                    // There is a valid entity hit
                    CBaseEntity@ pHit = g_EntityFuncs.Instance(tr.pHit);
                    
                    // Determine if the object hit is NOT an entity class type or is the map mesh
                    if (pHit is null || pHit.IsBSPModel())
                    {
                        // A wall or non-entity object was hit, so apply a bullet hole decal
                        g_WeaponFuncs.DecalGunshot(tr, BULLET_PLAYER_MP5);
                        
                    } // End of if (pHit is null || pHit.IsBSPModel())
                        
                } // End of if (tr.pHit !is null)
                    
            } // End of if (tr.flFraction < 1.0)
                
        } // End of ApplyBulletDecal()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PlayEmptySound                                                          //
        // Function:                                                                                                //
        //      Plays the dry fire sound                                                                            //
        // Parameters:                                                                                              //
        //      CBasePlayer@    pPlayer         = [BOTH] The player whose location the sound will be played from    //
        //      string          strSoundPath    = [IN  ] Path of the sound file to play                             //
        // Return value:                                                                                            //
        //      None                                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void PlayEmptySound(CBasePlayer@ pPlayer, string strSoundPath)
        {
            PlaySoundDynamicWithVariablePitch(pPlayer, strSoundPath);
        } // End of PlayEmptySound()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitch                                       //
        // Function:                                                                                                //
        //      Interface with PlaySoundDynamic, includes variable pitch for audial flavor                          //
        // Parameters:                                                                                              //
        //      CBasePlayer@    pPlayer         = [BOTH] The player whose location the sound will be played from    //
        //      string          strSoundPath    = [IN] Path of the sound to be played                               //
        // Return value:                                                                                            //
        //      None                                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamicWithVariablePitch(CBasePlayer@ pPlayer, string strSoundPath)
        {
            // Getting library defaults and so I can reference them with a shorter variable name
            int iDefaultPitch          = TheSpecialists::iDEFAULT_PITCH;
            int iDefaultPitchVariation = TheSpecialists::iDEFAULT_PITCH_VARIATION;
            
            // Generate a random pitch
            // Move the default pitch back half the pitch variation so it's evenly spread out +/- iDefaultPitch
            // For example, if default pitch is 100, and pitch variation is 10
            //      Pitch before variation applied      = 95 = 100 - (10 / 2)
            //      Pitch after variation is applied    = 95 = 100 - (10 / 2) + RandomNumberBetween(0, 10)
            //      Range of values that can be generated [105, 95]
            //      So the average is still around 100
            int iPitch = (iDefaultPitch - (iDefaultPitchVariation / 2)) + Math.RandomLong(0, iDefaultPitchVariation);
            
            // Debug printing
            // g_EngineFuncs.ClientPrintf(pPlayer, print_console, "PlaySoundDynamicWithVariablePitch: strSoundPath=" + strSoundPath + "\n");
            
            PlaySoundDynamic(pPlayer, strSoundPath, iPitch);
        } // End of PlaySoundDynamicWithVariablePitch()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitchOverChannel                            //
        // Function:                                                                                                //
        //      Interface with PlaySoundDynamic, includes variable pitch for audial flavor                          //
        // Parameters:                                                                                              //
        //      CBasePlayer@    pPlayer         = [BOTH] The player whose location the sound will be played from    //
        //      SOUND_CHANNEL   scChannel       = [IN] Sound channel the sound will be played through               //
        //      string          strSoundPath    = [IN] Path of the sound to be played                               //
        // Return value:                                                                                            //
        //      None                                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamicWithVariablePitchOverChannel(CBasePlayer@ pPlayer, SOUND_CHANNEL scChannel, string strSoundPath)
        {
            // Getting library defaults and so I can reference them with a shorter variable name
            int iDefaultPitch          = TheSpecialists::iDEFAULT_PITCH;
            int iDefaultPitchVariation = TheSpecialists::iDEFAULT_PITCH_VARIATION;
            
            // Generate a random pitch
            // Move the default pitch back half the pitch variation so it's evenly spread out +/- iDefaultPitch
            // For example, if default pitch is 100, and pitch variation is 10
            //      Pitch before variation applied      = 95 = 100 - (10 / 2)
            //      Pitch after variation is applied    = 95 = 100 - (10 / 2) + RandomNumberBetween(0, 10)
            //      Range of values that can be generated [105, 95]
            //      So the average is still around 100
            int iPitch = (iDefaultPitch - (iDefaultPitchVariation / 2)) + Math.RandomLong(0, iDefaultPitchVariation);
            
            // Debug printing
            // g_EngineFuncs.ClientPrintf(pPlayer, print_console, "PlaySoundDynamicWithVariablePitch: strSoundPath=" + strSoundPath + "\n");
            
            PlaySoundDynamicOverChannel(pPlayer, scChannel, strSoundPath, iPitch);
        } // End of PlaySoundDynamicWithVariablePitchOverChannel()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PlaySoundDynamic                                                        //
        // Function:                                                                                                //
        //      Interface with g_SoundSystem.EmitSoundDyn                                                           //
        // Parameters:                                                                                              //
        //      CBasePlayer@    pPlayer         = [BOTH] The player whose location the sound will be played from    //
        //      string          strSoundPath    = [IN  ] Path of the sound to be played                             //
        //      int             iPitch          = [IN  ] Pitch of the sound                                         //
        // Return value:                                                                                            //
        //      None                                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamic(CBasePlayer@ pPlayer, string strSoundPath, int iPitch)
        {
            g_SoundSystem.EmitSoundDyn
            (
                pPlayer.edict()                         , // edict_t@ entity
                TheSpecialists::scDEFAULT_CHANNEL       , // SOUND_CHANNEL channel
                strSoundPath                            , // const string& in szSample
                TheSpecialists::fDEFAULT_VOLUME         , // float flVolume
                TheSpecialists::fDEFAULT_ATTENUATION    , // float flAttenuation
                0                                       , // int iFlags = 0
                iPitch                                    // int iPitch = PITCH_NORM
                                                          // int target_ent_unreliable = 0
            );
        } // End of PlaySoundDynamic()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PlaySoundDynamicOverChannel                                             //
        // Function:                                                                                                //
        //      Interface with g_SoundSystem.EmitSoundDyn                                                           //
        // Parameters:                                                                                              //
        //      CBasePlayer@    pPlayer         = [BOTH] The player whose location the sound will be played from    //
        //      SOUND_CHANNEL   scChannel       = [IN  ] Channel the sound will be played through                   //
        //      string          strSoundPath    = [IN  ] Path of the sound to be played                             //
        //      int             iPitch          = [IN  ] Pitch of the sound                                         //
        // Return value:                                                                                            //
        //      None                                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamicOverChannel(CBasePlayer@ pPlayer, SOUND_CHANNEL scChannel, string strSoundPath, int iPitch)
        {
            g_SoundSystem.EmitSoundDyn
            (
                pPlayer.edict()                         , // edict_t@ entity
                scChannel                               , // SOUND_CHANNEL channel
                strSoundPath                            , // const string& in szSample
                TheSpecialists::fDEFAULT_VOLUME         , // float flVolume
                TheSpecialists::fDEFAULT_ATTENUATION    , // float flAttenuation
                0                                       , // int iFlags = 0
                iPitch                                    // int iPitch = PITCH_NORM
                                                          // int target_ent_unreliable = 0
            );
        } // End of PlaySoundDynamicOverChannel()
        
        //////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::PickRandomElementFromListInt    //
        // Function:                                                        //
        //      Gets a random element from the given integer array          //
        // Parameters:                                                      //
        //      array<int> arrList                                          //
        // Return value:                                                    //
        //      int     - random integer from the list                      //
        //              - returns -1 on error                               //
        //////////////////////////////////////////////////////////////////////
        int PickRandomElementFromListInt(array<int> arrList)
        {
            if (arrList.length() != 0)
            {
                return arrList[Math.RandomLong(0, arrList.length() - 1)];
            }
            else
            {
                return -1;
            }
        } // End of int PickRandomElementFromListInt()
        
        //////////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::CommonFunctions::CreatePelletDecals                              //
        // Function:                                                                        //
        //      Creates a variable number of pellet decals                                  //
        // Parameters:                                                                      //
        //      CBasePlayer         pPlayer         = [BOTH] Player reference               //
        //      const Vector& in    vecSrc          = [IN] Origin of the shooter            //
        //      const Vector& in    vecAiming       = [IN] Where the player is aiming       //
        //      const Vector& in    vecSpread       = [IN] Accuracy of the weapon           //
        //      const uint          uiPelletCount   = [IN] How many pellet decals to create //
        // Return value:                                                                    //
        //      None                                                                        //
        //////////////////////////////////////////////////////////////////////////////////////
        void CreatePelletDecals(CBasePlayer @pPlayer, const Vector& in vecSrc, const Vector& in vecAiming, const Vector& in vecSpread, const uint uiPelletCount)
        {
            TraceResult tr;
            
            float x = 0.0;
            float y = 0.0;
            
            for (uint uiPellet = 0; uiPellet < uiPelletCount; ++uiPellet)
            {
                g_Utility.GetCircularGaussianSpread(x, y);
                
                Vector vecDir = vecAiming 
                                + x * vecSpread.x * g_Engine.v_right 
                                + y * vecSpread.y * g_Engine.v_up;

                Vector vecEnd = vecSrc + vecDir * 2048;
                
                g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, pPlayer.edict(), tr);
                
                if (tr.flFraction < 1.0)
                {
                    if (tr.pHit !is null)
                    {
                        CBaseEntity@ pHit = g_EntityFuncs.Instance(tr.pHit);
                        
                        if (pHit is null || pHit.IsBSPModel())
                        {
                            g_WeaponFuncs.DecalGunshot(tr, BULLET_PLAYER_BUCKSHOT);
                            
                        } // End of if (pHit is null || pHit.IsBSPModel())
                            
                    } // End of if (tr.pHit !is null)
                        
                } // End of if (tr.flFraction < 1.0)
                    
            } // End of for (uint uiPellet = 0; uiPellet < uiPelletCount; ++uiPellet)
                
        } // End of CreatePelletDecals

    } // End of namespace CommonFunctions

} // End of namespace TheSpecialists