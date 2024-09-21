//////////////////////////////////////////////////////////////////////////////
// File         : weapon_ts_combat_knife.as                                 //
// Author       : Knee                                                      //
// Description  : Contains common definitions used by the half life crowbar //
//////////////////////////////////////////////////////////////////////////////

#include "../../library/weapons/crowbar"
#include "../../library/thespecialists"

/////////////////////////////////////
// TS_CombatKnife namespace
namespace TS_CombatKnife
{
    /////////////////////////////////////
    // Combat_knife animation enumeration
    namespace Animations
    {
        const int IDLE1     = 0;
        const int IDLE2     = 1;
        const int DRAW1     = 2;
        const int SLASH1    = 3;
        const int SLASH2    = 4;
        const int SLASH3    = 5;
        const int BLOCK1    = 6;
        const int THROW1    = 7;
    }
    
    // Return constants
    const int               RETURN_SUCCESS              = 0;
    const int               RETURN_ERROR_NULL_POINTER   = -1;
    
    // Meta data
    const string            strNAME             = "combat_knife"                                                ;
    const string            strNAMESPACE        = "TS_CombatKnife::"                                            ;
    const string            strCLASSNAME        = "weapon_ts_" + strNAME                                        ;

    // Asset paths
    const string            strMODEL_P          = TheSpecialists::strMODEL_PATH + "melee/p_" + strNAME + ".mdl" ;
    const string            strMODEL_V          = TheSpecialists::strMODEL_PATH + "melee/v_" + strNAME + ".mdl" ;
    const string            strMODEL_W          = TheSpecialists::strMODEL_PATH + "melee/w_" + strNAME + ".mdl" ;

    const string            strSPRITE_FILE      = TheSpecialists::strSPRITE_METADATA_PATH + strNAME + ".txt"    ;

    const string            strSOUND_PATH       = TheSpecialists::strSOUND_PATH + "knife/"                      ;
    
    const string            strSOUND_HIT1       = strSOUND_PATH + "knife_hit.wav"                               ;
    const array<string>     arrSoundHitList     = {
        strSOUND_HIT1
    };
    
    const string            strSOUND_HIT_BODY1  = strSOUND_PATH + "knife_hitbody.wav"                           ;
    
    const string            strSOUND_MISS1      = strSOUND_PATH + "knife_miss.wav"                              ;
    const array<string>     arrSoundMissList    = {
        strSOUND_MISS1
    };
    
    // Create a list of animations to be played
    const array<int> arrAnimationList = {
        Animations::SLASH1,
        Animations::SLASH2,
        Animations::SLASH3
    };
    
    const float             fHOLSTER_TIME           = CrowbarBase::fDEFAULT_HOSTER_TIME                         ;
    const float             fNEXT_THINK             = 1.0                                                       ;
    const float             fPRIMARY_ATTACK_DELAY   = 0.4                                                       ;
    
    const float             fSWING_DISTANCE         = CrowbarBase::fSWING_DISTANCE                              ;
    
    const IGNORE_MONSTERS   eIGNORE_RULE            = CrowbarBase::eIGNORE_RULE                                 ;
    
    const int               iDAMAGE    = 25                                                                     ;
    
    /////////////////////////////////////
    // Combat_knife class
    class weapon_ts_combat_knife : ScriptBasePlayerWeaponEntity
    {
        private CBasePlayer@ m_pPlayer      ; // Player reference pointer
        private int m_iDamage               ; // Weapon damage
        
        int m_iSwing                        ; // Keeps track of which swing animation is currently used
        int m_iSwingMissSound               ; // Keeps track of which swing sound is currently played
        TraceResult m_trHit                 ; // Keeps track of what is hit when the combat_knife is swung
        
        //////////////////////////////////////////
        // TS_CombatKnife::Spawn                //
        // Function:                            //
        //      Spawn function for the weapon   //
        // Parameters:                          //
        //      None                            //
        // Return value:                        //
        //      None                            //
        //////////////////////////////////////////
        void Spawn()
        {
            self.Precache();
            
            m_iDamage = iDAMAGE;
            
            // Set the world model
            g_EntityFuncs.SetModel(self, self.GetW_Model(strMODEL_W));
            
            // Set the clip size
            self.m_iClip = CrowbarBase::iMAX_CLIP;
            
            // Set the weapon damage
            self.m_flCustomDmg = m_iDamage;

            // Initialize gravity on the weapon
            self.FallInit();
        } // End of Spawn()

