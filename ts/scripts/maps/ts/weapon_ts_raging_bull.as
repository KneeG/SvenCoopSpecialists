//////////////////////////////////////////////////////////////
// File         : weapon_ts_raging_bull.as                  //
// Author       : Knee                                      //
// Description  : Raging Bull from The Specialists Mod 3.0  //
//////////////////////////////////////////////////////////////
#include "../../library/thespecialists"

/////////////////////////////////////
// TS_RagingBull namespace
namespace TS_RagingBull
{
    /////////////////////////////////////
    // Raging Bull animation enumeration
    namespace Animations
    {
        const int IDLE1     = 0;
        const int SHOOT1    = 1;
        const int SHOOT2    = 2; // Haven't seen any meaningful difference between this and SHOOT1 based on my inspection
        const int DRAW1     = 3;
        const int RELOAD1   = 4;
        
    }
    
    // Return constants
    const int               RETURN_SUCCESS              = 0;
    const int               RETURN_ERROR_NULL_POINTER   = -1;
    
    // Meta data
    const string            strNAME                 = "raging_bull"             ;
    const string            strNAMESPACE            = "TS_RagingBull::"         ;
    const string            strCLASSNAME            = "weapon_ts_raging_bull"   ;

    // Asset paths
    const string            strMODEL_P              = TheSpecialists::strMODEL_PATH + "pistols/" + strNAME + "/p_" + strNAME + ".mdl";
    const string            strMODEL_V              = TheSpecialists::strMODEL_PATH + "pistols/" + strNAME + "/v_" + strNAME + ".mdl";
    const string            strMODEL_W              = TheSpecialists::strMODEL_PATH + "pistols/" + strNAME + "/w_" + strNAME + ".mdl";
    
    const string            strSPRITE_FILE          = TheSpecialists::strSPRITE_TS_PATH       + strNAME      + ".spr";
    const string            strSPRITE_TEXT_FILE     = TheSpecialists::strSPRITE_METADATA_PATH + strCLASSNAME + ".txt";
    
    const string            strSOUND_CLIPIN         = TheSpecialists::strSOUND_PATH + "pistols/" + strNAME + "/" + TheSpecialists::strPISTOL__SOUND__CLIPIN         ;
    const string            strSOUND_CLIPOUT        = TheSpecialists::strSOUND_PATH + "pistols/" + strNAME + "/" + TheSpecialists::strPISTOL__SOUND__CLIPOUT        ;
    const string            strSOUND_FIRE           = TheSpecialists::strSOUND_PATH + "pistols/" + strNAME + "/" + TheSpecialists::strPISTOL__SOUND__FIRE           ;
    const string            strSOUND_FIRE_SILENCED  = TheSpecialists::strSOUND_PATH + "pistols/" + strNAME + "/" + TheSpecialists::strPISTOL__SOUND__FIRE_SILENCED  ;
    const string            strSOUND_SLIDEBACK      = TheSpecialists::strSOUND_PATH + "pistols/" + strNAME + "/" + TheSpecialists::strPISTOL__SOUND__SLIDEBACK      ;
    const string            strSOUND_EMPTY          = TheSpecialists::strSOUND_PATH + TheSpecialists::strPISTOL__SOUND__EMPTY                                       ;
    
    // Create a list of animations to be played at random
    const array<int> arrAnimationList = {
        Animations::SHOOT1,
        Animations::SHOOT2
    };
    
    const float             fHOLSTER_TIME           = TheSpecialists::fDEFAULT_HOSTER_TIME              ;
    const float             fNEXT_THINK             = TheSpecialists::fDEFAULT_NEXT_THINK               ;
    const float             fPRIMARY_ATTACK_DELAY   = TheSpecialists::fWEAPON__RAGING_BULL__ATTACK_DELAY;
    const float             fSWING_DISTANCE         = TheSpecialists::fSWING_DISTANCE                   ;
    const IGNORE_MONSTERS   eIGNORE_RULE            = TheSpecialists::eIGNORE_RULE                      ;
    const int               iDAMAGE                 = TheSpecialists::iWEAPON__RAGING_BULL__DAMAGE      ;
    const Vector            vecSPREAD               = TheSpecialists::vecWEAPON__RAGING_BULL__SPREAD    ;
    
