//////////////////////////////////////////////////////////////////////////////////
// Author       : Knee                                                          //
// Description  : Custom barney script, detonates itself when close to an enemy //
//////////////////////////////////////////////////////////////////////////////////

#include "../../library/monsters/barney"

namespace BarneyBomber
{
    const string BARNEY_BOMBER_NAME = "monster_barney_bomber";
    
    class monster_barney_bomber : ScriptBaseMonsterEntity
    {
        ////////////////////////////////////////
        // Class constants
        
        // Asset path constants
        private string          m_strMODEL          = BarneyBase::strMODEL                  ; // Path to the npc model
        private string          m_strSOUND_SHOOT1   = BarneyBase::strSOUND_SHOOT1           ; // Path to the npc firing sound
        
        // NPC configuration constants
        private string          m_strDISPLAYNAME    = "Barney Bomber"                       ; // Default displayname
        private int             m_iMAGAZINE_SIZE    = BarneyBase::iMAGAZINE_SIZE            ; // Maximum number of bullets in barney's gun between reloads
        private int             m_iMAXIMUM_HEALTH   = BarneyBase::iMAXIMUM_HEALTH           ; // Default maximum health
        private int             m_eBLOOD_COLOR      = BarneyBase::eBLOOD_COLOR              ; // Default blood color
        private int             m_eBODY_TYPE        = BarneyBase::BodyType::PISTOL_HOLSTERED; // Default body type
        private int             m_eMOVE_TYPE        = BarneyBase::eMOVE_TYPE                ; // Default move type
        private int             m_eSOLID            = BarneyBase::eSOLID                    ; // Default solid state
        private int             m_eClassification   = BarneyBase::eCLASSIFICATION           ; // Default classification, based on the "classify" state
        private MONSTERSTATE    m_eMONSTER_STATE    = BarneyBase::eMONSTER_STATE            ; // Default monster state
        private float           m_fTURN_SPEED       = BarneyBase::fTURN_SPEED               ; // Default turn speed, degrees per second
        private int             m_iMAXIMUM_RANGE    = 256                                   ; // Maximum distance Barney can shoot from
        private int             m_iBrassShell       = 0                                     ; // Model ID of the shell that comes from barney's gun

        private int             m_iExplosionDamage  = 500                                   ; // Damage the explosive will do

        /////////////////////////////////////////
        // Class variables
        private int             m_iMagazine         = 0                                     ; // Current magazine
        private bool            m_bGun_holstered    = true                                  ; // Gun holstered flag
        private float           m_fNextFearScream   = 0.0                                   ; // Tracks when the next time barney can play a fear sound
        private float           m_fScreamCooldown   = 1.0                                   ; // Cooldown between screams
        private float           m_fPainTime         = 0.0                                   ; // Tracks when the next time barney can play a pain sound

        //////////////////////////////////////////////////
        // BarneyBomber.Spawn                           //
        // Function:                                    //
        //      Initializes the entity after it spawns  //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void Spawn()
        {
            // Precache the model and other components
            Precache();

            // Log the current ally status
            g_Game.AlertMessage(at_console, "Barney Bomber Ally Status: %1\n", self.IsPlayerAlly() ? 1 : 0);
            
            // Setting self.SetPlayerAlly does not work in this case
            if (self.IsPlayerAlly())
            {
                m_eClassification = CLASS_HUMAN_MILITARY;
            }
            else
            {
                m_eClassification = CLASS_HUMAN_PASSIVE;
            }

            // Apply the configuration constants to the entity
            g_EntityFuncs.DispatchKeyValue  (self.edict(), "displayname", m_strDISPLAYNAME );
            g_EntityFuncs.SetModel          (self, m_strMODEL);
            self.SetBodygroup               (m_eBODY_TYPE, 1);
            
            self.pev.health         = m_iMAXIMUM_HEALTH ;
            self.m_bloodColor       = m_eBLOOD_COLOR    ;
            
            self.pev.movetype       = m_eMOVE_TYPE      ;
            self.pev.solid          = m_eSOLID          ;
            self.m_MonsterState     = m_eMONSTER_STATE  ;
            
            // Set the entity size
            g_EntityFuncs.SetSize(pev, VEC_HUMAN_HULL_MIN, VEC_HUMAN_HULL_MAX);
            
            // Field of view width
            self.m_flFieldOfView = 0.5;
            
            // Set barney's monster capabilities
            self.m_afCapability = bits_CAP_HEAR | bits_CAP_TURN_HEAD | bits_CAP_DOORS_GROUP | bits_CAP_USE_TANK;
            
            // Add the ability to run away from creatures
            self.m_fCanFearCreatures = true;
            
            // Start with a full magazine
            m_iMagazine = m_iMAGAZINE_SIZE;
            
            // Set next scream time
            m_fNextFearScream = g_Engine.time;
            
            // Set next pain time
            m_fPainTime = g_Engine.time;
            
            // Configure the FollowerUse callback function
            SetUse(UseFunction(FollowerUse));
            
            // Initialize the monster
            self.MonsterInit();
            
        } // End of BarneyBomber.Spawn()