        //////////////////////////////////////////////////
        // TS_CombatKnife::Precache                     //
        // Function:                                    //
        //      Prechacing function for weapon assets   //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void Precache()
        {
            self.PrecacheCustomModels   ();

            g_Game.PrecacheModel        (strMODEL_P);
            g_Game.PrecacheModel        (strMODEL_V);
            g_Game.PrecacheModel        (strMODEL_W);

            g_SoundSystem.PrecacheSound (strSOUND_PATH       );
            g_SoundSystem.PrecacheSound (strSOUND_HIT1       );
            g_SoundSystem.PrecacheSound (strSOUND_HIT_BODY1  );
            g_SoundSystem.PrecacheSound (strSOUND_MISS1      );
            
            g_Game.PrecacheGeneric      (TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE);
        } // End of Precache()

        //////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::GetItemInfo                                              //
        // Function:                                                                //
        //      Sets the weapon metadata                                            //
        // Parameters:                                                              //
        //      ItemInfo& out info = [OUT] Object to write this weapon's metadata   //
        // Return value:                                                            //
        //      Bool                                                                //
        //////////////////////////////////////////////////////////////////////////////
        bool GetItemInfo(ItemInfo& out info)
        {
            info.iMaxAmmo1		= CrowbarBase::iMAX_AMMO_1                      ;
            info.iMaxAmmo2		= CrowbarBase::iMAX_AMMO_2                      ;
            info.iMaxClip		= CrowbarBase::iMAX_CLIP                        ;
            info.iSlot			= TheSpecialists::WEAPON__SLOT__MELEE           ;
            info.iPosition		= TheSpecialists::WEAPON__POSITION__COMBAT_KNIFE;
            info.iWeight		= CrowbarBase::iDEFAULT_WEIGHT                  ;
            
            return true;
        } // End of GetItemInfo()
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::AddToPlayer                                                              //
        // Function:                                                                                //
        //      Adds the weapon to the player if they exist                                         //
        //      If the player exists, save a reference to the player                                //
        // Parameters:                                                                              //
        //      CBasePlayer@ pPlayer = [IN] Object referencing the player that picked up the weapon //
        // Return value:                                                                            //
        //      Bool                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////
        bool AddToPlayer(CBasePlayer@ pPlayer)
        {
            bool bReturn = false;
            
            // Attempt to add the weapon to the player
            bReturn = BaseClass.AddToPlayer(pPlayer);
            if(bReturn)
            {
                @m_pPlayer = pPlayer;
            }
            
            return bReturn;
        } // End of AddToPlayer()

        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::Deploy                                                                   //
        // Function:                                                                                //
        //      Adds the weapon to the player if they exist                                         //
        //      If the player exists, save a reference to the player                                //
        // Parameters:                                                                              //
        //      CBasePlayer@ pPlayer = [IN] Object referencing the player that picked up the weapon //
        // Return value:                                                                            //
        //      Bool                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////
        bool Deploy()
        {
            return self.DefaultDeploy
            (
                self.GetV_Model(strMODEL_V),    // string v_model
                self.GetP_Model(strMODEL_P),    // string p_model
                Animations::DRAW1,              // int i_model_animation
                "crowbar"                       // Not sure what this is
            );
        }

        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::Holster                                                                  //
        // Function:                                                                                //
        //      Hides the weapon from the player                                                    //
        // Parameters:                                                                              //
        //      CBasePlayer@ pPlayer = [IN] Object referencing the player that picked up the weapon //
        // Return value:                                                                            //
        //      None                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////
        void Holster(int skiplocal)
        {
            // Melee weapons don't need to reload so commenting this out
            // self.m_fInReload = false;// cancel any reload in progress.

            // Set the cooldown timer for the next attack
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + fHOLSTER_TIME;

            // Hide the player model by making the viewmodel path empty
            m_pPlayer.pev.viewmodel = "";
            
            // Tell the looping function to stop calling any of our combat_knife functions
            SetThink(null);
        } // End of Holster()
        
        //////////////////////////////////////////////////
        // TS_CombatKnife::PrimaryAttack                //
        // Function:                                    //
        //      Performs the weapon's primary attack    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void PrimaryAttack()
        {
            Swing();
            
            self.m_flNextPrimaryAttack = g_Engine.time + fPRIMARY_ATTACK_DELAY;
        } // End of PrimaryAttack()

