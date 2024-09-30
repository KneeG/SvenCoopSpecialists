//////////////////////////////////////////////////////////
// File         : weapon_ts_ak47.as                     //
// Author       : Knee                                  //
// Description  : AK47 from The Specialists Mod 3.0    //
//////////////////////////////////////////////////////////
#include "../../library/thespecialists"

/////////////////////////////////////
// TS_AK47 namespace
namespace TS_AK47
{
    /////////////////////////////////////
    // AK47 animation enumeration
    namespace Animations
    {
        const int IDLE1         = 0;
        const int RELOAD1       = 1;
        const int DRAW1         = 2;
        const int SHOOT1        = 3;
        const int ADS_IDLE1     = 4;
        const int ADS_IN        = 5;
        const int ADS_OUT       = 6;
        const int ADS_SHOOT1    = 7;
        const int ADS_RELOAD1   = 8;
    }
    
    // Return constants
    const int               RETURN_SUCCESS              =  0;
    const int               RETURN_ERROR_NULL_POINTER   = -1;
    
    // Meta data
    const string            strNAME                 = "ak47"             ;
    const string            strNAMESPACE            = "TS_AK47::"        ;
    const string            strCLASSNAME            = "weapon_ts_ak47"   ;

    // Asset paths
    const string            strMODEL_P              = TheSpecialists::strMODEL_PATH + "rifles/" + strNAME + "/p_" + strNAME + ".mdl";
    const string            strMODEL_V              = TheSpecialists::strMODEL_PATH + "rifles/" + strNAME + "/v_" + strNAME + ".mdl";
    const string            strMODEL_W              = TheSpecialists::strMODEL_PATH + "rifles/" + strNAME + "/w_" + strNAME + ".mdl";
    
    const string            strSPRITE_FILE          = TheSpecialists::strSPRITE_TS_PATH       + strNAME      + ".spr";
    const string            strSPRITE_TEXT_FILE     = TheSpecialists::strSPRITE_METADATA_PATH + strCLASSNAME + ".txt";
    
    const string            strSOUND_CLIPIN         = TheSpecialists::strSOUND_PATH + "rifles/" + strNAME + "/" + TheSpecialists::strRIFLE__SOUND__CLIPIN       ;
    const string            strSOUND_CLIPOUT        = TheSpecialists::strSOUND_PATH + "rifles/" + strNAME + "/" + TheSpecialists::strRIFLE__SOUND__CLIPOUT      ;
    const string            strSOUND_FIRE           = TheSpecialists::strSOUND_PATH + "rifles/" + strNAME + "/" + TheSpecialists::strRIFLE__SOUND__FIRE         ;
    const string            strSOUND_FIRE_SILENCED  = TheSpecialists::strSOUND_PATH + "rifles/" + strNAME + "/" + TheSpecialists::strRIFLE__SOUND__FIRE_SILENCED;
    const string            strSOUND_SLIDEBACK      = TheSpecialists::strSOUND_PATH + "rifles/" + strNAME + "/" + TheSpecialists::strRIFLE__SOUND__SLIDEBACK    ;
    const string            strSOUND_EMPTY          = TheSpecialists::strSOUND_PATH + TheSpecialists::strSMG__SOUND__EMPTY                                      ;
    
    // Create a list of animations to be played at random
    const array<int> arrAnimationList = {
        Animations::SHOOT1
    };
    
    const array<int> arrADSAnimationList = {
        Animations::ADS_SHOOT1
    };
    
    const float             fHOLSTER_TIME           = TheSpecialists::fDEFAULT_HOSTER_TIME              ;
    const float             fNEXT_THINK             = TheSpecialists::fDEFAULT_NEXT_THINK               ;
    const float             fPRIMARY_ATTACK_DELAY   = TheSpecialists::fWEAPON__AK47__ATTACK_DELAY       ;
    const float             fSWING_DISTANCE         = TheSpecialists::fSWING_DISTANCE                   ;
    const IGNORE_MONSTERS   eIGNORE_RULE            = TheSpecialists::eIGNORE_RULE                      ;
    const int               iDAMAGE                 = TheSpecialists::iWEAPON__AK47__DAMAGE             ;
    const Vector            vecSPREAD               = TheSpecialists::vecWEAPON__AK47__SPREAD           ;
    const float             fRECOIL_MULTIPLIER      = TheSpecialists::fWEAPON__AK47__RECOIL_MULTIPLIER  ;
    
    /////////////////////////////////////
    // AK47 class
    class weapon_ts_ak47 : ScriptBasePlayerWeaponEntity
    {
        private CBasePlayer@ m_pPlayer          ; // Player reference pointer
        private int     m_iDamage               ; // Weapon damage
        private float   m_flAnimationCooldown   ; // Animation cooldown timer, helps prevent the weapon from going to idle animations while the weapon is being tilted
        private bool    m_bADS                  ; // Flag for aiming down site
        