        //////////////////////////////
        // BarneyBomber.Precache    //
        // Function:                //
        //      Precaching function //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Precache()
        {
            // Call parent precache function
            BaseClass.Precache();
            
            // Precache the NPC model
            g_Game.PrecacheModel("models/barney.mdl");
            g_Game.PrecacheModel("models/barnabus.mdl");
            
            // Precache the bomb
            g_Game.PrecacheModel("models/w_satchel.mdl");

            // Precache barney sounds
            g_SoundSystem.PrecacheSound("barney/ba_attack2.wav");
            g_SoundSystem.PrecacheSound("barney/ba_pain1.wav");
            g_SoundSystem.PrecacheSound("barney/ba_pain2.wav");
            g_SoundSystem.PrecacheSound("barney/ba_pain3.wav");
            g_SoundSystem.PrecacheSound("barney/ba_die1.wav");
            g_SoundSystem.PrecacheSound("barney/ba_die2.wav");
            g_SoundSystem.PrecacheSound("barney/ba_die3.wav");

            g_SoundSystem.PrecacheSound("barney/down.wav");
            g_SoundSystem.PrecacheSound("barney/hey.wav");
            g_SoundSystem.PrecacheSound("barney/aghh.wav");

            m_iBrassShell = g_Game.PrecacheModel("models/shell.mdl");
            
        } // End of BarneyBomber.Precache()

        //////////////////////////////
        // BarneyBomber.Classify    //
        // Function:                //
        //      Classify key getter //
        // Return value:            //
        //      int                 //
        //////////////////////////////
        int	Classify()
        {
            return m_eClassification; 
        } // End of BarneyBomber.Classify()

        //////////////////////////////
        // BarneyBomber.SetYawSpeed //
        // Function:                //
        //      Yaw speed setter    //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void SetYawSpeed()
        {
            self.pev.yaw_speed = m_fTURN_SPEED; 
        } // End of BarneyBomber.SetYawSpeed()
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        // BarneyBomber.HandleAnimEvent                                                                     //
        // Function:                                                                                        //
        //      Animation Event handler for the monster class                                               //
        // Parameter:                                                                                       //
        //      MonsterEvent@ pEvent = [IN] Animation ID coming from the model's current animation sequence //
        // Return value:                                                                                    //
        //      Schedule@                                                                                   //
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        void HandleAnimEvent(MonsterEvent@ pEvent)
        {
            switch (pEvent.event)
            {
                case BarneyBase::AnimationEvent::DRAW:
                {
                    // Set the model's body type to pistol drawn
                    self.SetBodygroup(BarneyBase::BodyType::PISTOL_DRAWN, 1);
                    
                    m_bGun_holstered = false;
                    
                    break;
                } // End of case BarneyBase::AnimationEvent::DRAW
                
                case BarneyBase::AnimationEvent::SHOOT:
                {
                    // Grab a reference to the enemy
                    CBaseEntity@ cbEnemy = self.m_hEnemy;
                    
                    // Determine if the reference to the enemy is null
                    if (cbEnemy !is null)
                    {
                        // The enemy reference is valid
                        
                        // Begin firing at the enemy
                        //ShootGun();
                        Explode();
                    }
                    
                    break;
                } // End of case BarneyBase::AnimationEvent::SHOOT
                
                case BarneyBase::AnimationEvent::HOLSTER:
                {
                    // Set the model's body type to holstered
                    self.SetBodygroup(BarneyBase::BodyType::PISTOL_HOLSTERED, 1);
                    
                    m_bGun_holstered = true;
                    
                    break;
                }
                
                default:
                {
                    BaseClass.HandleAnimEvent(pEvent);
                    
                    break; 
                }
                
            } // End of switch (pEvent.event) 
            
        } // End of void HandleAnimEvent(MonsterEvent@ pEvent)
        