        //////////////////////////////////////////////////
        // TS_CombatKnife::Swing                        //
        // Function:                                    //
        //      Performs the primary attack function    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void Swing()
        {
            int     iCallReturn     = 0     ; // Capturing function code returns
            bool    bHit            = false ; // Flag used to determine if an object was hit by the combat_knife
            float   flVolumeInWorld = 1.0   ; // Scalar used to amplify volume, depending on what was hit
            bool    bHitWorld       = true  ; // Flag used to determine if the world, and not an npc, was hit

            TraceResult tr;

            Math.MakeVectors(m_pPlayer.pev.v_angle);
            Vector vecSrc	= m_pPlayer.GetGunPosition();
            Vector vecDir   = g_Engine.v_forward * fSWING_DISTANCE;
            
            Vector vecEnd	= vecSrc + vecDir;
            
            // tr.flFraction = How much of the trace's total distance was covered. 1.0 means it didn't hit anything.
            g_Utility.TraceLine
            (
                vecSrc,             // const Vector& in vecStart    - Start vector
                vecEnd,             // const Vector& in vecEnd      - End vector
                eIGNORE_RULE,       // IGNORE_MONSTERS igmon        - Do I ignore monsters
                m_pPlayer.edict(),  // edict_t@ pEntIgnore          - Ignore myself (the player) when considering who I am swinging at
                tr                  // TraceResult& out ptr         - Traceline result
            );
            if (tr.flFraction >= 1.0)
            {
                // The trace hit something in front of it
                g_Utility.TraceHull
                (
                    vecSrc,             // const Vector& in vecStart
                    vecEnd,             // const Vector& in vecEnd
                    eIGNORE_RULE,       // IGNORE_MONSTERS igmon 
                    head_hull,          // HULL_NUMBER hullNumber
                    m_pPlayer.edict(),  // edict_t@ pEntIgnore
                    tr                  // TraceResult& out ptr
                );
                // Determine if the trace hit something close
                if (tr.flFraction < 1.0)
                {
                    // Calculate the point of intersection of the line (or hull) and the object we hit
                    // This is and approximation of the "best" intersection
                    CBaseEntity@ pHit = g_EntityFuncs.Instance(tr.pHit);
                    if (pHit is null || pHit.IsBSPModel())
                    {
                        // Determine if the world was hit
                        if (pHit.IsBSPModel())
                        {
                            bHitWorld = true;
                        }
                           
                        // Can't find the definition of this function in the Sven Coop Angelscript API documentation
                        // I have found this at:
                        // https://github.com/ValveSoftware/halflife/blob/master/dlls/crowbar.cpp
                        // FindHullIntersection( const Vector &vecSrc, TraceResult &tr, float *mins, float *maxs, edict_t *pEntity )
                        //
                        // Ducking time
                        // #define TIME_TO_DUCK         0.4
                        // #define VEC_DUCK_HULL_MIN    -18
                        // #define VEC_DUCK_HULL_MAX    18
                        // #define VEC_DUCK_VIEW        12
                        // #define PM_DEAD_VIEWHEIGHT   -8
                        g_Utility.FindHullIntersection
                        (
                            vecSrc,             // const Vector &vecSrc
                            tr,                 // TraceResult &tr
                            tr,                 // TraceResult &tr          - Why are there 2 of the same parameter?
                            VEC_DUCK_HULL_MIN,  // float mins
                            VEC_DUCK_HULL_MAX,  // float maxs
                            m_pPlayer.edict()   // edict_t@ pEntIgnore      - Assuming this is what the original function meant
                        );
                        
                    } // End of if (pHit is null || pHit.IsBSPModel())
                    else
                    {
                        // The map was not hit, and neither was anything else, so set the flag to false
                        bHitWorld = false;
                    }

                    // This is the point on the actual surface (the hull could have hit space)
                    vecEnd = tr.vecEndPos;
                    
                } // End of if (tr.flFraction < 1.0)
                    
            } // End of if (tr.flFraction >= 1.0)

            // Determine if we missed
            if (tr.flFraction >= 1.0)
            {
                // Miss
                
                // Debug print
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_center, "Swing " + m_iSwing + " mod 3 = " + (m_iSwing % 3));
                
                // Play a random animation from the list
                PlayRandomAnimation(arrAnimationList);
                    
                // Play a random miss sound from the list
                PlayRandomSoundFromList(arrSoundMissList);
                
                // Set the player animation so other players can see
                m_pPlayer.SetAnimation(PLAYER_ATTACK1);
                
            } // End of if (tr.flFraction >= 1.0)
            else
            {
                // Hit
                
                // Set the hit flag to true
                bHit = true;
                
                // Play a random animation from the list
                PlayRandomAnimation(arrAnimationList);

                // Set the player animation so other players can see
                m_pPlayer.SetAnimation(PLAYER_ATTACK1);

                // Get the entity instance of whoever was hit
                CBaseEntity@ pEntity = g_EntityFuncs.Instance(tr.pHit);
                
                // Apply damage to the entity if it exists
                iCallReturn = ApplyDamangeToEntity(pEntity, m_iDamage, tr);
                if (RETURN_SUCCESS == iCallReturn)
                {
                    // Damage was successfully applied to the entity
                    
                    // This is NOT the correct place to check if the world has been hit, so commenting this out
                    //bHitWorld = false;

                    // Determine if this entity is allowed to bleed
                    if (    (pEntity.Classify()     != CLASS_NONE       )
                         && (pEntity.Classify()     != CLASS_MACHINE    )
                         && (pEntity.BloodColor()   != DONT_BLEED       )    )
                    {
                        // Play the 'hit body' sound
                        PlaySoundDynamicWithVariablePitch(strSOUND_HIT_BODY1);

                    } // End of if (Hit Object can Bleed)
                        
                } // End of if (pEntity !is null)

                // Debug printing
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Swing: bHitWorld=" + bHitWorld + "'\n");

                // Play texture hit sound
                if (bHitWorld)
                {
                    // Get the appropriate sound
                    g_SoundSystem.PlayHitSound(tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR);

                    // Debug printing
                    // g_EngineFuncs.ClientPrintf(m_pPlayer, print_center, "Hit wall");

                    // Play one of the hit sounds
                    PlayRandomSoundFromList(arrSoundHitList);
                    
                } // End of if (bHitWorld)

                // The combat_knife doesn't leave a bullet hole mark like the crowbar does, so a decal will not be imprinted
                
                // Keep track of the current TraceResult
                m_trHit = tr;

                m_pPlayer.m_iWeaponVolume = int(flVolumeInWorld * CrowbarBase::fDEFAULT_SOUND_DISTANCE);
                
            } // End of else (of if (tr.flFraction >= 1.0))
            
        } // End of Swing()
        
