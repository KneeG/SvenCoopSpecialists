//////////////////////////////////////////////////////////////////////////////////////
// File         : barney.as                                                         //
// Author       : Knee                                                              //
// Description  : Contains common definitions used by the low def model for barney  //
//////////////////////////////////////////////////////////////////////////////////////

namespace BarneyBase
{
    // Side note:
    // I would love to use enums that ARE supported by AngelScript
    // but the compiler's pickyness on type conversions are so annoying and unworkable,
    // that I switched to namespaces instead. Whoever implemented AngelScript, just let C++ be C++.
    
    // Enumerator for Barney's animation events
    // This is my first attempt at implementing a monster, and all the documentation online does NOT
    // explain very well at all how to correctly find the exact numbers associated with animation events
    //
    // But at the very least I can find some correlation between what I see in Half Life Model Viewer and
    // Valve's documentation on the Animation Event numbers (https://github.com/ValveSoftware/halflife/blob/master/dlls/barney.cpp)
    // For the following animations:
    //      +-------------+-----------+-------------+
    //      | SHOOTGUN1   | Event 1   | Event 2     |
    //      +-------------+-----------+-------------+
    //      | Frame       |   0       |   0         |
    //      | Event ID    |   5001    |   3         |   Event 2 corresponds to Valve's Barney AE #define of (3)
    //      | Options     |   21      |   (null)    |
    //      | Type        |   0       |   0         |
    //      +-------------+-----------+-------------+
    //      | SHOOTGUN2   | Event 1   | Event 2     |
    //      +-------------+-----------+-------------+
    //      | Frame       |   0       |   0         |
    //      | Event ID    |   5001    |   3         |   Event 2 corresponds to Valve's Barney AE #define of (3)
    //      | Options     |   21      |   (null)    |
    //      | Type        |   0       |   0         |
    //      +-------------+-----------+-------------+
    //
    // there are clearly 2 different Event IDs
    // The first being 5001, and the second being 3.
    // But this begs the question: Why is 5001 NOT used? Why are they not BOTH accounted for?
    // Had Valve NOT provided the example documentation, how would I have known to use 3 over 5001 or 5001 over 3?
    namespace AnimationEvent
    {
        const int DRAW    = 2;
        const int SHOOT   = 3;
        const int HOLSTER = 4;
    }
    
    // Enumerator for Barney's body types
    namespace BodyType
    {
        const int PISTOL_HOLSTERED  = 0;
        const int PISTOL_DRAWN      = 1;
        const int PISTOL_NONE       = 2;
    }

    // Enumerator for Barney's animation list
    namespace Animation
    {
        const int IDLE1                         = 0;
        const int IDLE2                         = 1;
        const int IDLE3                         = 2;
        const int IDLE4                         = 3;
        const int WALK                          = 4;
        const int RUN                           = 5;
        const int SHOOTGUN1                     = 6;
        const int SHOOTGUN2                     = 7;
        const int DRAW                          = 8;
        const int DISARM                        = 9;
        const int RELOAD                        = 10;
        const int TURN_LEFT                     = 11;
        const int TURN_RIGHT                    = 12;
        const int FLINCH_LEFT_ARM               = 13;
        const int FLINCH_RIGHT_ARM              = 14;
        const int FLINCH_LEFT_LEG               = 15;
        const int FLINCH_RIGHT_LEG              = 16;
        const int FLINCH_HEAD                   = 17;
        const int LOOK_AROUND                   = 18;
        const int USE_LOCKED_DOOR               = 19;
        const int FALL_LOOP                     = 20;
        const int WAVE                          = 21;
        const int STAND_OFF_GRUNT               = 22;
        const int STAND_IDLE_OVER_GRUNT         = 23;
        const int KNOCK_DOOR_HOLDING_FLASHLIGHT = 24;
        const int DEATH_SIT_FLAT                = 25;
        const int DEATH_SPIN                    = 26;
        const int DEATH_GUT_SHOT                = 27;
        const int DEATH_FALL_FORWARD            = 28;
        const int DEATH_FALL_BACKWARD           = 29;
        const int DEATH_FALL_FORWARD2           = 30;
        const int BARNACLE_GRAB                 = 31;
        const int BARNACLE_PULL                 = 32;
        const int BARNACLE_BITE                 = 33;
        const int BARNACLE_CHEW                 = 34;
        const int DEAD_ON_BACK                  = 35;
        const int DEAD_ON_SIDE                  = 36;
        const int DEAD_ON_STOMACH               = 37;
        const int DEAD_IN_VENT                  = 38;
        const int STANDING_IDLE1                = 39;
        const int CPR_ON_FLOOR                  = 40;
        const int CPR_GETTING_UP                = 41;
        const int DRAGGED_INTO_VENT             = 42;
        const int ON_FLOOR_DYING                = 43;
        const int ON_FLOOR_IDLE                 = 44;
        const int WATCHING_FLOOR_GETTING_UP     = 45;
        const int WATCHING_FLOOR_IDLE           = 46;
        const int C1A3_BIDLE                    = 47;
        const int C1A3_VENTB                    = 48;
        const int C1A3_EMERGE_IDLE              = 49;
        const int C1A3_EMERGE_OUT_VENT          = 50;
        const int BODY_HAULED                   = 51;
        const int KEYPAD_PRESS                  = 52;
        const int GRAB_ELECTRIFIED_FENCE_DIE    = 53;
        const int SWIVEL_AT_DESK                = 54;
        const int DYING_ON_STOMACH_IDLE         = 55;
        const int DYING_ON_STOMACH_DEATH        = 56;
        const int LASER_DEATH_IDLE              = 57;
        const int LASER_DEATH_TOP               = 58;
        const int LASER_DEATH_BOTTOM            = 59;
        const int FALL_ABOUT_TO                 = 60;
        const int FALL_STARTING_TO              = 61;
        const int DRAW_PISTOL_FALSE_ALARM       = 62;
        const int UNLATCH_DOOR                  = 63;
        const int USE_RETINAL_SCANNER           = 64;
        const int STANDING_IDLE2                = 65;
        const int ASSASSINATED                  = 66;
        const int PULL_LEVER_DOWN               = 67;
        const int KNOCK_OBJECT_DOWN             = 68;
        const int SHOVE_OBJECT_OVER             = 69;
        const int PRESS_BUTTON                  = 70;
    }
    