    /////////////////////////////////////
    // Raging Bull class
    class weapon_ts_raging_bull : ScriptBasePlayerWeaponEntity
    {
        private CBasePlayer@ m_pPlayer          ; // Player reference pointer
        private int     m_iDamage               ; // Weapon damage
        private float   m_fRecoilMultiplier     ; // Recoil multiplier flag
        private float   m_flAnimationCooldown   ; // Animation cooldown timer, helps prevent the weapon from going to idle animations while the weapon is being tilted

        private float   m_fInaccuracyFactor     ; // Negatively affects weapon spread
        private float   m_fInaccuracyDelta      ; // How much inaccuracy
        private float   m_fInaccuracyDecay      ; // How much inaccuracy decreases over time
        
        Vector          m_vecAccuracy           ; // Current accuracy of the weapon
        
        TraceResult m_trHit                     ; // Keeps track of what is hit when the raging_bull is swung
        
        //////////////////////////////////////////
        // TS_RagingBull::Spawn                 //
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
            
            m_fInaccuracyFactor = 1.0                                               ; // Scale factor added to weapon spread cone, negatively affects weapon spread
            m_fInaccuracyDelta  = TheSpecialists::fWEAPON__PISTOL__INACCURACY_DELTA ; // How much inaccuracy increases per shot
            m_fInaccuracyDecay  = TheSpecialists::fWEAPON__PISTOL__INACCURACY_DECAY ; // How much inaccuracy decreases over time
            
            // Initialize accuracy
            m_vecAccuracy = vecSPREAD;
            
            m_fRecoilMultiplier = TheSpecialists::fWEAPON__RAGING_BULL__RECOIL_MULITPLIER;
            
            // Set the clip size
            self.m_iClip = TheSpecialists::iWEAPON__RAGING_BULL__CLIP;
            
            // Set the weapon damage
            self.m_flCustomDmg = m_iDamage;

            // Initialize gravity on the weapon
            self.FallInit();
        } // End of Spawn()

