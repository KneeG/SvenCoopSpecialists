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
    
    ///////////////////////////////
    // Fire modes
    namespace FireMode
    {
        const int iSEMI_AUTOMATIC   = 0;
        const int iBURST_FIRE       = 1;
        const int iAUTOMATIC        = 2;
    } // End of namespace FireMode
    
    const int           iDEFAULT_FIRE_MODE          = FireMode::iSEMI_AUTOMATIC ; // Default fire mode of a weapon
    const int           iDEFAULT_PITCH_VARIATION    = 15                        ; // Default pitch variation (in hertz)
    const float         iDEFAULT_PITCH              = 100                       ; // Default pitch
    const float         fDEFAULT_SOUND_DISTANCE     = 512                       ; // Default limit the sound will be transmitted
    const float         fDEFAULT_VOLUME             = 1.0                       ; // Default volume (in percentage)
    const SOUND_CHANNEL scDEFAULT_CHANNEL           = CHAN_WEAPON               ; // Default sound channel
    const float         fDEFAULT_ATTENUATION        = ATTN_NORM                 ; // Default attenuation, or sound dropoff
    const int           iMONSTER_GUN_VOLUME         = 384                       ; // Default gun fire volume, I can only assume this is distance in its implementation
    const float         fGUN_SOUND_DURATION         = 0.3                       ; // How long the gun sound persists (in seconds)
    const float         fSWING_DISTANCE             = 48.0                      ; // Number of units the melee weapon can hit
    const float         fDEFAULT_HOSTER_TIME        = 0.5                       ; // Time in seconds it will take for the crowbar to be holstered
    const int           iDEFAULT_WEIGHT             = 1                         ; // Not certain what the weight does for a weapon, but it is defined in other weapon scripts
    const float         fDEFAULT_NEXT_THINK         = 1.0                       ; // Time in seconds between weapon think function calls
    const float         fDEFAULT_FIRE_ON_EMPTY_DELAY= 0.25                      ; // Time in seconds between trigger pulls while the gun is empty
    const float         fMAXIMUM_FIRE_DISTANCE      = 8192.0                    ; // Maximum distance a bullet will do damage to targets
    
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
    const int iWEAPON__MELEE__MAX_CLIP              = 0;
    
    const int   iWEAPON__KATANA__AMMO1              = -1                            ;
    const int   iWEAPON__KATANA__AMMO2              = 1                             ;
    const int   iWEAPON__KATANA__DAMAGE             = 55                            ;
    const float fWEAPON__KATANA__ATTACK_DELAY       = (60 / 60.0)                     ; // Time in seconds between swings
    
    const int   iWEAPON__SEAL_KNIFE__AMMO1          = -1                            ;
    const int   iWEAPON__SEAL_KNIFE__AMMO2          = 10                            ;
    const int   iWEAPON__SEAL_KNIFE__DAMAGE         = 20                            ;
    const float fWEAPON__SEAL_KNIFE__ATTACK_DELAY   = (60 / 240.0)                    ; // Time in seconds between swings
    
    const int   iWEAPON__COMBAT_KNIFE__AMMO1        = -1                            ;
    const int   iWEAPON__COMBAT_KNIFE__AMMO2        = 5                             ;
    const int   iWEAPON__COMBAT_KNIFE__DAMAGE       = 25                            ;
    const float fWEAPON__COMBAT_KNIFE__ATTACK_DELAY = (60 / 150.0)                    ; // Time in seconds between swings
    
    // Pistols behavior
    const int       iWEAPON__GLOCK18__CLIP              = 18                            ;
    const int       iWEAPON__GLOCK18__AMMO1             = iWEAPON__PISTOL__AMMO1__MAX   ;
    const int       iWEAPON__GLOCK18__AMMO2             = -1                            ;
    const Vector    vecWEAPON__GLOCK18__SPREAD          = VECTOR_CONE_4DEGREES          ; // Accuracy of the weapon
    const int       iWEAPON__GLOCK18__FIRE_MODE         = FireMode::iAUTOMATIC          ;
    const int       iWEAPON__GLOCK18__DAMAGE            = 15                            ;
    const float     fWEAPON__GLOCK18__ATTACK_DELAY      = (60.0 / 900.0)                ; // Time in seconds between swings
    
    const int       iWEAPON__GLOCK22__CLIP              = 15                            ;
    const int       iWEAPON__GLOCK22__AMMO1             = iWEAPON__PISTOL__AMMO1__MAX   ;
    const int       iWEAPON__GLOCK22__AMMO2             = -1                            ;
    const Vector    vecWEAPON__GLOCK22__SPREAD          = VECTOR_CONE_4DEGREES          ; // Accuracy of the weapon
    const int       iWEAPON__GLOCK22__FIRE_MODE         = FireMode::iSEMI_AUTOMATIC     ;
    const int       iWEAPON__GLOCK22__DAMAGE            = 23                            ;
    const float     fWEAPON__GLOCK22__ATTACK_DELAY      = (60.0 / 500.0)                ; // Time in seconds between swings
    
    const int       iWEAPON__FIVESEVEN__CLIP            = 20                            ;
    const int       iWEAPON__FIVESEVEN__AMMO1           = iWEAPON__PISTOL__AMMO1__MAX   ;
    const int       iWEAPON__FIVESEVEN__AMMO2           = -1                            ;
    const Vector    vecWEAPON__FIVESEVEN__SPREAD        = VECTOR_CONE_2DEGREES          ; // Accuracy of the weapon
    const int       iWEAPON__FIVESEVEN__FIRE_MODE       = FireMode::iSEMI_AUTOMATIC     ;
    const int       iWEAPON__FIVESEVEN__DAMAGE          = 18                            ;
    const float     fWEAPON__FIVESEVEN__ATTACK_DELAY    = (60.0 / 500.0)                ; // Time in seconds between swings
    
    // Submachine guns behavior
    const int       iWEAPON__TMP__CLIP                  = 20                            ;
    const int       iWEAPON__TMP__AMMO1                 = iWEAPON__SMG__AMMO1__MAX      ;
    const int       iWEAPON__TMP__AMMO2                 = -1                            ;
    const Vector    vecWEAPON__TMP__SPREAD              = VECTOR_CONE_4DEGREES          ; // Accuracy of the weapon
    const int       iWEAPON__TMP__FIRE_MODE             = FireMode::iAUTOMATIC          ;
    const int       iWEAPON__TMP__DAMAGE                = 14                            ;
    const float     fWEAPON__TMP__ATTACK_DELAY          = (60.0 / 1100.0)               ; // Time in seconds between swings
    
    
    ///////////////////////////////
    // Ammunitions
    
    // Melee weapons    
    
    
    // Pistols
    const string    strWEAPON__PISTOL__AMMO_TYPE    = "9mm";
    const int       iWEAPON__PISTOL__AMMO1__MAX     = 250;
    
    // Submachine guns
    const string    strWEAPON__SMG__AMMO_TYPE       = "9mm";
    const int       iWEAPON__SMG__AMMO1__MAX        = 250;
    
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
        void ApplyBulletDecal(CBasePlayer@ pPlayer, Vector vecSrc, Vector vecAiming)
        {
            // Decal tracing variables
            TraceResult tr;
            float x;
            float y;
            
            g_Utility.GetCircularGaussianSpread(x, y);
                    
            Vector vecDir = vecAiming 
                            + x * VECTOR_CONE_6DEGREES.x * g_Engine.v_right 
                            + y * VECTOR_CONE_6DEGREES.y * g_Engine.v_up;
            Vector vecEnd	= vecSrc + vecDir * TheSpecialists::fMAXIMUM_FIRE_DISTANCE;


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