 /////////////////////////////////////////////////////////
// File         : weapon_ts_mossberg.as                 //
// Author       : Knee                                  //
// Description  : Mossberg from The Specialists Mod 3.0 //
//////////////////////////////////////////////////////////
#include "../../library/thespecialists"

/////////////////////////////////////
// TS_Mossberg namespace
namespace TS_Mossberg
{
    /////////////////////////////////////
    // Mossberg animation enumeration
    namespace Animations
    {
        const int IDLE1                 = 0 ;
        const int SHOOT1                = 1 ;
        const int PUMP1                 = 2 ;
        const int ADS_IDLE1             = 3 ;
        const int ADS_SHOOT1            = 4 ;
        const int ADS_PUMP1             = 5 ;
        const int ADS_PUMP2             = 6 ;
        const int DRAW1                 = 7 ;
        const int RELOAD_LIFT_GUN       = 8 ;
        const int RELOAD_LOAD_SHELL     = 9 ;
        const int RELOAD_PUMP           = 10;
        const int ADS_IN                = 11;
        const int ADS_OUT               = 12;
        const int ADS_RELOAD_PUMP       = 13;
        const int ADS_RELOAD_LOAD_SHELL = 14;
        const int ADS_RELOAD_LIFT_GUN   = 15;
    }
    
    // Reload state machine
    namespace ReloadState
    {
        const int RELOAD_START      = 0;
        const int RELOAD_LIFT_GUN   = 1;
        const int RELOAD_LOAD_SHELL = 2;
        const int RELOAD_LAST_SHELL = 3;
        const int RELOAD_END_PUMP   = 4;
        
        array<string> toStringArray = {
            "RELOAD_START"      ,
            "RELOAD_LIFT_GUN"   ,
            "RELOAD_LOAD_SHELL" ,
            "RELOAD_LAST_SHELL" ,
            "RELOAD_END_PUMP"
        };
    } // End of namespace ReloadState
    
    // Return constants
    const int               RETURN_SUCCESS              = 0;
    const int               RETURN_ERROR_NULL_POINTER   = -1;
    
    // Meta data
    const string            strNAME                 = "mossberg"             ;
    const string            strNAMESPACE            = "TS_Mossberg::"        ;
    const string            strCLASSNAME            = "weapon_ts_mossberg"   ;

    // Asset paths
    const string            strMODEL_P              = TheSpecialists::strMODEL_PATH + "shotguns/" + strNAME + "/p_" + strNAME + ".mdl";
    const string            strMODEL_V              = TheSpecialists::strMODEL_PATH + "shotguns/" + strNAME + "/v_" + strNAME + ".mdl";
    const string            strMODEL_W              = TheSpecialists::strMODEL_PATH + "shotguns/" + strNAME + "/w_" + strNAME + ".mdl";
    
    const string            strSPRITE_FILE          = TheSpecialists::strSPRITE_TS_PATH       + strNAME      + ".spr";
    const string            strSPRITE_TEXT_FILE     = TheSpecialists::strSPRITE_METADATA_PATH + strCLASSNAME + ".txt";
    
    const string            strSOUND_FIRE           = TheSpecialists::strSOUND_PATH + "shotguns/" + strNAME + "/" + TheSpecialists::strSHOTGUN__SOUND__FIRE     ;
    const string            strSOUND_PUMP           = TheSpecialists::strSOUND_PATH + "shotguns/" + strNAME + "/" + TheSpecialists::strSHOTGUN__SOUND__PUMP     ;
    const string            strSOUND_EMPTY          = TheSpecialists::strSOUND_PATH + TheSpecialists::strPISTOL__SOUND__EMPTY                                   ;
    
    // Create a list of animations to be played at random
    const array<int> arrShootAnimationList = {
        Animations::SHOOT1
    };
    
    const array<int> arrPumpAnimationList = {
        Animations::PUMP1
    };
    
    const array<int> arrADS_PumpAnimationList = {
        Animations::ADS_PUMP1,
        Animations::ADS_PUMP2
    };
    
    const array<int> arrADS_ShootAnimationList = {
        Animations::ADS_SHOOT1
    };
    