        //////////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::ApplyDamageToEntity                                          //
        // Function:                                                                    //
        //      Applies damage to an entity                                             //
        // Parameters:                                                                  //
        //      CBaseEntity@    pEntity = [IN] Reference to the entity being damaged    //
        //      int             iDamage = [IN] Damage to apply to the entity            //
        //      TraceResult     tr      = [IN] TraceResult of the player to the entity  //
        // Return value:                                                                //
        //      int                                                                     //
        //      RETURN_SUCCESS              on success                                  //
        //      RETURN_ERROR_NULL_POINTER   when pEntity is null                        //
        //////////////////////////////////////////////////////////////////////////////////
        int ApplyDamangeToEntity(CBaseEntity@ pEntity, int iDamage, TraceResult tr)
        {
            int iReturn = RETURN_SUCCESS;
            
            // Determine if the entity reference is valid
            if (pEntity !is null)
            {
                // Not sure what this does, but according to others, this must be called before TraceAttack()
                g_WeaponFuncs.ClearMultiDamage();
                
                pEntity.TraceAttack(m_pPlayer.pev, m_iDamage, g_Engine.v_forward, tr, DMG_CLUB);
                
                // Why is there another function with 2 of the same parameter?
                // This must be called after TraceAttack()
                g_WeaponFuncs.ApplyMultiDamage(m_pPlayer.pev, m_pPlayer.pev);
                
                g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "ApplyDamageToEntity: pEntity !is null=" + (pEntity !is null) + "\n");
            }
            else
            {
                // The entity reference is NOT valid
                iReturn = RETURN_ERROR_NULL_POINTER;
            }
            
