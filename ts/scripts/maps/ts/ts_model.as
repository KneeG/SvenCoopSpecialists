//////////////////////////////////////////////////////////////////////////////
// File         : ts_model.as                                               //
// Author       : Knee                                                      //
// Description  : Mesh-based entities implementation from The Specialists   //
//////////////////////////////////////////////////////////////////////////////
#include "../../library/thespecialists"
/*
    Useful links:   https://www.svenmanor.com/entity-guide/entity_keyvalues
        +-------+-------------------+---------------------------------------------------+
        | Value |  State Name       |   Description                                     |
        +-------+-------------------+---------------------------------------------------+
        |   0   |  SOLID_NOT        |   No interaction with other objects.              |
        |   1   |  SOLID_TRIGGER    |   Notice touch, but don't block.                  |
        |   2   |  SOLID_BBOX       |   Touch on edge, block.                           |
        |   3   |  SOLID_SLIDEBOX   |   Touch on edge, but not if other is on ground.   |
        |   4   |  SOLID_BSP        |   BSP clip, touch on edge, block.                 |
        +-------+-------------------+---------------------------------------------------+
        
        +-------+---------------------------+-------------------------------------------------------------------------------------------------------+
        | Value |   State Name              |   Description                                                                                         |
        +-------+---------------------------+-------------------------------------------------------------------------------------------------------+
        |   0   |   MOVETYPE_NONE           |   Never moves.                                                                                        |
        |   3   |   MOVETYPE_WALK           |   Player only; moving on the ground.                                                                  |
        |   4   |   MOVETYPE_STEP           |   Gravity, special edge handling; monsters use this.                                                  |
        |   5   |   MOVETYPE_FLY            |   No gravity, but still collides with stuff.                                                          |
        |   6   |   MOVETYPE_TOSS           |   Receive gravity and collisions.                                                                     |
        |   7   |   MOVETYPE_PUSH           |   No clip to world; push and crush. (e.g. func_train)                                                 |
        |   8   |   MOVETYPE_NOCLIP         |   No gravity; no collisions; still handle velocity and angular velocity.                              |
        |   9   |   MOVETYPE_FLYMISSILE     |   Handled as if was larger for monsters. (Collides more easily)                                       |
        |   10  |   MOVETYPE_BOUNCE         |   Just like "Toss", but reflect velocity when contacting surfaces. (E.g. when dropping weapons/ammo)  |
        |   11  |   MOVETYPE_ BOUNCEMISSILE |   Like "Bounce", but without gravity.                                                                 |
        |   12  |   MOVETYPE_FOLLOW         |   Track movement of aiming entity.                                                                    |
        |   13  |   MOVETYPE_PUSHSTEP       |   BSP model that needs gravity and world collisions;                                                  |
        |       |                           |   uses nearest hull for world collision. (e.g. func_pushable)                                         |
        +-------+---------------------------+-------------------------------------------------------------------------------------------------------+
*/

namespace TS_Model
{
    const string strNAME = "ts_model";
    const string strNAMESPACE = "TS_Model::";
    /////////////////////////////////////////
    // ts_model class
    class ts_model : ScriptBaseEntity
    {    
        string m_strModel;
        
        //////////////////////////////
        // TS_Model::KeyValue       //
        // Function:                //
        //      Key value function  //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        bool KeyValue(const string& in strKey, const string& in strValue)
        {
            if(strKey == "model")
            {
                m_strModel = strValue;
                return true;
            }
            else
            {
                return BaseClass.KeyValue(strKey, strValue);
            }
        } // End of KeyValue()
        
        //////////////////////////
        // TS_Model::Spawn      //
        // Function:            //
        //      Spawn function  //
        // Parameters:          //
        //      None            //
        // Return value:        //
        //      None            //
        //////////////////////////
        void Spawn()
        {
            Precache();
            
            m_strModel = "models/scientist.mdl";
            
            self.pev.solid      = TheSpecialists::iTS_MODEL__DEFAULT__FLAG_SOLID    ;
            self.pev.movetype   = TheSpecialists::iTS_MODEL__DEFAULT__FLAG_MOVETYPE ;

            g_EntityFuncs.SetModel(self, m_strModel);
        } // End of Spawn()

        //////////////////////////////
        // TS_Model::Precache       //
        // Function:                //
        //      Precache function   //
        // Parameters:              //
        //      None                //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Precache()
        {
            g_Game.PrecacheModel(m_strModel);
        } // End of Precache()
        
        /*
        //////////////////////////////
        // TS_Model::Touch          //
        // Function:                //
        //      Collision function  //
        // Parameters:              //
        //      CBaseEntity@ pOther //
        // Return value:            //
        //      None                //
        //////////////////////////////
        void Touch(CBaseEntity@ pOther)
        {
            //ToDo: find a better way to check this
            if ((pOther.TakeDamage (pev, pev, 0, DMG_GENERIC)) != 1)
            {
                //If the entity doesn't take damage
                if (g_EngineFuncs.PointContents(pev.origin) == CONTENTS_WATER)
                {
                    //Go slower while in water
                    pev.velocity = waterSpeed; 
                }
                else 
                {
                    self.pev.solid = SOLID_NOT;
                    
                    self.pev.movetype = MOVETYPE_FLY;
                    
                    self.pev.velocity = Vector(0, 0, 0);

                    g_Utility.Sparks(pev.origin);

                    g_SoundSystem.EmitSoundDyn(self.edict(), CHAN_VOICE, "pitdrone/pit_drone_eat.wav", 1, ATTN_NORM, 0, PITCH_NORM);
                    
                    //Delete the nailed spike after a time for avoid having too many entities at the map
                    g_Scheduler.SetTimeout(@this, "RemoveSpike", 6.0);
                }
            }
            else 
            {
                // If it does take damage, deal damage to whatever it is
                pOther.TakeDamage (pev, pev, 20, DMG_POISON);
                
                g_EntityFuncs.Remove(self); 
            }
        } // End of Touch()
        
        void RemoveSpike()
        {
            g_EntityFuncs.Remove(self);
        }*/
    } // End of class ts_model

    void Register_Entity()
    {
        g_CustomEntityFuncs.RegisterCustomEntity(strNAMESPACE + strNAME, strNAME);
    }
} // End of namespace TS_Model