    const float             fHOLSTER_TIME           = TheSpecialists::fDEFAULT_HOSTER_TIME          ;
    const float             fNEXT_THINK             = TheSpecialists::fDEFAULT_NEXT_THINK           ;
    const float             fPRIMARY_ATTACK_DELAY   = TheSpecialists::fWEAPON__MOSSBERG__ATTACK_DELAY   ;
    const float             fSWING_DISTANCE         = TheSpecialists::fSWING_DISTANCE               ;
    const IGNORE_MONSTERS   eIGNORE_RULE            = TheSpecialists::eIGNORE_RULE                  ;
    const int               iDAMAGE                 = TheSpecialists::iWEAPON__MOSSBERG__DAMAGE         ;
    const Vector            vecSPREAD               = TheSpecialists::vecWEAPON__MOSSBERG__SPREAD       ;
    
    /////////////////////////////////////
    // Mossberg class
    class weapon_ts_mossberg : ScriptBasePlayerWeaponEntity
    {
        private CBasePlayer@ m_pPlayer          ; // Player reference pointer
        private int     m_iDamage               ; // Weapon damage
        private float   m_flAnimationCooldown   ; // Animation cooldown timer
        private int     m_iReloadState          ; // Keeps track of the reload shell progress
        private float   m_fReloadShellCooldown  ; // Time it takes to load a shell into the gun
        private float   m_fReadyToPump          ; // Animation cooldown timer after firing before pumping
        private bool    m_bADS                  ; // Aiming down sight flag
        private bool    m_bStartedPumping       ; // Flag to determine if the player has started pumping the gun
        private bool    m_bPumped               ; // Flag to determine if the gun has been pumped
        private bool    m_bReloadingShells      ; // Flag to determine if the player is currently reloading shells into the gun
        private float   m_fPumpDelay            ; // Cooldown timer between firing a gun and pumping the next shell
        private float   m_fPumpTime             ; // Time it takes to pump the weapon

        private float   m_fInaccuracyFactor     ; // Negatively affects weapon spread
        private float   m_fInaccuracyDelta      ; // How much inaccuracy
        private float   m_fInaccuracyDecay      ; // How much inaccuracy decreases over time
        
        Vector          m_vecAccuracy           ; // Current accuracy of the weapon
        
        TraceResult m_trHit                     ; // Keeps track of what is hit when the mossberg is swung
        
        //////////////////////////////////////////
        // TS_Mossberg::Spawn                   //
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
            
            // Initialize the pump cooldown to a default value
            m_fReadyToPump = g_Engine.time;
            
            // Initialize the reload state machine variable
            m_iReloadState = ReloadState::RELOAD_START;
            
            // Initialize the weapon as pumped and ready to fire
            m_bPumped = true;
            
            // Initialize the reloading shells flag, since it is assumed that the weapon is reloaded
            m_bReloadingShells = false;
            
            // Set the world model
            g_EntityFuncs.SetModel(self, self.GetW_Model(strMODEL_W));
            
            // No increasing spread from shotguns, so commenting these lines out
            /*
            m_fInaccuracyFactor = 1.0                                               ; // Scale factor added to weapon spread cone, negatively affects weapon spread
            m_fInaccuracyDelta  = 0.5                                               ; // How much inaccuracy increases per shot
            m_fInaccuracyDecay  = TheSpecialists::fWEAPON__PISTOL__INACCURACY_DECAY ; // How much inaccuracy decreases over time
            
            // Initialize accuracy
            m_vecAccuracy = vecSPREAD;*/
            
            // Set the clip size
            self.m_iClip = TheSpecialists::iWEAPON__MOSSBERG__CLIP;
            
            // Set the weapon damage
            self.m_flCustomDmg = m_iDamage;

            // Initialize gravity on the weapon
            self.FallInit();
        } // End of Spawn()

        //////////////////////////////////////////////////
        // TS_Mossberg::Precache                            //
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
            
            // This weapon has no magazine, so commenting these lines out
            // g_SoundSystem.PrecacheSound(strSOUND_CLIPIN         );
            // g_SoundSystem.PrecacheSound(strSOUND_CLIPOUT        );
            
            g_SoundSystem.PrecacheSound(strSOUND_FIRE           );
            g_SoundSystem.PrecacheSound(strSOUND_PUMP           );

            // This weapon has neither a suppressor nor a slide, so commenting these lines out
            // g_SoundSystem.PrecacheSound(strSOUND_FIRE_SILENCED  );
            // g_SoundSystem.PrecacheSound(strSOUND_SLIDEBACK      );
            
