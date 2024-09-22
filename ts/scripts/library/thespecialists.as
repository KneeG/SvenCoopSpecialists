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
            | Row # | Text      | Display mask  | Sprite path       | x start   | y start   | x end     | y end     |
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
    
    // Rifles/Shotguns
    
    // Heavy weapons
    
    // Ordinance
    
    ///////////////////////////////
    // Weapon behavior
    const int           iDEFAULT_PITCH_VARIATION    = 15            ; // Default pitch variation (in hertz)
    const float         iDEFAULT_PITCH              = 100           ; // Default pitch
    const float         fDEFAULT_SOUND_DISTANCE     = 512           ; // Default limit the sound will be transmitted
    const float         fDEFAULT_VOLUME             = 1.0           ; // Default volume (in percentage)
    const SOUND_CHANNEL scDEFAULT_CHANNEL           = CHAN_WEAPON   ; // Default sound channel
    const float         fDEFAULT_ATTENUATION        = ATTN_NORM     ; // Default attenuation, or sound dropoff
    const int           iMONSTER_GUN_VOLUME         = 384           ; // Default gun fire volume, I can only assume this distance in its implementation
    const float         fGUN_SOUND_DURATION         = 0.3           ; // How long the gun sound persists (in seconds)
    const float         fSWING_DISTANCE             = 32.0          ; // Number of units the melee weapon can hit
    const float         fDEFAULT_HOSTER_TIME        = 0.5           ; // Time in seconds it will take for the crowbar to be holstered
    const int           iDEFAULT_WEIGHT             = 1             ; // Not certain what the weight does for a weapon, but it is defined in other weapon scripts
    const float         fDEFAULT_NEXT_THINK         = 1.0           ; // Time in seconds between weapon think function calls
    const float         fDEFAULT_FIRE_ON_EMPTY_DELAY= 0.25          ; // Time in seconds between trigger pulls while the gun is empty
    const float         fMAXIMUM_FIRE_DISTANCE      = 8192.0        ; // Maximum distance a bullet will do damage to targets
    
    // Weapon traceline rules
    // IGNORE_MONSTERS enum     Purpose
    // ---------------------------------
    // dont_ignore_monsters     Don't ignore monsters.
    // ignore_monsters          Ignore monsters.
    // missile                  The traceline bounds are set to mins -15, -15, -15 and maxs 15, 15, 15. Otherwise, the bounds are specified by the traceline operation.
    const IGNORE_MONSTERS eIGNORE_RULE              = dont_ignore_monsters;
    
    // Attack Delay Seconds = (60 seconds / Rounds Per Minute)
    
    // Melee behavior
    const int   iWEAPON__KATANA__DAMAGE             = 55            ;
    const float fWEAPON__KATANA__ATTACK_DELAY       = (60 / 60)     ; // Time in seconds between swings
    
    const int   iWEAPON__SEAL_KNIFE__DAMAGE         = 20            ;
    const float fWEAPON__SEAL_KNIFE__ATTACK_DELAY   = (60 / 240)    ; // Time in seconds between swings
    
    const int   iWEAPON__COMBAT_KNIFE__DAMAGE       = 25            ;
    const float fWEAPON__COMBAT_KNIFE__ATTACK_DELAY = (60 / 150)    ; // Time in seconds between swings
    
    // Pistols behavior
    const int   iWEAPON__GLOCK18__DAMAGE            = 18            ;
    const float fWEAPON__GLOCK18__ATTACK_DELAY      = (60.0 / 900.0); // Time in seconds between swings
    
    const int   iWEAPON__GLOCK22__DAMAGE            = 18            ;
    const float fWEAPON__GLOCK22__ATTACK_DELAY      = (60.0 / 500.0); // Time in seconds between swings
    
    // Submachine guns behavior
    const int   iWEAPON__TMP__DAMAGE                = 14            ;
    const float fWEAPON__TMP__ATTACK_DELAY          = (60.0 / 1100.0); // Time in seconds between swings
    
    
    ///////////////////////////////
    // Ammunitions
    
    // Melee weapons    
    const int iWEAPON__MELEE__MAX_CLIP              = WEAPON_NOCLIP ; // A melee weapon will not have a clip size
    const int iWEAPON__AMMO1__KATANA                = -1            ;
    const int iWEAPON__AMMO1__SEAL_KNIFE            = -1            ;
    const int iWEAPON__AMMO1__COMBAT_KNIFE          = -1            ;
    const int iWEAPON__AMMO2__KATANA                = 1             ;
    const int iWEAPON__AMMO2__SEAL_KNIFE            = 10            ;
    const int iWEAPON__AMMO2__COMBAT_KNIFE          = 5             ;
    
    // Pistols
    const string    strWEAPON__PISTOL__AMMO_TYPE    = "9mm"                         ;
    
    const int       iWEAPON__CLIP__GLOCK18          = 18                            ;
    const int       iWEAPON__AMMO1__GLOCK18         = iWEAPON__CLIP__GLOCK18 * 8    ;
    const int       iWEAPON__AMMO2__GLOCK18         = -1                            ;
    
    const int       iWEAPON__CLIP__GLOCK22          = 15                            ;
    const int       iWEAPON__AMMO1__GLOCK22         = iWEAPON__CLIP__GLOCK18 * 9    ;
    const int       iWEAPON__AMMO2__GLOCK22         = -1                            ;
    
    // Submachine guns
    const string    strWEAPON__SMG__AMMO_TYPE       = "9mm"                         ;
    const int       iWEAPON__CLIP__TMP              = 20                            ;
    const int       iWEAPON__AMMO1__TMP             = iWEAPON__CLIP__GLOCK18 * 8    ;
    const int       iWEAPON__AMMO2__TMP             = -1                            ;
    
    // Rifles/Shotguns
    
    // Heavy weapons
    
    // Ordinance
    
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

    } // End of namespace CommonFunctions

} // End of namespace TheSpecialists