        private float   m_fInaccuracyFactor     ; // Negatively affects weapon spread
        private float   m_fInaccuracyDelta      ; // How much inaccuracy
        private float   m_fInaccuracyDecay      ; // How much inaccuracy decreases over time
        
        Vector          m_vecAccuracy           ; // Current accuracy of the weapon
        
        TraceResult     m_trHit                 ; // Keeps track of what is hit when the ak47 is swung
        
        //////////////////////////////////////////
        // TS_AK47::Spawn                       //
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
            
            m_fInaccuracyFactor = 1.0                                               ; // Scale factor added to weapon spread cone, negatively affects weapon spread
            m_fInaccuracyDelta  = TheSpecialists::fWEAPON__PISTOL__INACCURACY_DELTA ; // How much inaccuracy increases per shot
            m_fInaccuracyDecay  = TheSpecialists::fWEAPON__PISTOL__INACCURACY_DECAY ; // How much inaccuracy decreases over time
            
            // Initialize accuracy
            m_vecAccuracy = vecSPREAD;
            
            // Set the world model
            g_EntityFuncs.SetModel(self, self.GetW_Model(strMODEL_W));
            
            // Set the clip size
            self.m_iClip = TheSpecialists::iWEAPON__AK47__CLIP;
            
            // Set the weapon damage
            self.m_flCustomDmg = m_iDamage;

            // Initialize gravity on the weapon
            self.FallInit();
        } // End of Spawn()

        //////////////////////////////////////////////////
        // TS_AK47::Precache                            //
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
            g_SoundSystem.PrecacheSound(strSOUND_SLIDEBACK      );
            