        //////////////////////////////////////
        // BarneyBomber::FearScream         //
        // Function:                        //
        //      Handles barney's screaming  //
        // Parameters:                      //
        //      None                        //
        // Return value:                    //
        //      None                        //
        //////////////////////////////////////
        void FearScream()
        {
            if( m_fNextFearScream < g_Engine.time )
            {
                switch (Math.RandomLong(0, 2))
                {
                    case 0: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/down.wav" , 1, ATTN_NORM, 0, PITCH_NORM); break;}
                    case 1: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/aghh.wav" , 1, ATTN_NORM, 0, PITCH_NORM); break;}
                    case 2: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/hey.wav"  , 1, ATTN_NORM, 0, PITCH_NORM); break;}
                }
    
                m_fNextFearScream = g_Engine.time + m_fScreamCooldown;
            }
        } // End of BarneyBomber::FearScream()
        
        //////////////////////////////////////////
        // BarneyBomber::PainSound              //
        // Function:                            //
        //      Handles barney's pain sounds    //
        // Parameters:                          //
        //      None                            //
        // Return value:                        //
        //      None                            //
        //////////////////////////////////////////
        void PainSound()
        {
            if(g_Engine.time < m_fPainTime)
            {
                return;
            }
            
            m_fPainTime = g_Engine.time + Math.RandomFloat(0.5, 0.75);
            switch (Math.RandomLong(0,2))
            {
                case 0: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_pain1.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;}
                case 1: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_pain2.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;}
                case 2: { g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_pain3.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;}
            }
        } // End of BarneyBomber::PainSound()
        
        //////////////////////////////////////////
        // BarneyBomber::DeathSound             //
        // Function:                            //
        //      Handles barney's death sounds   //
        // Parameters:                          //
        //      None                            //
        // Return value:                        //
        //      None                            //
        //////////////////////////////////////////
        void DeathSound()
        {
            switch (Math.RandomLong(0,2))
            {
                case 0: g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_die1.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;
                case 1: g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_die2.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;
                case 2: g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_VOICE, "barney/ba_die3.wav", 1, ATTN_NORM, 0, PITCH_NORM); break;
            }
        } // End of BarneyBomber::DeathSound()
        
        //////////////////////////////////////////////
        // BarneyBomber::GetScheduleOfType          //
        // Function:                                //
        //      Handles barney's task scheduling    //
        // Parameters:                              //
        //      int Type = [IN] Schedule ID         //
        // Return value:                            //
        //      Schedule@                           //
        //////////////////////////////////////////////
        /*Schedule@ GetScheduleOfType(int iType)
        {		
            Schedule@ psched;

            switch (iType)
            {
                case SCHED_ARM_WEAPON:
                {
                    if (self.m_hEnemy.IsValid())
                    {
                        // face enemy, then draw
                        return BarneyBase::slBarneyEnemyDraw; 
                    }
                    
                    break;
                } // End of case SCHED_ARM_WEAPON

                // Hook these to make a looping schedule
                case SCHED_TARGET_FACE:
                {
                    // call base class default so that barney will talk
                    // when 'used' 
                    @psched = BaseClass.GetScheduleOfType(iType);
                    
                    if (psched is Schedules::slIdleStand)
                    {
                        // override this for different target face behavior
                        return BarneyBase::slBaFaceTarget; 
                    }
                    else
                    {
                        return psched;
                    }

                } // End of case SCHED_TARGET_FACE
                
                case SCHED_RELOAD:
                {
                    return BarneyBase::slBaReloadQuick; //Immediately reload.
                } // End of case SCHED_RELOAD

                //case SCHED_BARNEY_RELOAD:
                //{
                //    return BarneyBase::slBaReload;
                //} // End of case SCHED_BARNEY_RELOAD

                case SCHED_TARGET_CHASE:
                {
                    return BarneyBase::slBaFollow;
                } // End of case SCHED_TARGET_CHASE

                case SCHED_IDLE_STAND:
                {
                    // call base class default so that scientist will talk
                    // when standing during idle
                    @psched = BaseClass.GetScheduleOfType(iType);

                    if (psched is Schedules::slIdleStand)
                    {
                        return BarneyBase::slIdleBaStand;// just look straight ahead.
                    }
                    else
                    {
                        return psched;
                    }
                    
                } // End of case SCHED_IDLE_STAND
                
            } // End of switch (iType)

            return BaseClass.GetScheduleOfType(iType);
        } // End of BarneyBomber::GetScheduleOfType()
        */
        
        //////////////////////////////////////////////////
        // BarneyBomber::Explode                        //
        // Function:                                    //
        //      Explode function for barney             //
        // Parameters                                   //
        //      TraceResult*    pTrace          = [IN]  //
        //      int             bitsDamageType  = [IN]  //
        // Return value:                                //
        //      None                                    //
        //////////////////////////////////////////////////
        void Explode()
        {
            Vector vecDown = Vector(0, 0, -1);
            CBaseEntity@ gGrenade = g_EntityFuncs.ShootContact(self.pev, self.pev.origin, vecDown);
            g_EntityFuncs.SetModel(gGrenade, "models/w_satchel.mdl");
            gGrenade.pev.dmg = m_iExplosionDamage; // Custom damage
        }
        
        //////////////////////////////////////////////
        // BarneyBomber.GetSchedule                 //
        // Function:                                //
        //      Handles the scheduling for Barney   //
        // Return value:                            //
        //      Schedule@                           //
        //////////////////////////////////////////////
        Schedule@ GetSchedule()
        {
            float flEnemyDistance = 0.0;
            
            // Determine if I have detected a sound
            if (self.HasConditions(bits_COND_HEAR_SOUND))
            {
                CSound@ pSound = self.PBestSound();

                // Determine if this sound has a valid reference
                // and if this sound is the sound of danger
                if (     (pSound !is null)
                     && ((pSound.m_iType & bits_SOUND_DANGER) != 0)    )
                {
                    // Play the fear sound
                    FearScream();
                    
                    // Return the running from danger schedule
                    return self.GetScheduleOfType(SCHED_TAKE_COVER_FROM_BEST_SOUND);
                }
            }
            
            // Determine if I have detected a dead enemy
            if (self.HasConditions( bits_COND_ENEMY_DEAD))
            {
                // Have the monster speak about the dead enemy
                self.PlaySentence("BA_KILL", 4, VOL_NORM, ATTN_NORM);
            }
            
            // Determine what the schedule is based on the monster state
            switch (self.m_MonsterState)
            {
                case MONSTERSTATE_IDLE:
                {
                    return BaseClass.GetSchedule();
                } // End of case MONSTERSTATE_IDLE
                
                case MONSTERSTATE_COMBAT:
                {
                    // Determine if the enemy is dead
                    if (self.HasConditions(bits_COND_ENEMY_DEAD))
                    {
                        // The enemy is dead, let the parent class do what it's supposed to
                        return BaseClass.GetSchedule();
                    } // End of if (self.HasConditions(bits_COND_ENEMY_DEAD))
                    else
                    {
                        // The enemy is NOT dead, proceed with attacking
                        
                        // Determine if a new enemy is detected
                        // and if the enemy is an even match for barney
                        if (    (self.HasConditions(bits_COND_NEW_ENEMY     ))
                             && (self.HasConditions(bits_COND_LIGHT_DAMAGE  ))   )
                        {
                            // React with a small flinch
                            return self.GetScheduleOfType(SCHED_SMALL_FLINCH);
                        }
                        
                        // Determine if barney's gun is holstered
                        if (m_bGun_holstered)
                        {
                            // Start arming self with pistol
                            return self.GetScheduleOfType(SCHED_ARM_WEAPON);
                        }
                        
                        // Determine if barney's gun is empty
                        if( self.HasConditions(bits_COND_NO_AMMO_LOADED))
                        {
                            // Start reloading
                            //return self.GetScheduleOfType(SCHED_BARNEY_RELOAD);
                            return self.GetScheduleOfType(SCHED_RELOAD);
                        }
                        
                        // Determine if this entity CAN use ranged attacks
                        if (self.HasConditions(bits_COND_CAN_RANGE_ATTACK1))
                        {
                            // Get a reference to the enemy entity
                            CBaseEntity@ cbeEnemy = self.m_hEnemy;
                            
                            // Determine if the reference to the enemy is NOT null
                            if (cbeEnemy !is null)
                            {
                                // Entity is a valid reference
                                
                                // Determine if the enemy is within range
                                flEnemyDistance = (pev.origin - cbeEnemy.pev.origin).Length();
                                if (flEnemyDistance < m_iMAXIMUM_RANGE)
                                {
                                    // The enemy is within firing range
                                    return BaseClass.GetScheduleOfType(SCHED_RANGE_ATTACK1);
                                }
                                else
                                {
                                    // Start screaming
                                    FearScream();
                                    
                                    // The enemy is outside firing range, begin chasing
                                    return BaseClass.GetScheduleOfType(SCHED_CHASE_ENEMY);
                                }
                            } // End of if (ent !is null)
                            else
                            {
                                // Reference to the enemy is null, let the parent class handle this
                                return BaseClass.GetSchedule();
                                
                            } // End of else (of if (ent !is null))
                            
                        } // End of if (self.HasConditions(bits_COND_CAN_RANGE_ATTACK1))
                        else
                        {
                            // Not in range, follow the enemy
                            return BaseClass.GetScheduleOfType(SCHED_CHASE_ENEMY);
                            
                        } // End of else (of if (self.HasConditions(bits_COND_CAN_RANGE_ATTACK1)))
                        
                    } // End of else (of if (self.HasConditions(bits_COND_ENEMY_DEAD)))
                    
                } // End of case MONSTERSTATE_COMBAT
                
                default:
                {
                    return BaseClass.GetSchedule();
                }
                
            } // End of switch (self.m_MonsterState)
            
            return BaseClass.GetSchedule();
            
        } // End of Schedule@ GetSchedule()
        
        //////////////////////////////////////////////////////////////////////////
        // BarneyBomber::FollowerUse                                            //
        // Function:                                                            //
        //      Handling for following players when used                        //
        // Parameters:                                                          //
        //      CBaseEntity@    pActivator  = [IN] Entity that used barney      //
        //      CBaseEntity@    pCaller     = [IN] Not sure what this refers to //
        //      USE_TYPE        useType     = [IN] Not sure what this refers to //
        //      float           flValue     = [IN] Not sure what this refers to //
        // Return value:                                                        //
        //      None                                                            //
        //////////////////////////////////////////////////////////////////////////
        void FollowerUse( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue )
        {
            self.FollowerPlayerUse( pActivator, pCaller, useType, flValue );
            
            CBaseEntity@ pTarget = self.m_hTargetEnt;
            
            if (pTarget is pActivator)  { g_SoundSystem.PlaySentenceGroup(self.edict(), "BA_OK"     , 1.0, ATTN_NORM, 0, PITCH_NORM); }
            else                        { g_SoundSystem.PlaySentenceGroup(self.edict(), "BA_WAIT"   , 1.0, ATTN_NORM, 0, PITCH_NORM); }
            
        } // End of BarneyBomber::FollowerUse()
        
    } // End of class monster_barney_bomber : ScriptBaseMonsterEntity

    void RegisterBarneyBomber()
    {
        g_CustomEntityFuncs.RegisterCustomEntity("BarneyBomber::monster_barney_bomber", BARNEY_BOMBER_NAME);
    }
} // End of namespace BARNEY_BOMBER