    array<ScriptSchedule@>@ monster_barney_schedules;

    ScriptSchedule slBaFollow
    ( 
        bits_COND_NEW_ENEMY		|
        bits_COND_LIGHT_DAMAGE	|
        bits_COND_HEAVY_DAMAGE	|
        bits_COND_HEAR_SOUND,
        bits_SOUND_DANGER, 
        "Follow"
   );
            
    ScriptSchedule slBaFaceTarget
    (
        //bits_COND_CLIENT_PUSH	|
        bits_COND_NEW_ENEMY		|
        bits_COND_LIGHT_DAMAGE	|
        bits_COND_HEAVY_DAMAGE	|
        bits_COND_HEAR_SOUND ,
        bits_SOUND_DANGER,
        "FaceTarget"
   );
        
    ScriptSchedule slIdleBaStand
    (
        bits_COND_NEW_ENEMY		|
        bits_COND_LIGHT_DAMAGE	|
        bits_COND_HEAVY_DAMAGE	|
        bits_COND_HEAR_SOUND	|
        bits_COND_SMELL,

        bits_SOUND_COMBAT		|// sound flags - change these, and you'll break the talking code.	
        bits_SOUND_DANGER		|
        bits_SOUND_MEAT			|// scents
        bits_SOUND_CARCASS		|
        bits_SOUND_GARBAGE,
        "IdleStand"
   );
        
    ScriptSchedule slBaReload
    (
        bits_COND_HEAVY_DAMAGE	|
        bits_COND_HEAR_SOUND,
        bits_SOUND_DANGER,
        "Barney Reload"
   );
        
    ScriptSchedule slBaReloadQuick
    (
        bits_COND_HEAVY_DAMAGE	|
        bits_COND_HEAR_SOUND,
        bits_SOUND_DANGER,
        "Barney Reload Quick"
   );
            
    ScriptSchedule slBarneyEnemyDraw(0, 0, "Barney Enemy Draw");
    
