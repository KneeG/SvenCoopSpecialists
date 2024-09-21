//////////////////////////////////////////////////////////////////////////////
// File         : crowbar.as                                                //
// Author       : Knee                                                      //
// Description  : Contains common definitions used by the half life crowbar //
//////////////////////////////////////////////////////////////////////////////

namespace CrowbarBase
{
    // Enumerator for the crowbar's animation list (order here matters)
    // Animation indeces are the same for the classic view model and the high definition model
    namespace Animation
    {
        const int IDLE1         = 0;
        const int DRAW          = 1;
        const int HOLSTER       = 2;
        const int ATTACK1       = 3;
        const int ATTACK1_MISS  = 4;
        const int ATTACK2       = 5;
        const int ATTACK2_HIT   = 6;
        const int ATTACK3       = 7;
        const int ATTACK3_HIT   = 8;
        const int IDLE2         = 9;
        const int IDLE3         = 10;
    }
        
    // Asset paths
    const string strMODEL = "models/v_crowbar.mdl"        ; // Path to the npc model
    
    // Asset lists
    const array<string> arrModelList = {
        "models/v_crowbar.mdl",
        "models/w_crowbar.mdl",
        "models/p_crowbar.mdl"
    };
    
    const array<string> arrSoundList = {
        "weapons/cbar_hit1.wav"         ,
        "weapons/cbar_hit2.wav"         ,
        "weapons/cbar_hitbod1.wav"      ,
        "weapons/cbar_hitbod2.wav"      ,
        "weapons/cbar_hitbod3.wav"      ,
        "weapons/cbar_miss1.wav"
    };
    
    // Ammunition constants
    const int           iMAX_AMMO_1                 = -1            ; // Reserve ammo size, a melee weapon won't need a reserve ammo size
    const int           iMAX_AMMO_2                 = -1            ; // Reserve secondary ammo size, a melee weapon won't need a secondary reserve size
    const int           iMAX_CLIP                   = WEAPON_NOCLIP ; // A melee weapon will not have a clip size
    
    // Arbitrary configuration constants
    const int           iDEFAULT_SLOT               = 0             ; // Slot 0, where most melee weapons go degrees per second
    const int           iDEFAULT_POSITION           = 4             ; // Position in the slot this weapon will be found in
    const int           iDEFAULT_WEIGHT             = 0             ; // Not certain what the weight does for a weapon, but it is defined in other weapon scripts
    const int           iDEFAULT_DAMAGE             = 33            ; // Default damage
    
    // Engine constants
    const float         fDEFAULT_HOSTER_TIME        = 0.5           ; // Time in seconds it will take for the crowbar to be holstered
    const float         fDEFAULT_NEXT_THINK         = 0.5           ; // Time in seconds it will take between crowbar swings
    
    // Sound constants
    const int           iDEFAULT_PITCH_VARIATION    = 15            ; // Default pitch variation (in hertz)
    const float         iDEFAULT_PITCH              = 100           ; // Default pitch
    const float         fDEFAULT_SOUND_DISTANCE     = 512           ; // Default limit the sound will be transmitted
    const float         fDEFAULT_VOLUME             = 1.0           ; // Default volume (in percentage)
    const SOUND_CHANNEL scDEFAULT_CHANNEL           = CHAN_WEAPON   ; // Default sound channel
    const float         fDEFAULT_ATTENUATION        = ATTN_NORM     ; // Default attenuation, or sound dropoff
    const int           iMONSTER_GUN_VOLUME         = 384           ; // Default gun fire volume, I can only assume this distance in its implementation
    const float         fGUN_SOUND_DURATION         = 0.3           ; // How long the gun sound persists (in seconds)
    
    const int           iSWING_FIRST                = 0             ; // Enumerator for the first swing
    const int           iSWING_SECOND               = 1             ; // Enumerator for the second swing
    
    const int           fSWING_DISTANCE             = 32.0          ; // Distance in hammer units how far the swing will reach
    
    // IGNORE_MONSTERS enum     Purpose
    // ---------------------------------
    // dont_ignore_monsters     Don't ignore monsters.
    // ignore_monsters          Ignore monsters.
    // missile                  The traceline bounds are set to mins -15, -15, -15 and maxs 15, 15, 15. Otherwise, the bounds are specified by the traceline operation.
    const IGNORE_MONSTERS eIGNORE_RULE              = dont_ignore_monsters;
    
    // HULL_NUMBER enum
    // Constant Hull    #   Default Mins    Default Maxs    Default Size
    // point_hull   0   0   ,   0   ,   0   0   ,   0,  0   0x0x0
    // human_hull   1   -16 ,   -16 ,   -36 16  ,   16, 36  32x32x72
    // large_hull   2   -32 ,   -32 ,   -32 32  ,   32, 32  64x64x64
    // head_hull    3   -16 ,   -16 ,   -18 16  ,   16, 18  32x32x36
} // End of namespace BarneyBase