        //////////////////////////////////////////////////
        // TS_RagingBull::Precache                      //
        // Function:                                    //
        //      Prechacing function for weapon assets   //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void Precache()
        {
            self.PrecacheCustomModels();

            g_Game.PrecacheModel(strMODEL_P);
            g_Game.PrecacheModel(strMODEL_V);
            g_Game.PrecacheModel(strMODEL_W);
            
            g_Game.PrecacheModel(TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE);
            
            g_SoundSystem.PrecacheSound(strSOUND_CLIPIN         );
            g_SoundSystem.PrecacheSound(strSOUND_CLIPOUT        );
            g_SoundSystem.PrecacheSound(strSOUND_FIRE           );         
            g_SoundSystem.PrecacheSound(strSOUND_FIRE_SILENCED  );
            g_SoundSystem.PrecacheSound(strSOUND_SLIDEBACK      );
            
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE);
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_TEXT_FILE);
        } // End of Precache()

        //////////////////////////////////////////////////////////////////////////////
        // TS_RagingBull::GetItemInfo                                               //
        // Function:                                                                //
        //      Sets the weapon metadata                                            //
        // Parameters:                                                              //
        //      ItemInfo& out info = [OUT] Object to write this weapon's metadata   //
        // Return value:                                                            //
        //      Bool                                                                //
        //////////////////////////////////////////////////////////////////////////////
        bool GetItemInfo(ItemInfo& out info)
        {
            info.iMaxClip		= TheSpecialists::iWEAPON__RAGING_BULL__CLIP    ;
            info.iMaxAmmo1		= TheSpecialists::iWEAPON__RAGING_BULL__AMMO1   ;
            info.iMaxAmmo2		= TheSpecialists::iWEAPON__RAGING_BULL__AMMO2   ;
            info.iSlot			= TheSpecialists::iWEAPON__SLOT__PISTOL         ;
            info.iPosition		= TheSpecialists::iWEAPON__POSITION__RAGING_BULL;
            info.iWeight		= TheSpecialists::iDEFAULT_WEIGHT               ;
            
            return true;
        } // End of GetItemInfo()
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_RagingBull::AddToPlayer                                                               //
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
                
                // Debug printing
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Raging Bull m_iPrimaryAmmoType: " + self.m_iPrimaryAmmoType + "\n");
                
                NetworkMessage message
                (
                    MSG_ONE,
                    NetworkMessages::WeapPickup,
                    pPlayer.edict()
                );
				message.WriteLong(self.m_iId);
                message.End();
                
                // Debug printing
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Weapon sprite          : " + TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE      + "\n");
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Weapon sprite text file: " + TheSpecialists::strSPRITE_ROOT + strSPRITE_TEXT_FILE + "\n");
            }
            
            @m_pPlayer = pPlayer;
            
            return bReturn;
        } // End of AddToPlayer()

        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_RagingBull::Deploy                                                                    //
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
            // Allow the deploy animation to play
            m_flAnimationCooldown = g_Engine.time + 1.0;
            
            return self.DefaultDeploy
            (
                self.GetV_Model(strMODEL_V),    // string v_model
                self.GetP_Model(strMODEL_P),    // string p_model
                Animations::DRAW1,              // int i_model_animation
                "crowbar"                       // Not sure what this is
            );
        }

        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_RagingBull::Holster                                                                   //
        // Function:                                                                                //
        //      Hides the weapon from the player                                                    //
        // Parameters:                                                                              //
        //      CBasePlayer@ pPlayer = [IN] Object referencing the player that picked up the weapon //
        // Return value:                                                                            //
        //      None                                                                                //
        //////////////////////////////////////////////////////////////////////////////////////////////
        void Holster(int skiplocal)
        {
            self.m_fInReload = false;// cancel any reload in progress.

            // Set the cooldown timer for the next attack
            m_pPlayer.m_flNextAttack = g_WeaponFuncs.WeaponTimeBase() + fHOLSTER_TIME;

            // Hide the player model by making the viewmodel path empty
            m_pPlayer.pev.viewmodel = "";
            
            // Tell the looping function to stop calling any of our raging_bull functions
            SetThink(null);
        } // End of Holster()
        
        //////////////////////////////////////////////////
        // TS_RagingBull::PrimaryAttack                 //
        // Function:                                    //
        //      Performs the weapon's primary attack    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void PrimaryAttack()
        {
            // Determine if the player hasn't already started pressing the fire button
            if (TheSpecialists::CommonFunctions::AttackButtonPressed(m_pPlayer.m_afButtonPressed))
            {
                Shoot();
            }
            
            // Apply decay, if the player is holding the fire button, the weapon won't idle, and thus the spread won't decay
            m_fInaccuracyFactor = TheSpecialists::CommonFunctions::SpreadDecay(m_fInaccuracyFactor, m_fInaccuracyDecay);
            
            self.m_flNextPrimaryAttack  = g_Engine.time + fPRIMARY_ATTACK_DELAY;
            m_flAnimationCooldown       = g_Engine.time + 1.0;
        } // End of PrimaryAttack()

        //////////////////////////////
        // TS_RagingBull::Shoot     //
        // Function:                //
        //      Gun fire handling   //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Shoot()
        {
            int iRandomAnimation = 0;
            
            // Under the hood, m_rgAmmo is an array
            // But at this level, it is a function
            int iPrimaryAmmo = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType);
            
            // Determine if the player is above water
            if (TheSpecialists::CommonFunctions::IsAboveWater(m_pPlayer.pev.waterlevel))
            {
                // Determine if the weapon has bullets left in the magazine
                if (self.m_iClip > 0)
                {
                    iRandomAnimation = TheSpecialists::CommonFunctions::PickRandomElementFromListInt(arrAnimationList);
                    if (iRandomAnimation != -1)
                    {
                        self.SendWeaponAnim
                        (
                            iRandomAnimation, // Animation index
                            0               , // skiplocal (Don't know what this means)
                            0                 // body (probably model related 'body')
                        );
                    }
                    
                    // Set the third person animation so other players see you're shooting
                    m_pPlayer.SetAnimation(PLAYER_ATTACK1);
                    
                    // Set weapon volume and flash effect
                    m_pPlayer.m_iWeaponVolume   = NORMAL_GUN_VOLUME;
                    m_pPlayer.m_iWeaponFlash    = NORMAL_GUN_FLASH;

                    // Play the fire sound
                    TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitch(m_pPlayer, strSOUND_FIRE);
                    
                    Vector vecSrc	 = m_pPlayer.GetGunPosition();
                    Vector vecAiming = m_pPlayer.GetAutoaimVector(AUTOAIM_5DEGREES);
                    m_vecAccuracy    = vecSPREAD * m_fInaccuracyFactor;
                    
                    // Fire bullets from the player
                    // https://github.com/ValveSoftware/halflife/blob/e5815c34e2772a247a6843b67eab7c3395bdba66/dlls/cbase.h#L255
                    m_pPlayer.FireBullets
                    (
                        1                                                   , // ULONG cShots           - Number of bullets fired, anything more than 1 is useful for shotguns
                        vecSrc                                              , // Vector vecSrc          - Vector where the shot is originating from, but it's a vector so I don't know why this information isn't already stored in a single vector
                        vecAiming                                           , // Vector vecDirShooting  - Vector where the shot is going to go towards
                        m_vecAccuracy                                       , // Vector vecSpread       - Vector detailing how large the cone of randomness the bullets will randomly spread out
                        TheSpecialists::fMAXIMUM_FIRE_DISTANCE              , // float flDistance       - Maximum distance the bullet will scan for a hit
                        TheSpecialists::iWEAPON__PISTOL_MAGNUM__BULLET__TYPE, // int iBulletType        - Bullet type, not sure what this means
                        2                                                   , // int iTracerFreq = 4    - How frequently there will be bullet tracers, not sure what the scale is
                        m_iDamage                                             // int iDamage = 0        - How much damage the bullet will do
                    );
                    
                    // Decrement the magazine by one
                    self.m_iClip--;
                    
                    // This weapon does not have an empty fire animation, so not checking for empty clip
                    
                    TheSpecialists::CommonFunctions::WeaponRecoil(m_pPlayer, m_fRecoilMultiplier);
                    TheSpecialists::CommonFunctions::ApplyBulletDecal(m_pPlayer, vecSrc, vecAiming, m_vecAccuracy);
                    
                } // End of if (self.m_iClip > 0)
                else
                {
                    // The weapon magazine is empty
                    
                    TheSpecialists::CommonFunctions::PlayEmptySound(m_pPlayer, strSOUND_EMPTY);
                    
                } // End of else (of if (self.m_iClip > 0))
                
            } // End of if (m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD)
            else
            {
                // The player is under water
                
                TheSpecialists::CommonFunctions::PlayEmptySound(m_pPlayer, strSOUND_EMPTY);
                
            } // End of else (of if (m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD))

        } // End of Shoot()

        //////////////////////////////
        // TS_RagingBull::Reload    //
        // Function:                //
        //      Reload handler      //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Reload()
        {
            // Determine if the gun does not need to reload
            if (    (self.m_iClip == TheSpecialists::iWEAPON__RAGING_BULL__CLIP)
                 || (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0)    )
            {
                return;
            }
            
            self.DefaultReload(TheSpecialists::iWEAPON__RAGING_BULL__CLIP, Animations::RELOAD1, 1.5, 0);

            // Prevent the weapon idle animation from overriding the reload animation
            m_flAnimationCooldown = g_Engine.time + 2.5;

            // Set 3rd person reloading animation -Sniper
            BaseClass.Reload();
            
        } // End of Reload()
        
        //////////////////////////////////
        // TS_RagingBull::WeaponIdle    //
        // Function:                    //
        //      Weapon idle handler     //
        // Parameters:                  //
        //      None                    //
        // Return value:                //
        //      None                    //
        //////////////////////////////////
        void WeaponIdle()
        {
            int iAnimationIndex = 0;
            
            // Decrease the weapon spread while it is not being fired
            m_fInaccuracyFactor = TheSpecialists::CommonFunctions::SpreadDecay(m_fInaccuracyFactor, m_fInaccuracyDecay);
            
            // Failed attempt at recoil that doesn't involve view punching
            /*if (m_bRecoilActive)
            {
                m_bRecoilActive = TheSpecialists::CommonFunctions::WeaponRecoil(m_pPlayer, m_fInterpolator);
            }*/
            
            // Determine if the tilting animation has finished
            if (m_flAnimationCooldown < g_Engine.time)
            {
                iAnimationIndex = Animations::IDLE1;
                
                self.SendWeaponAnim(iAnimationIndex);
            } // End of if (m_flAnimationCooldown < g_Engine.time)
            
        } // End of WeaponIdle()
        
    } // End of class weapon_ts_raging_bull

    void Register_Weapon()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strCLASSNAME, strCLASSNAME);
        g_ItemRegistry.RegisterWeapon
        (
            strCLASSNAME                                        , // string - weapon name
            TheSpecialists::strSPRITE_METADATA_PATH             , // string - sprite metadata text file path
            TheSpecialists::strWEAPON__PISTOL_MAGNUM__AMMO_TYPE   // string - ammo type
        );
    }
} // End of namespace TS_RagingBull