            g_SoundSystem.PrecacheSound(strSOUND_EMPTY          );
            
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_FILE);
            g_Game.PrecacheGeneric(TheSpecialists::strSPRITE_ROOT + strSPRITE_TEXT_FILE);
        } // End of Precache()

        //////////////////////////////////////////////////////////////////////////////
        // TS_AK47::GetItemInfo                                                     //
        // Function:                                                                //
        //      Sets the weapon metadata                                            //
        // Parameters:                                                              //
        //      ItemInfo& out info = [OUT] Object to write this weapon's metadata   //
        // Return value:                                                            //
        //      Bool                                                                //
        //////////////////////////////////////////////////////////////////////////////
        bool GetItemInfo(ItemInfo& out info)
        {
            info.iMaxClip		= TheSpecialists::iWEAPON__AK47__CLIP       ;
            info.iMaxAmmo1		= TheSpecialists::iWEAPON__AK47__AMMO1      ;
            info.iMaxAmmo2		= TheSpecialists::iWEAPON__AK47__AMMO2      ;
            info.iSlot			= TheSpecialists::iWEAPON__SLOT__RIFLE      ;
            info.iPosition		= TheSpecialists::iWEAPON__POSITION__AK47   ;
            info.iWeight		= TheSpecialists::iDEFAULT_WEIGHT           ;
            
            return true;
        } // End of GetItemInfo()
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_AK47::AddToPlayer                                                                     //
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
                // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "AK47 m_iPrimaryAmmoType: " + self.m_iPrimaryAmmoType + "\n");
                
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
        // TS_AK47::Deploy                                                                          //
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
        // TS_AK47::Holster                                                                         //
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
            
            // Tell the game loop to stop calling any of our ak47 functions
            SetThink(null);
        } // End of Holster()
        
        //////////////////////////////////////////////////
        // TS_AK47::PrimaryAttack                       //
        // Function:                                    //
        //      Performs the weapon's primary attack    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void PrimaryAttack()
        {
            // Fully automatic SMG so no need to check for any button presses
            Shoot();
            
            // Apply decay, if the player is holding the fire button, the weapon won't idle, and thus the spread won't decay
            m_fInaccuracyFactor = TheSpecialists::CommonFunctions::SpreadDecay(m_fInaccuracyFactor, m_fInaccuracyDecay);
            
            self.m_flNextPrimaryAttack  = g_Engine.time + fPRIMARY_ATTACK_DELAY;
            m_flAnimationCooldown       = g_Engine.time + 1.0;
        } // End of PrimaryAttack()
        
        //////////////////////////////////////////////////
        // TS_AK47::SecondaryAttack                     //
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
            
            // Don't allow the weapon to go through any animation routines until we've finished tilting
            m_flAnimationCooldown = g_Engine.time + 1.0;
        } // End of SecondaryAttack()

        //////////////////////////////
        // TS_AK47::Shoot           //
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
            if (m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD)
            {
                // Determine if the weapon has bullets left in the magazine
                if (self.m_iClip > 0)
                {
                    // Determine if a random animation can be picked
                    if (m_bADS)
                    {
                        iRandomAnimation = TheSpecialists::CommonFunctions::PickRandomElementFromListInt(arrADSAnimationList);
                    }
                    else
                    {
                        iRandomAnimation = TheSpecialists::CommonFunctions::PickRandomElementFromListInt(arrAnimationList);
                    }
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
                    TheSpecialists::CommonFunctions::PlaySoundDynamicWithVariablePitchOverChannel(m_pPlayer, CHAN_WEAPON, strSOUND_FIRE);
                    
                    Vector vecSrc	 = m_pPlayer.GetGunPosition();
                    Vector vecAiming = m_pPlayer.GetAutoaimVector(AUTOAIM_5DEGREES);
                    m_vecAccuracy    = vecSPREAD * m_fInaccuracyFactor;
                    
                    // Fire bullets from the player
                    // https://github.com/ValveSoftware/halflife/blob/e5815c34e2772a247a6843b67eab7c3395bdba66/dlls/cbase.h#L255
                    m_pPlayer.FireBullets
                    (
                        1                                           , // ULONG cShots           - Number of bullets fired, anything more than 1 is useful for shotguns
                        vecSrc                                      , // Vector vecSrc          - Vector where the shot is originating from, but it's a vector so I don't know why this information isn't already stored in a single vector
                        vecAiming                                   , // Vector vecDirShooting  - Vector where the shot is going to go towards
                        m_vecAccuracy                               , // Vector vecSpread       - Vector detailing how large the cone of randomness the bullets will randomly spread out
                        TheSpecialists::fMAXIMUM_FIRE_DISTANCE      , // float flDistance       - Maximum distance the bullet will scan for a hit
                        TheSpecialists::iWEAPON__RIFLE__BULLET__TYPE, // int iBulletType        - Bullet type, not sure what this means
                        2                                           , // int iTracerFreq = 4    - How frequently there will be bullet tracers, not sure what the scale is
                        iDAMAGE                                       // int iDamage = 0        - How much damage the bullet will do
                    );
                    
                    // Decrement the magazine by one
                    self.m_iClip--;
                    
                    // No empty weapon animation so not checking for 0 clip
                    
                    TheSpecialists::CommonFunctions::WeaponRecoil(m_pPlayer, fRECOIL_MULTIPLIER);
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

        //////////////////////////
        // TS_AK47::Reload      //
        // Function:            //
        //      Reload handler  //
        // Parameters:          //
        //      None            //
        // Return value:        //
        //      None            //
        //////////////////////////
        void Reload()
        {
            // Determine if the gun does not need to reload
            if (    (self.m_iClip == TheSpecialists::iWEAPON__AK47__CLIP)
                 || (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0)    )
            {
                return;
            }
            
            // Determine if the weapon is tilted sideways
            if (m_bADS)                
            {
                self.DefaultReload(TheSpecialists::iWEAPON__AK47__CLIP, Animations::ADS_RELOAD1, 1.5, 0);
            }
            else
            {
                self.DefaultReload(TheSpecialists::iWEAPON__AK47__CLIP, Animations::RELOAD1, 1.5, 0);
            }
            
            // Prevent the weapon idle animation from overriding the reload animation
            m_flAnimationCooldown = g_Engine.time + 3.5;

            // Set 3rd person reloading animation -Sniper
            BaseClass.Reload();
        } // End of Reload()
        
        //////////////////////////
        // TS_AK47::WeaponIdle  //
        // Function:            //
        //      Reload handler  //
        // Parameters:          //
        //      None            //
        // Return value:        //
        //      None            //
        //////////////////////////
        void WeaponIdle()
        {
            int iAnimationIndex = 0;
            
            // Decrease the weapon spread while it is not being fired
            m_fInaccuracyFactor = TheSpecialists::CommonFunctions::SpreadDecay(m_fInaccuracyFactor, m_fInaccuracyDecay);
            
            // Determine if the tilting animation has finished
            if (m_flAnimationCooldown < g_Engine.time)
            {
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
        
    } // End of class weapon_ts_ak47

    void Register_Weapon()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strCLASSNAME, strCLASSNAME);
        g_ItemRegistry.RegisterWeapon
        (
            strCLASSNAME                                , // string - weapon name
            TheSpecialists::strSPRITE_METADATA_PATH     , // string - sprite metadata text file path
            TheSpecialists::strWEAPON__RIFLE__AMMO_TYPE   // string - ammo type
        );
    }
} // End of namespace TS_AK47