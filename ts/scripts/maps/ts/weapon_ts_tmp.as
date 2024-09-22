//////////////////////////////////////////////////////////////////////////////
// File         : weapon_ts_tmp.as                                      //
// Author       : Knee                                                      //
// Description  : TMP from The Specialists Mod 3.0                     //
//////////////////////////////////////////////////////////////////////////////

#include "../../library/weapons/crowbar"
#include "../../library/thespecialists"

/////////////////////////////////////
// TS_TMP namespace
namespace TS_TMP
{
    /////////////////////////////////////
    // TMP animation enumeration
    namespace Animations
    {
        const int IDLE1             = 0 ;
        const int RELOAD1           = 1 ;
        const int DRAW1             = 2 ;
        const int SHOOT1            = 3 ;
        const int SHOOT2            = 4 ; // Haven't seen any meaningful difference between this and SHOOT1 based on my inspection
        const int TILT_SIDEWAYS     = 5 ; 
        const int TILT_UPRIGHT      = 6 ;
        const int IDLE_SIDEWAYS1    = 7 ;
        const int SHOOT_SIDEWAYS1   = 8 ;
        const int SHOOT_SIDEWAYS2   = 9 ;
        const int RELOAD_SIDEWAYS1  = 10;
    }
    
    // Return constants
    const int               RETURN_SUCCESS              =  0;
    const int               RETURN_ERROR_NULL_POINTER   = -1;
    
    // Meta data
    const string            strNAME                 = "tmp"             ;
    const string            strNAMESPACE            = "TS_TMP::"        ;
    const string            strCLASSNAME            = "weapon_ts_tmp"   ;

    // Asset paths
    const string            strMODEL_P              = TheSpecialists::strMODEL_PATH + "smgs/" + strNAME + "/p_" + strNAME + ".mdl";
    const string            strMODEL_V              = TheSpecialists::strMODEL_PATH + "smgs/" + strNAME + "/v_" + strNAME + ".mdl";
    const string            strMODEL_W              = TheSpecialists::strMODEL_PATH + "smgs/" + strNAME + "/w_" + strNAME + ".mdl";
    
    const string            strSPRITE_FILE          = TheSpecialists::strSPRITE_TS_PATH       + strNAME      + ".spr";
    const string            strSPRITE_TEXT_FILE     = TheSpecialists::strSPRITE_METADATA_PATH + strCLASSNAME + ".txt";
    
    const string            strSOUND_CLIPIN         = TheSpecialists::strSOUND_PATH + "smgs/" + strNAME + "/" + TheSpecialists::strSMG__SOUND__CLIPIN         ;
    const string            strSOUND_CLIPOUT        = TheSpecialists::strSOUND_PATH + "smgs/" + strNAME + "/" + TheSpecialists::strSMG__SOUND__CLIPOUT        ;
    const string            strSOUND_FIRE           = TheSpecialists::strSOUND_PATH + "smgs/" + strNAME + "/" + TheSpecialists::strSMG__SOUND__FIRE           ;
    const string            strSOUND_FIRE_SILENCED  = TheSpecialists::strSOUND_PATH + "smgs/" + strNAME + "/" + TheSpecialists::strSMG__SOUND__FIRE_SILENCED  ;
    const string            strSOUND_SLIDEBACK      = TheSpecialists::strSOUND_PATH + "smgs/" + strNAME + "/" + TheSpecialists::strSMG__SOUND__SLIDEBACK      ;
    const string            strSOUND_EMPTY          = TheSpecialists::strSOUND_PATH + TheSpecialists::strSMG__SOUND__EMPTY                                       ;
    
    // Create a list of animations to be played at random
    const array<int> arrAnimationList = {
        Animations::SHOOT1,
        Animations::SHOOT2
    };
    
    const array<int> arrSidewaysAnimationList = {
        Animations::SHOOT_SIDEWAYS1,
        Animations::SHOOT_SIDEWAYS2
    };
    
    const float             fHOLSTER_TIME           = TheSpecialists::fDEFAULT_HOSTER_TIME      ;
    const float             fNEXT_THINK             = TheSpecialists::fDEFAULT_NEXT_THINK       ;
    const float             fPRIMARY_ATTACK_DELAY   = TheSpecialists::fWEAPON__TMP__ATTACK_DELAY;
    const float             fSWING_DISTANCE         = TheSpecialists::fSWING_DISTANCE           ;
    const IGNORE_MONSTERS   eIGNORE_RULE            = TheSpecialists::eIGNORE_RULE              ;
    const int               iDAMAGE                 = TheSpecialists::iWEAPON__TMP__DAMAGE      ;
    
    /////////////////////////////////////
    // TMP class
    class weapon_ts_tmp : ScriptBasePlayerWeaponEntity
    {
        private CBasePlayer@ m_pPlayer      ; // Player reference pointer
        private int m_iDamage               ; // Weapon damage
        private bool m_bSilenced            ; // Silenced flag
        private bool m_bSideways            ; // Sideways flag
        private bool m_bTilting             ; // Tilting flag, helps prevent the weapon from going to idle animations while the weapon is being tilted
        private float m_flAnimationCooldown ; // Animation cooldown timer, helps prevent the weapon from going to idle animations while the weapon is being tilted
        