    void InitSchedules()
    {
        slBaFollow.AddTask          (ScriptTask(TASK_MOVE_TO_TARGET_RANGE       , 128.0f                    ));
        slBaFollow.AddTask          (ScriptTask(TASK_SET_SCHEDULE               , SCHED_TARGET_FACE         ));
        
        slBarneyEnemyDraw.AddTask   (ScriptTask(TASK_STOP_MOVING                                            ));
        slBarneyEnemyDraw.AddTask   (ScriptTask(TASK_FACE_ENEMY                                             ));
        slBarneyEnemyDraw.AddTask   (ScriptTask(TASK_PLAY_SEQUENCE_FACE_ENEMY   , float(ACT_ARM)            ));
            
        slBaFaceTarget.AddTask      (ScriptTask(TASK_SET_ACTIVITY               , float(ACT_IDLE)           ));
        slBaFaceTarget.AddTask      (ScriptTask(TASK_FACE_TARGET                                            ));
        slBaFaceTarget.AddTask      (ScriptTask(TASK_SET_ACTIVITY               , float(ACT_IDLE)           ));
        slBaFaceTarget.AddTask      (ScriptTask(TASK_SET_SCHEDULE               , float(SCHED_TARGET_CHASE) ));
            
        slIdleBaStand.AddTask       (ScriptTask(TASK_STOP_MOVING                                            ));
        slIdleBaStand.AddTask       (ScriptTask(TASK_SET_ACTIVITY               , float(ACT_IDLE)           ));
        slIdleBaStand.AddTask       (ScriptTask(TASK_WAIT                       , 2                         ));
        //slIdleBaStand.AddTask( ScriptTask(TASK_TLK_HEADRESET));
            
        slBaReload.AddTask          (ScriptTask(TASK_STOP_MOVING                                            ));
        slBaReload.AddTask          (ScriptTask(TASK_SET_FAIL_SCHEDULE          , float(SCHED_RELOAD)       ));
        slBaReload.AddTask          (ScriptTask(TASK_FIND_COVER_FROM_ENEMY                                  ));
        slBaReload.AddTask          (ScriptTask(TASK_RUN_PATH                                               ));
        slBaReload.AddTask          (ScriptTask(TASK_REMEMBER                   , float(bits_MEMORY_INCOVER)));
        slBaReload.AddTask          (ScriptTask(TASK_WAIT_FOR_MOVEMENT_ENEMY_OCCLUDED                       ));
        slBaReload.AddTask          (ScriptTask(TASK_RELOAD                                                 ));
        slBaReload.AddTask          (ScriptTask(TASK_FACE_ENEMY                                             ));
                
        slBaReloadQuick.AddTask     (ScriptTask(TASK_STOP_MOVING                                            ));
        slBaReloadQuick.AddTask     (ScriptTask(TASK_RELOAD                                                 ));
        slBaReloadQuick.AddTask     (ScriptTask(TASK_FACE_ENEMY                                             ));
        
        array<ScriptSchedule@> scheds = {slBaFollow, slBarneyEnemyDraw, slBaFaceTarget, slIdleBaStand, slBaReload, slBaReloadQuick};
        
        @monster_barney_schedules = @scheds;
    }
    
    // Asset paths
    const string    strMODEL                = "models/barney.mdl"           ; // Path to the npc model
    const string    strSOUND_SHOOT1         = "barney/ba_attack2.wav"       ; // Path to the npc firing sound
    
    // NPC configuration constants
    const string        strDISPLAYNAME      = "Barney"                      ; // Default displayname
    
    const int           iMAGAZINE_SIZE      = 17                            ; // Maximum number of bullets in barney's gun between reloads
    const int           iMAXIMUM_HEALTH     = 100                           ; // Default maximum health
    const int           iDEFAULT_HEIGHT     = 55                            ; // Howm any units up the barney model will shoot from the ground
    
    const int           eBLOOD_COLOR        = int(BLOOD_COLOR_RED)          ; // Default blood color
    const int           eBODY_TYPE          = BodyType::PISTOL_HOLSTERED    ; // Default body type
    const int           eMOVE_TYPE          = int(MOVETYPE_STEP)            ; // Default move type
    const int           eSOLID              = int(SOLID_SLIDEBOX)           ; // Default solid state
    const int           eCLASSIFICATION     = int(CLASS_HUMAN_MILITARY)     ; // Default classification, based on the "classify" state
    const MONSTERSTATE  eMONSTER_STATE      = MONSTERSTATE_NONE             ; // Default monster state
    
    const float         fTURN_SPEED         = 90.0                          ; // Default turn speed, degrees per second
    
    const int           iMAXIMUM_RANGE      = 1024                          ; // Maximum distance Barney can shoot from
    const int           iBULLET_TYPE        = BULLET_MONSTER_9MM            ; // Default bullet type barney fires
    const int           iMUZZLE_FLASH       = EF_MUZZLEFLASH                ; // Default effect to be transmitted (EF_ effects are bits and EF_MUZZLEFLASH is Bit 2 (decimal value 2 when set) in the effects bit field)
    
    // Sound constants
    const int           iPITCH_VARIATION    = 100                           ; // Default pitch variation (in hertz)
    const float         fDEFAULT_GUN_VOLUME = 1.0                           ; // Default volume (in percentage)
    const int           iDEFAULT_CHANNEL_GUN= CHAN_WEAPON                   ; // Default sound channel
    const float         fDEFAULT_ATTENUATION= ATTN_NORM                     ; // Default attenuation, or sound dropoff
    const int           iMONSTER_GUN_VOLUME = 384                           ; // Default gun fire volume, I can only assume this distance in its implementation
    const float         fGUN_SOUND_DURATION = 0.3                           ; // How long the gun sound persists (in seconds)
} // End of namespace BarneyBase