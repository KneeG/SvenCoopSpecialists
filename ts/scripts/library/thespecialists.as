//////////////////////////////////////////////////////////////////////////////////
// File         : thespecialists.as                                             //
// Author       : Knee                                                          //
// Description  : Contains common definitions used by The Specialists weapons   //
//////////////////////////////////////////////////////////////////////////////////

/*

    Useful information:
    
    
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
    const string strMODEL_PATH                  = "models/ts/"                              ;
    const string strSOUND_PATH                  = "ts/"                                     ; // "sound" is assumed to be the base directory for sound functions
    
    const string strSPRITE_ROOT                 = "sprites/"                                ;
    const string strSPRITE_PATH                 = "ts/"                                     ; // "sprites" is assumed to be the base directory for sprite files
    const string strSPRITE_WEAPON_METADATA      = "weapon_metadata/"                        ;
    const string strSPRITE_METADATA_PATH        = strSPRITE_PATH + strSPRITE_WEAPON_METADATA; // Path of the sprite weapons metadata
    
    const int iSPRITE__WEAPONS__WIDTH           = 128                                       ; // [pixels] Width of the weapon sprites
    const int iSPRITE__WEAPONS__HEIGHT          = 48                                        ; // [pixels] Height of the weapon sprites
    
    ///////////////////////////////
    // Weapon slot definitions
    const int WEAPON__SLOT__MELEE               = 0; // Melee weapons such as kungfu and blades
    const int WEAPON__SLOT__PISTOL              = 1; // Pistols
    const int WEAPON__SLOT__SMG                 = 2; // Sub machine guns
    const int WEAPON__SLOT__RIFLE               = 3; // Usually butted weapons, such as rifles and shotguns
    const int WEAPON__SLOT__HEAVY               = 4; // Heavy weapons like machine guns and snipers
    const int WEAPON__SLOT__ORDINANCE           = 5; // Grenades
    
    ///////////////////////////////
    // Weapon position definitions
    
    // Melee weapons
    // Starting at a number above 0 since there are other default half-life weapons at those positions
    const int WEAPON__POSITION__KUNGFU          = 5;
    const int WEAPON__POSITION__SEAL_KNIFE      = 6;
    const int WEAPON__POSITION__COMBAT_KNIFE    = 7;
    const int WEAPON__POSITION__KATANA          = 8;
    
    // Pistols
    
    // Rifles/Shotguns
    
    // Heavy weapons
    
    // Ordinance
    
    ///////////////////////////////
    // Ammunitions
    
    // Melee weapons
    const int WEAPON__CLIP__KATANA              = 1 ;
    const int WEAPON__CLIP__SEAL_KNIFE          = 10;
    const int WEAPON__CLIP__COMBAT_KNIFE        = 5 ;
    
    // Pistols
    
    // Rifles/Shotguns
    
    // Heavy weapons
    
    // Ordinance
    
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
} // End of namespace TheSpecialists