            g_SoundSystem.PrecacheSound(strSOUND_EMPTY          );
            
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE);
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_TEXT_FILE);
        } // End of Precache()

        //////////////////////////////////////////////////////////////////////////////
        // TS_Mossberg::GetItemInfo                                                     //
        // Function:                                                                //
        //      Sets the weapon metadata                                            //
        // Parameters:                                                              //
        //      ItemInfo& out info = [OUT] Object to write this weapon's metadata   //
        // Return value:                                                            //
        //      Bool                                                                //
        //////////////////////////////////////////////////////////////////////////////
        bool GetItemInfo(ItemInfo& out info)
        {
            info.iMaxClip   = TheSpecialists::iWEAPON__MOSSBERG__CLIP       ;
            info.iMaxAmmo1  = TheSpecialists::iWEAPON__MOSSBERG__AMMO1      ;
            info.iMaxAmmo2  = TheSpecialists::iWEAPON__MOSSBERG__AMMO2      ;
            info.iSlot      = TheSpecialists::iWEAPON__SLOT__RIFLE      ;
            info.iPosition  = TheSpecialists::iWEAPON__POSITION__MOSSBERG   ;
            info.iWeight    = TheSpecialists::iDEFAULT_WEIGHT           ;
            
            return true;
        } // End of GetItemInfo()
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_Mossberg::AddToPlayer                                                                 //
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
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Mossberg m_iPrimaryAmmoType: " + self.m_iPrimaryAmmoType + "\n");
                
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
        // TS_Mossberg::Deploy                                                                      //
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
        // TS_Mossberg::Holster                                                                     //
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
            
            // Tell the looping function to stop calling any of our mossberg functions
            SetThink(null);
        } // End of Holster()
        
        //////////////////////////////////////////////////
        // TS_Mossberg::PrimaryAttack                   //
        // Function:                                    //
        //      Performs the weapon's primary attack    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void PrimaryAttack()
        {
            // The fire button has been pressed, stop the player from continuous reloading
            if (m_bReloadingShells)
            {
                // Change the state machine for reloading to the end pump
                m_iReloadState = ReloadState::RELOAD_END_PUMP;
            } // End of if (m_bReloadingShells)
                
            // Determine if the player hasn't already started pressing the fire button
            // and if the player has pumped the weapon
            if (    (TheSpecialists::CommonFunctions::AttackButtonPressed(m_pPlayer.m_afButtonPressed))
                 && (m_bPumped)    )
            {
                Shoot();
                
                // Set the cooldown timer
                m_fPumpDelay = g_Engine.time + TheSpecialists::fWEAPON__MOSSBERG__PUMP_DELAY;
                
                // The weapon needs pumping, set this flag to false
                m_bPumped = false;
                
                self.m_flNextPrimaryAttack  = g_Engine.time + fPRIMARY_ATTACK_DELAY;
                m_flAnimationCooldown       = g_Engine.time + 1.0;
            }
            
        } // End of PrimaryAttack()
        
        //////////////////////////////////////////////////
        // TS_Mossberg::SecondaryAttack                 //
        // Function:                                    //
        //      Performs the weapon's secondary attack  //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void SecondaryAttack()
        {
            int iAnimationIndex = 0;
            
            // Toggle the flag
            m_bADS = !m_bADS;
            
            if (m_bADS)
            {
                iAnimationIndex = Animations::ADS_IN;
            }
            else
            {
                iAnimationIndex = Animations::ADS_OUT;
            }
            
            // Show the tilt animation
            self.SendWeaponAnim(iAnimationIndex);
            
            // Delay the next fire
            self.m_flNextPrimaryAttack  = g_Engine.time + 0.8;
            self.m_flNextSecondaryAttack= g_Engine.time + 0.8;
            self.m_flTimeWeaponIdle     = g_Engine.time + 2.0; // For some reason this doesn't work
            
            // Don't allow the weapon to go through any animation routines until we've finished going in our out of ADS
            m_flAnimationCooldown = g_Engine.time + 1.0;
        } // End of SecondaryAttack()
        
        //////////////////////////////
        // TS_Mossberg::Shoot       //
        // Function:                //
        //      Gun fire handling   //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Shoot()
        {
            int iAnimationIndex = 0;
            
            // Under the hood, m_rgAmmo is an array
            // But at this level, it is a function
            int iPrimaryAmmo = m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType);
            
            // Determine if the player is above water
            if (TheSpecialists::CommonFunctions::IsAboveWater(m_pPlayer.pev.waterlevel))
            {
                // Determine if the weapon has bullets left in the magazine
                if (self.m_iClip > 0)
                {
                    // Determine if the player is aimind down sight (ADS)
                    if (m_bADS)
                    {
                        iAnimationIndex = Animations::ADS_SHOOT1;
                    } // End of if (m_bADS)
                    else
                    {
                        iAnimationIndex = Animations::SHOOT1;
                    } // End of else (of if (m_bADS))
                    
                    self.SendWeaponAnim
                    (
                        iAnimationIndex , // Animation index
                        0               , // skiplocal (Don't know what this means)
                        0                 // body (probably model related 'body')
                    );
                    
                    // Set the third person animation so other players see you're shooting
                    m_pPlayer.SetAnimation(PLAYER_ATTACK1);
                    
                    // Set weapon volume and flash effect
                    m_pPlayer.m_iWeaponVolume   = NORMAL_GUN_VOLUME;
                    m_pPlayer.m_iWeaponFlash    = NORMAL_GUN_FLASH;

                    // Play the fire sound
                    TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitch(m_pPlayer, strSOUND_FIRE);
                    
                    Vector vecSrc    = m_pPlayer.GetGunPosition();
                    Vector vecAiming = m_pPlayer.GetAutoaimVector(AUTOAIM_5DEGREES);
                    m_vecAccuracy    = vecSPREAD * m_fInaccuracyFactor;
                    
                    // Fire bullets from the player
                    // https://github.com/ValveSoftware/halflife/blob/e5815c34e2772a247a6843b67eab7c3395bdba66/dlls/cbase.h#L255
                    m_pPlayer.FireBullets
                    (
                        TheSpecialists::iWEAPON__SHOTGUN__PELLET_COUNT  , // ULONG cShots           - Number of bullets fired, anything more than 1 is useful for shotguns
                        vecSrc                                          , // Vector vecSrc          - Vector where the shot is originating from, but it's a vector so I don't know why this information isn't already stored in a single vector
                        vecAiming                                       , // Vector vecDirShooting  - Vector where the shot is going to go towards
                        m_vecAccuracy                                   , // Vector vecSpread       - Vector detailing how large the cone of randomness the bullets will randomly spread out
                        TheSpecialists::fMAXIMUM_FIRE_DISTANCE          , // float flDistance       - Maximum distance the bullet will scan for a hit
                        TheSpecialists::iWEAPON__SHOTGUN__BULLET__TYPE  , // int iBulletType        - Bullet type, not sure what this means
                        4                                               , // int iTracerFreq = 4    - How frequently there will be bullet tracers, not sure what the scale is
                        m_iDamage                                         // int iDamage = 0        - How much damage the bullet will do
                    );
                    
                    // Decrement the magazine by one
                    self.m_iClip--;
                    
                    // No empty weapon animation so not checking for 0 clip
                    
                    TheSpecialists::CommonFunctions::WeaponRecoil(m_pPlayer);
                    TheSpecialists::CommonFunctions::CreatePelletDecals(m_pPlayer, vecSrc, vecAiming, m_vecAccuracy, TheSpecialists::iWEAPON__SHOTGUN__PELLET_COUNT);
                    
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

        //////////////////////////
        // TS_Mossberg::Reload      //
        // Function:            //
        //      Reload handler  //
        // Parameters:          //
        //      None            //
        // Return value:        //
        //      None            //
        //////////////////////////
        void Reload()
        {
            int iAnimationIndex     = 0;
            int iShellsReloading    = 1; // Number of shells reloaded at a time
            
            // Debug printing
            // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Mossberg Reload() reload state: " + ReloadState::toStringArray[m_iReloadState] + "\n");
            // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "Mossberg Reload() Current clip: " + self.m_iClip + "\n");
            
            // Take action based on the reload progress
            switch (m_iReloadState)
            {
                case ReloadState::RELOAD_START:
                {
                    // Determine if there is any room to reload any shells
                    if (    (self.m_iClip < TheSpecialists::iWEAPON__MOSSBERG__CLIP)
                         && (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) > 0)    )
                    {
                        // Start reloading the gun by lifting the gun to load shells
                        m_iReloadState = ReloadState::RELOAD_LIFT_GUN;
                        
                        m_bReloadingShells = true;
                        
                    } // End of if (self.m_iClip < TheSpecialists::iWEAPON__MOSSBERG__CLIP)
                    
                    break;
                    
                } // End of case ReloadState::RELOAD_START
                
                case ReloadState::RELOAD_LIFT_GUN:
                {
                    // Transition to the load bullets state
                    m_iReloadState = ReloadState::RELOAD_LOAD_SHELL;
                    
                    // Determine if the player is aiming down sight (ADS)
                    if (m_bADS)
                    {
                        // Play the lift gun animation
                        self.SendWeaponAnim(Animations::ADS_RELOAD_LIFT_GUN);
                    }
                    else
                    {
                        // Play the lift gun animation
                        self.SendWeaponAnim(Animations::RELOAD_LIFT_GUN);
                    }
                    
                    // Delay the reload shell animation while the lift animation is played
                    m_fReloadShellCooldown = g_Engine.time + TheSpecialists::fDEFAULT_SHELL_LOAD_TIME;
                    
                    break;
                    
                } // End of case ReloadState::RELOAD_LIFT_GUN
                
                case ReloadState::RELOAD_LOAD_SHELL:
                {
                    // Determine if the gun is finished reloading
                    if (self.m_iClip == TheSpecialists::iWEAPON__MOSSBERG__CLIP)
                    {
                        // Transition to the end pump state
                        m_iReloadState = ReloadState::RELOAD_LAST_SHELL;
                    }
                    
                    // Determine if the shell load time has expired
                    if (m_fReloadShellCooldown < g_Engine.time)
                    {
                        // DefaultReload causes the entire magazie to be reloaded at once
                        // which is NOT how tube-based shotgun reloading is supposed to work
                        // so I'm commenting the next lines out
                        // Reload the weapon
                        // self.DefaultReload(iShellsReloading, Animations::RELOAD_LOAD_SHELL, 1.5, 0);
                        
                        // Increase the magazine by one
                        self.m_iClip++;
                        
                        // Decrease the reserve magazine by one
                        m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType, m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) - 1);
                        
                        // Determine if the player is aiming down sight (ADS)
                        if (m_bADS)
                        {
                            // Perform the reload animation
                            self.SendWeaponAnim(Animations::ADS_RELOAD_LOAD_SHELL);
                        }
                        else
                        {
                            // Perform the reload animation
                            self.SendWeaponAnim(Animations::RELOAD_LOAD_SHELL);
                        }
                        
                        // Reset the shell cooldown timer to allow the reload animation time to play
                        m_fReloadShellCooldown = g_Engine.time + TheSpecialists::fDEFAULT_SHELL_LOAD_TIME;
                            
                    } // End of if (TheSpecialists::fDEFAULT_SHELL_LOAD_TIME < g_Engine.time)
                    
                    break;
                    
                } // End of case ReloadState::RELOAD_LOAD_SHELL
                
                case ReloadState::RELOAD_LAST_SHELL:
                {
                    // Determine if the reload shell cooldown timer has expired
                    if (m_fReloadShellCooldown < g_Engine.time)
                    {
                        // Transition to the end pump state
                        m_iReloadState = ReloadState::RELOAD_END_PUMP;
                        
                        // Reset the shell cooldown timer to allow the reload animation time to play
                        m_fReloadShellCooldown = g_Engine.time + TheSpecialists::fDEFAULT_SHELL_LOAD_TIME;
                    } // End of if (m_fReloadShellCooldown < g_Engine.time)
                    
                    break;
                    
                } // End of case ReloadState::RELOAD_LAST_SHELL
                
                case ReloadState::RELOAD_END_PUMP:
                {
                    // Reset the reload state machine to the start
                    m_iReloadState = ReloadState::RELOAD_START;
                    
                    // Determine if the player is aiming down sight (ADS)
                    if (m_bADS)
                    {
                        // Perform the animation
                        self.SendWeaponAnim(Animations::ADS_RELOAD_PUMP);
                    }
                    else
                    {
                        // Perform the animation
                        self.SendWeaponAnim(Animations::RELOAD_PUMP);
                    }
                    
                    // Set the reloading shells flag to false
                    m_bReloadingShells = false;
                    
                    break;
                    
                } // End of case ReloadState::RELOAD_END_PUMP
                
            } // End of switch (m_iReloadState)

            // Prevent the weapon idle animation from overriding the reload animation
            m_flAnimationCooldown = g_Engine.time + 2.5;

            // Set 3rd person reloading animation -Sniper
            BaseClass.Reload();
            
        } // End of Reload()
        
        //////////////////////////////
        // TS_Mossberg::PumpHandle  //
        // Function:                //
        //      Handles pump action //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void PumpHandle()
        {
            int iAnimationIndex = 0;
            
            // Determine if the cooldown timer for pumping the next shell is still in effect
            if (m_fPumpDelay > g_Engine.time)
            {
                // The weapon is not ready to be pumped
                // Do nothing
                
            } // End of if (m_fPumpDelay > g_Engine.time)
            else
            {
                // The cooldown timer has elapsed, or the weapon is idling normally
                
                // Determine if the weapon needs to be pumped
                if (!m_bPumped)
                {
                    // Determine if the player has not yet started pumping the weapon
                    if (!m_bStartedPumping)
                    {
                        // Set the started pumping flag to true
                        m_bStartedPumping = true;
                        
                        // Start the pumping timer
                        m_fPumpTime = g_Engine.time + TheSpecialists::fWEAPON__MOSSBERG__PUMP_TIME;
                        
                        // Pick a random pump animation
                        iAnimationIndex = TheSpecialists::CommonFunctions::PickRandomElementFromListInt(arrPumpAnimationList);
                        
                        // Play the pump sound
                        TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitch(m_pPlayer, strSOUND_PUMP);
                        
                        // Play the pump animation
                        self.SendWeaponAnim(iAnimationIndex);
                        
                    } // End of if (!m_bStartedPumping)
                    else
                    {
                        // Determine if the time to pump has expired
                        if (m_fPumpTime < g_Engine.time)
                        {
                            // The time to finish pumping the gun has expired
                            
                            // Set the pumped flag to true
                            m_bPumped = true;
                            
                            // Reset the pumping flag
                            m_bStartedPumping = false;
                            
                        } // End of if (m_fPumpTime < g_Engine.time)
                            
                    } // End of else (of if (!m_bStartedPumping))
                        
                } // End of if (!m_bPumped)
                    
            } // End of else (of if (m_fPumpDelay > g_Engine.time))
            
        } // End of PumpHandle()
        
        //////////////////////////////
        // TS_Mossberg::WeaponIdle  //
        // Function:                //
        //      Weapon idle handler //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void WeaponIdle()
        {
            int iAnimationIndex = 0;
            
            // Determine if the weapon is currently reloading
            if (m_bReloadingShells)
            {
                self.Reload();
            }
            else
            {
                // Handle the pump action
                PumpHandle();
                
            } // End of else (of if (m_bReloadingShells))
            
            // Decrease the weapon spread while it is not being fired
            m_fInaccuracyFactor = TheSpecialists::CommonFunctions::SpreadDecay(m_fInaccuracyFactor, m_fInaccuracyDecay);
            
            // Failed attempt at recoil that doesn't involve view punching
            /*if (m_bRecoilActive)
            {
                m_bRecoilActive = TheSpecialists::CommonFunctions::WeaponRecoil(m_pPlayer, m_fInterpolator);
            }*/
            
                
            // Determine if the current animation has finished
            if (    (m_flAnimationCooldown < g_Engine.time)
                 && (!m_bPumped             )
                 && (!m_bStartedPumping     )    )
            {
                // Determine of the player is aiming down sight (ADS)
                if (m_bADS)
                {
                    iAnimationIndex = Animations::ADS_IDLE1;
                }
                else
                {
                    iAnimationIndex = Animations::IDLE1;
                }
                
                self.SendWeaponAnim(iAnimationIndex);
                
            } // End of if (m_flAnimationCooldown < g_Engine.time)
            
        } // End of WeaponIdle()
        
    } // End of class weapon_ts_mossberg

    void Register_Weapon()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strCLASSNAME, strCLASSNAME);
        g_ItemRegistry.RegisterWeapon
        (
            strCLASSNAME                                    , // string - weapon name
            TheSpecialists::strSPRITE_METADATA_PATH         , // string - sprite metadata text file path
            TheSpecialists::strWEAPON__SHOTGUN__AMMO_TYPE     // string - ammo type
        );
    }
} // End of namespace TS_Mossberg