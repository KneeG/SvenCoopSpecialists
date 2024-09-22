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
    
    const string strSPRITE_ROOT                 = "sprites/"                                    ;
    const string strSPRITE_TS_PATH              = "ts/"                                         ; // "sprites" is assumed to be the base directory for sprite files
    const string strSPRITE_WEAPON_METADATA      = "weapon_metadata/"                            ; // Location of the .txt files
    const string strSPRITE_METADATA_PATH        = strSPRITE_TS_PATH + strSPRITE_WEAPON_METADATA ; // Path of the sprite weapons metadata
    
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
    
    // Melee weapons
    // Starting at a number above 0 since there are other default half-life weapons at those positions
    const int iWEAPON__POSITION__KUNGFU         = 5                                             ;
    const int iWEAPON__POSITION__SEAL_KNIFE     = 6                                             ;
    const int iWEAPON__POSITION__COMBAT_KNIFE   = 7                                             ;
    const int iWEAPON__POSITION__KATANA         = 8                                             ;
    
    // Pistols
    
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
    
    // Weapon traceline rules
    // IGNORE_MONSTERS enum     Purpose
    // ---------------------------------
    // dont_ignore_monsters     Don't ignore monsters.
    // ignore_monsters          Ignore monsters.
    // missile                  The traceline bounds are set to mins -15, -15, -15 and maxs 15, 15, 15. Otherwise, the bounds are specified by the traceline operation.
    const IGNORE_MONSTERS eIGNORE_RULE              = dont_ignore_monsters;
    
    ///////////////////////////////
    // Ammunitions
    
    // Melee weapons
    const int iWEAPON__MELEE__MAX_CLIP              = WEAPON_NOCLIP   ; // A melee weapon will not have a clip size
    const int iWEAPON__AMMO1__KATANA                = -1              ;
    const int iWEAPON__AMMO1__SEAL_KNIFE            = -1              ;
    const int iWEAPON__AMMO1__COMBAT_KNIFE          = -1              ;
    const int iWEAPON__AMMO2__KATANA                = 1               ;
    const int iWEAPON__AMMO2__SEAL_KNIFE            = 10              ;
    const int iWEAPON__AMMO2__COMBAT_KNIFE          = 5               ;
    
    // Pistols
    
    // Rifles/Shotguns
    
    // Heavy weapons
    
    // Ordinance
    
    namespace CommonFunctions
    {
        //////////////////////////////////////////////////////////////////////////////////
        // TheSpecialists::MovingBackwards                                              //
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

    } // End of namespace CommonFunctions

} // End of namespace TheSpecialists