        TraceResult m_trHit                 ; // Keeps track of what is hit when the tmp is swung
        
        //////////////////////////////////////////
        // TS_TMP::Spawn                        //
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
            
            // Start the weapon facing upright
            m_bSideways = false;
            
            // Set the world model
            g_EntityFuncs.SetModel(self, self.GetW_Model(strMODEL_W));
            
            // Set the clip size
            self.m_iClip = TheSpecialists::iWEAPON__CLIP__TMP;
            
            // Set the weapon damage
            self.m_flCustomDmg = m_iDamage;

            // Initialize gravity on the weapon
            self.FallInit();
        } // End of Spawn()

        //////////////////////////////////////////////////
        // TS_TMP::Precache                             //
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
        // TS_TMP::GetItemInfo                                                  //
        // Function:                                                                //
        //      Sets the weapon metadata                                            //
        // Parameters:                                                              //
        //      ItemInfo& out info = [OUT] Object to write this weapon's metadata   //
        // Return value:                                                            //
        //      Bool                                                                //
        //////////////////////////////////////////////////////////////////////////////
        bool GetItemInfo(ItemInfo& out info)
        {
            info.iMaxClip		= TheSpecialists::iWEAPON__CLIP__TMP    ;
            info.iMaxAmmo1		= TheSpecialists::iWEAPON__AMMO1__TMP   ;
            info.iMaxAmmo2		= TheSpecialists::iWEAPON__AMMO2__TMP   ;
            info.iSlot			= TheSpecialists::iWEAPON__SLOT__SMG    ;
            info.iPosition		= TheSpecialists::iWEAPON__POSITION__TMP;
            info.iWeight		= TheSpecialists::iDEFAULT_WEIGHT       ;
            
            return true;
        } // End of GetItemInfo()
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        // TS_TMP::AddToPlayer                                                                      //
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
                g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "TMP m_iPrimaryAmmoType: " + self.m_iPrimaryAmmoType + "\n");
                
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
        // TS_TMP::Deploy                                                                           //
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
        // TS_TMP::Holster                                                                          //
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
            
            // Tell the game loop to stop calling any of our tmp functions
            SetThink(null);
        } // End of Holster()
        
        //////////////////////////////////////////////////
        // TS_TMP::PrimaryAttack                        //
        // Function:                                    //
        //      Performs the weapon's primary attack    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void PrimaryAttack()
        {
            Shoot();
            
            self.m_flNextPrimaryAttack  = g_Engine.time + fPRIMARY_ATTACK_DELAY;
            m_flAnimationCooldown       = g_Engine.time + 1.0;
        } // End of PrimaryAttack()
        
        //////////////////////////////////////////////////
        // TS_TMP::SecondaryAttack                      //
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
            m_bSideways = !m_bSideways;
            
            if (m_bSideways)
            {
                iAnimationIndex = Animations::TILT_SIDEWAYS;
            }
            else
            {
                iAnimationIndex = Animations::TILT_UPRIGHT;
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
        // TS_TMP::Shoot            //
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
                    if (m_bSideways)
                    {
                        iRandomAnimation = TheSpecialists::CommonFunctions::PickRandomElementFromListInt(arrSidewaysAnimationList);
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
                    PlaySoundDynamicWithVariablePitch(strSOUND_FIRE);
                    
                    Vector vecSrc	 = m_pPlayer.GetGunPosition();
                    Vector vecAiming = m_pPlayer.GetAutoaimVector(AUTOAIM_5DEGREES);
                    
                    // Fire bullets from the player
                    // https://github.com/ValveSoftware/halflife/blob/e5815c34e2772a247a6843b67eab7c3395bdba66/dlls/cbase.h#L255
                    m_pPlayer.FireBullets
                    (
                        1                                       , // ULONG cShots           - Number of bullets fired, anything more than 1 is useful for shotguns
                        vecSrc                                  , // Vector vecSrc          - Vector where the shot is originating from, but it's a vector so I don't know why this information isn't already stored in a single vector
                        vecAiming                               , // Vector vecDirShooting  - Vector where the shot is going to go towards
                        VECTOR_CONE_6DEGREES                    , // Vector vecSpread       - Vector detailing how large the cone of randomness the bullets will randomly spread out
                        TheSpecialists::fMAXIMUM_FIRE_DISTANCE  , // float flDistance       - Maximum distance the bullet will scan for a hit
                        BULLET_PLAYER_MP5                       , // int iBulletType        - Bullet type, not sure what this means
                        2                                       , // int iTracerFreq = 4    - How frequently there will be bullet tracers, not sure what the scale is
                        iDAMAGE                                   // int iDamage = 0        - How much damage the bullet will do
                    );
                    
                    // Decrement the magazine by one
                    self.m_iClip--;
                    
                    // Determine if the magazine is empty, and there is no ammo left in reserve
                    if (    (0 == self.m_iClip)
                         && (0 == iPrimaryAmmo)    )
                    {
                        // Indicate to the user that the weapon is completely empty
                        m_pPlayer.SetSuitUpdate("!HEV_AMO0", false, 0);
                    }
                    
                    // View punch as a way to simulate recoil
                    // TODO:
                    //      Move the players cursor instead of applying a visual transformation
                    m_pPlayer.pev.punchangle.x = Math.RandomLong(-2, 2);
                    
                    ApplyBulletDecal(vecSrc, vecAiming);
                    
                } // End of if (self.m_iClip > 0)
                else
                {
                    // The weapon magazine is empty
                    
                    self.PlayEmptySound();
                    
                } // End of else (of if (self.m_iClip > 0))
                
            } // End of if (m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD)
            else
            {
                // The player is under water
                
                self.PlayEmptySound();
                
            } // End of else (of if (m_pPlayer.pev.waterlevel != WATERLEVEL_HEAD))

        } // End of Shoot()
        
        //////////////////////////////////////////////////
        // TS_TMP::ApplyBulletDecal                     //
        // Function:                                    //
        //      Handles bullet hole decal generation    //
        // Parameters:                                  //
        //      None                                    //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void ApplyBulletDecal(Vector vecSrc, Vector vecAiming)
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
            g_Utility.TraceLine(vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr);
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

        //////////////////////////
        // TS_TMP::Reload       //
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
            if (    (self.m_iClip == TheSpecialists::iWEAPON__CLIP__TMP)
                 || (m_pPlayer.m_rgAmmo(self.m_iPrimaryAmmoType) <= 0)    )
            {
                return;
            }
            
            // Determine if the weapon is tilted sideways
            if (m_bSideways)                
            {
                self.DefaultReload(TheSpecialists::iWEAPON__CLIP__TMP, Animations::RELOAD_SIDEWAYS1, 1.5, 0);
            }
            else
            {
                self.DefaultReload(TheSpecialists::iWEAPON__CLIP__TMP, Animations::RELOAD1, 1.5, 0);
            }
            
            // Prevent the weapon idle animation from overriding the reload animation
            m_flAnimationCooldown = g_Engine.time + 2.5;

            // Set 3rd person reloading animation -Sniper
            BaseClass.Reload();
        } // End of Reload()
        
        //////////////////////////
        // TS_TMP::WeaponIdle   //
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
            
            // Determine if the tilting animation has finished
            if (m_flAnimationCooldown < g_Engine.time)
            {            
                if (m_bSideways)
                {
                    iAnimationIndex = Animations::IDLE_SIDEWAYS1;
                }
                else
                {
                    iAnimationIndex = Animations::IDLE1;
                }
                
                self.SendWeaponAnim(iAnimationIndex);
            } // End of if (m_flTiltTimer < g_Engine.time)
            
        } // End of WeaponIdle()

        //////////////////////////////////////
        // TS_TMP::PlayEmptySound           //
        // Function:                        //
        //      Plays the dry fire sound    //
        // Parameters:                      //
        //      None                        //
        // Return value:                    //
        //      None                        //
        //////////////////////////////////////
        void PlayEmptySound()
        {
            PlaySoundDynamicWithVariablePitch(strSOUND_EMPTY);
        } // End of PlayEmptySound()
        
        //////////////////////////////////////////////////////////////////////////////////////
        // TS_TMP::PlaySoundDynamicWithVariablePitch                                        //
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
            // g_EngineFuncs.ClientPrintf(m_pPlayer, print_console, "PlaySoundDynamicWithVariablePitch: strSoundPath=" + strSoundPath + "\n");
            
            PlaySoundDynamic(strSoundPath, iPitch);
        } // End of PlaySoundDynamicWithVariablePitch()
        
        //////////////////////////////////////////////////////////////////////////
        // TS_TMP::PlaySoundDynamic                                             //
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
                m_pPlayer.edict()                       , // edict_t@ entity
                TheSpecialists::scDEFAULT_CHANNEL       , // SOUND_CHANNEL channel
                strSoundPath                            , // const string& in szSample
                TheSpecialists::fDEFAULT_VOLUME         , // float flVolume
                TheSpecialists::fDEFAULT_ATTENUATION    , // float flAttenuation
                0                                       , // int iFlags = 0
                iPitch                                    // int iPitch = PITCH_NORM
                                                          // int target_ent_unreliable = 0
            );
        } // End of PlaySoundDynamic()
        
    } // End of class weapon_ts_tmp

    void Register_Weapon()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strCLASSNAME, strCLASSNAME);
        g_ItemRegistry.RegisterWeapon
        (
            strCLASSNAME                                , // string - weapon name
            TheSpecialists::strSPRITE_METADATA_PATH     , // string - sprite metadata text file path
            TheSpecialists::strWEAPON__SMG__AMMO_TYPE     // string - ammo type
        );
    }
} // End of namespace TS_TMP