            g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "ApplyDamageToEntity: iReturn=" + iReturn + "\n");
            
            return iReturn;
            
        } // End of ApplyDamangeToEntity()
        
        //////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::PlayRandomAnimation                                      //
        // Function:                                                                //
        //      Picks a random animation from arrList                               //
        // Parameters:                                                              //
        //      array<int> arrList = [IN] List of animation indeces to choose from  //
        // Return value:                                                            //
        //      None                                                                //
        //////////////////////////////////////////////////////////////////////////////
        void PlayRandomAnimation(array<int> arrList)
        {
            int iLowerRange = 0;
            int iUpperRange = arrList.length() - 1;
            
            // Generate a random number
            int iRandomIndex = Math.RandomLong(iLowerRange, iUpperRange);
            
            // Debug printing
            // int iArrayLength = arrList.length();
            // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "PlayRandomAnimation    : iRandomIndex '" + iRandomIndex + "' of length '" + iArrayLength + "'\n");
            
            // Acquire the randomly selected sound
            int iAnimation = arrList[iRandomIndex];
            
            // Play the animation
            self.SendWeaponAnim(iAnimation);
            
        } // End of PlayRandomAnimation()
        
        //////////////////////////////////////////////////////////////
        // TS_CombatKnife::PlayRandomSoundFromList                  //
        // Function:                                                //
        //      Plays a random sound within the arrList             //
        // Parameters:                                              //
        //      array<string> arrList = [IN] List of sounds to play //
        // Return value:                                            //
        //      None                                                //
        //////////////////////////////////////////////////////////////
        void PlayRandomSoundFromList(array<string> arrList)
        {
            int iLowerRange = 0;
            int iUpperRange = arrList.length() - 1;
            
            // Generate a random number
            int iRandomIndex = Math.RandomLong(iLowerRange, iUpperRange);
            
            // Debug printing
            int iArrayLength = arrList.length();
            g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "PlayRandomSoundFromList: iRandomIndex '" + iRandomIndex + "' of length '" + iArrayLength + "'\n");
            
            // Acquire the randomly selected sound
            string strSound = arrList[iRandomIndex];
            
            // Play the randomly selected sound
            PlaySoundDynamicWithVariablePitch(strSound);
            
        } // End of PlayRandomSoundFromList()
        
        //////////////////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::PlaySoundDynamicWithVariablePitch                                //
        // Function:                                                                        //
        //      Interface with PlaySoundDynamic, includes variable pitch for audial flavor  //
        // Parameters:                                                                      //
        //      string  strSoundPath    = [IN] Path of the sound to be played               //
        // Return value:                                                                    //
        //      None                                                                        //
        //////////////////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamicWithVariablePitch(string strSoundPath)
        {
            // Getting library defaults and so I can reference them with a shorter variable name
            int iDefaultPitch          = CrowbarBase::iDEFAULT_PITCH;
            int iDefaultPitchVariation = CrowbarBase::iDEFAULT_PITCH_VARIATION;
            
            // Generate a random pitch
            // Move the default pitch back half the pitch variation so it's evenly spread out +/- iDefaultPitch
            // For example, if default pitch is 100, and pitch variation is 10
            //      Pitch before variation applied      = 95 = 100 - (10 / 2)
            //      Pitch after variation is applied    = 95 = 100 - (10 / 2) + RandomNumberBetween(0, 10)
            //      Range of values that can be generated [105, 95]
            //      So the average is still around 100
            int iPitch = (iDefaultPitch - (iDefaultPitchVariation / 2)) + Math.RandomLong(0, iDefaultPitchVariation);
            
            g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "PlaySoundDynamicWithVariablePitch: strSoundPath=" + strSoundPath + "\n");
            
            PlaySoundDynamic(strSoundPath, iPitch);
        } // End of PlaySoundDynamicWithVariablePitch()
        
        //////////////////////////////////////////////////////////////////////////
        // TS_CombatKnife::PlaySoundDynamic                                     //
        // Function:                                                            //
        //      Interface with g_SoundSystem.EmitSoundDyn                       //
        // Parameters:                                                          //
        //      string  strSoundPath    = [IN] Path of the sound to be played   //
        //      int     iPitch          = [IN] Pitch of the sound               //
        // Return value:                                                        //
        //      None                                                            //
        //////////////////////////////////////////////////////////////////////////
        void PlaySoundDynamic(string strSoundPath, int iPitch)
        {
            g_SoundSystem.EmitSoundDyn
            (
                m_pPlayer.edict()                   , // edict_t@ entity
                CrowbarBase::scDEFAULT_CHANNEL      , // SOUND_CHANNEL channel
                strSoundPath                        , // const string& in szSample
                CrowbarBase::fDEFAULT_VOLUME        , // float flVolume
                CrowbarBase::fDEFAULT_ATTENUATION   , // float flAttenuation
                0                                   , // int iFlags = 0
                iPitch                                // int iPitch = PITCH_NORM
                                                      // int target_ent_unreliable = 0
            );
        } // End of PlaySoundDynamic()
        
    } // End of class weapon_ts_combat_knife

    string Get_TS_CombatKnifeName()
    {
        return strCLASSNAME;
    }

    void Register_TS_CombatKnife()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strCLASSNAME, Get_TS_CombatKnifeName());
        g_ItemRegistry.RegisterWeapon(Get_TS_CombatKnifeName(), Get_TS_CombatKnifeName());
    }
} // End of namespace TS_CombatKnife