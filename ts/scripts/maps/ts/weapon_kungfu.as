/*
 * The Specialists Kung Fu replica by Knee
 * Feel free to improve it if you want.
 *
 */
enum kungfu_e
{
	KUNGFU_IDLE = 0,
	KUNGFU_DRAW,
	KUNGFU_PUNCHLEFT,
	KUNGFU_PUNCHRIGHT,
	KUNGFU_BLOCK,
	KUNGFU_KICK,
	KUNGFU_SIDEKICK,
	KUNGFU_UPPERCUT,
	KUNGFU_SPINKICK,
	KUNGFU_BACKKICK,
	KUNGFU_PUNCHRIGHT2
};

class weapon_kungfu : ScriptBasePlayerWeaponEntity
{
	private CBasePlayer@ m_pPlayer = null;
	string BLOCK_SND = "player/block.wav";
	string MISS_SND = "player/closecombat.wav";
	string HIT_SND = "player/kungfuhit.wav";
	float m_iLastDuck;
	float m_iSlowTime;
	float m_iNextBlock;
	float m_iNextSwing;
	float m_iLastSwing;
	bool m_bDuckState;
	int currfunction;
	int currstate;
	int laststate;
	int m_iSwing;
	TraceResult m_trHit;
	string V_MODEL = "models/ts/melee/v_melee.mdl";
	string P_MODEL = "models/ball.mdl";	// placeholder
	string W_MODEL = V_MODEL;
	void Spawn()
	{
		self.Precache();
		g_EntityFuncs.SetModel( self, self.GetW_Model( "models/ts/melee/v_melee.mdl") );
		self.m_iClip			= -1;
		self.m_flCustomDmg		= self.pev.dmg;

		self.FallInit();// get ready to fall down.
	}

	void Precache()
	{
		self.PrecacheCustomModels();

		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( W_MODEL );
		g_SoundSystem.PrecacheSound( "player/block.wav" );
		g_SoundSystem.PrecacheSound( "player/closecombat.wav" );
		g_SoundSystem.PrecacheSound( "player/kungfuhit.wav" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1		= -1;
		info.iMaxAmmo2		= -1;
		info.iMaxClip		= 0; // 0 so SecondaryAttack() and Reload() functions are available
		info.iSlot		= 1;
		info.iPosition		= 1;
		info.iWeight		= 10;
		return true;
	}
	
	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		if( !BaseClass.AddToPlayer( pPlayer ) )
			return false;
			
		@m_pPlayer = pPlayer;

		return true;
	}

	bool Deploy()
	{
		m_bDuckState = true;
		m_iSwing = 0;
		currfunction = 0;
		m_iNextBlock = g_Engine.time;
		return self.DefaultDeploy( self.GetV_Model( V_MODEL ), self.GetP_Model( P_MODEL ), KUNGFU_DRAW, "onehanded");
	}
	float WeaponTimeBase()
	{
		return g_Engine.time;
	}
	void Holster( int skiplocal /* = 0 */ )
	{
		self.m_fInReload = false;// cancel any reload in progress.

		m_pPlayer.m_flNextAttack = WeaponTimeBase() + 0.5; 
	}
	void WeaponIdle()
	{
		// Uppercut
		if (m_pPlayer.pev.flags & FL_DUCKING != 0)
			m_iLastDuck = g_Engine.time;
		else
			m_bDuckState = true;
		if (g_Engine.time > m_iLastSwing)
			m_iSwing = 0;
		if (g_Engine.time > m_iSlowTime)
			m_pPlayer.pev.maxspeed = 300;
		return;
	}
	void Reload()
	{
		// Meant to block attacks (melee attacks, specifically)
		if (m_iNextBlock > g_Engine.time)
			return;
		if (g_Engine.time < m_iLastSwing)
			return;
			
		m_iNextBlock = g_Engine.time + 0.5;
	
		self.SendWeaponAnim( KUNGFU_BLOCK );	
		m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 

		g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, BLOCK_SND, 1, ATTN_NORM );
		
	}
	void PrimaryAttack()
	{
		// Uppercut
		if (m_pPlayer.pev.flags & FL_DUCKING != 0)
			m_iLastDuck = g_Engine.time;
		else
			m_bDuckState = true;

		// reset kick combo if punch interrupts it
		if (currfunction == 1)
			m_iSwing = 0;
		currfunction = 0;
		int currAnim = 0;
		float flDamage = 20;

		if (g_Engine.time < m_iLastDuck && m_bDuckState)
		{
			m_iNextSwing = 0.45;
			flDamage = 30;
			currAnim = KUNGFU_UPPERCUT;
			m_iSwing = 0;
			m_bDuckState = false;
		}
		else if (m_pPlayer.pev.flags & FL_ONGROUND == 0)
		{
			currAnim = KUNGFU_PUNCHRIGHT;
			m_iNextSwing = 0.50;
			m_iSwing = 0;
			flDamage = 25;
		}
		else
		{
			switch (m_iSwing)
			{
				case 0:
				m_iNextSwing = 0.45;
				currAnim = KUNGFU_PUNCHRIGHT2;
				flDamage = 20;
				break;
		
				case 4:
				m_iNextSwing = 0.55;
				m_iSwing = 0;
				currAnim = KUNGFU_UPPERCUT;
				flDamage = 15;
				break;

				default:
				m_iNextSwing = 0.23;
				currAnim = KUNGFU_PUNCHLEFT;
				flDamage = 30;
			}
		}
		m_iLastSwing = g_Engine.time + 0.6;
		m_iSwing++;

		Attack(currAnim, flDamage, 0);
		self.m_flNextPrimaryAttack = g_Engine.time + m_iNextSwing;
		self.m_flNextSecondaryAttack = g_Engine.time + m_iNextSwing;
		return;
	}
	void SecondaryAttack()
	{
		Vector2D speed = m_pPlayer.pev.velocity.Make2D(); // velocity in z direction does not matter
		int addvelocity = 0;
		
		// reset punch combo if kick is next
		if (currfunction == 0)
			m_iSwing = 0;
		currfunction = 1;

		int currAnim = 0;
		float flDamage = 25;
		int rand = Math.RandomLong(0, 1);

		// crouch kick takes priority
		if (m_pPlayer.pev.flags & FL_DUCKING != 0 && m_pPlayer.pev.flags & FL_ONGROUND != 0)
		{
			currAnim = KUNGFU_SPINKICK;
			flDamage = 35;
			m_iSwing = 0;
			m_iNextSwing = 1.0;
			m_pPlayer.pev.maxspeed = 190;
			m_iSlowTime = g_Engine.time + 0.5;
			addvelocity = 1;
		}
		// back kick
		else if (MovingBackwards() && speed.Length() > 10)
		{
			currAnim = KUNGFU_BACKKICK;
			flDamage = 80;
			m_iSwing = 0;
			m_iNextSwing = 1.0;
			m_iSlowTime = g_Engine.time + 0.5;
			m_pPlayer.pev.maxspeed = 150;
			addvelocity = 1;
		}
		// dragon kick
		else if (m_pPlayer.pev.flags & FL_ONGROUND == 0 && m_pPlayer.pev.flags & FL_DUCKING != 0 
		 && speed.Length() > 100)
		{
			currAnim = KUNGFU_SIDEKICK;
			flDamage = 45;
			m_iSwing = 0;
			m_iNextSwing = 1.0;
			addvelocity = 1;
		}
		//kick
		else
		{
			switch (m_iSwing)
			{
				case 0:
				m_iNextSwing = 0.45;
				if (rand == 0)
					currAnim = KUNGFU_KICK;
				else
					currAnim = KUNGFU_SPINKICK;
				flDamage = 25;
				m_pPlayer.pev.maxspeed = 190;
				m_iSlowTime = g_Engine.time + 0.5;
				break;
			
				case 4:
				m_iNextSwing = 0.50;
				m_iSwing = 0;
				currAnim = KUNGFU_SPINKICK;
				flDamage = 20;
				m_pPlayer.pev.maxspeed = 190;
				m_iSlowTime = g_Engine.time + 0.5;
				break;
	
				default:
				m_iNextSwing = 0.33;
				currAnim = KUNGFU_KICK;
				flDamage = 35;
				m_pPlayer.pev.maxspeed = 190;
				m_iSlowTime = g_Engine.time + 0.5;
			}
			m_iLastSwing = g_Engine.time + 0.4;
		}
		m_iSwing++;

		Attack(currAnim, flDamage, addvelocity);
		self.m_flNextPrimaryAttack = g_Engine.time + m_iNextSwing;
		self.m_flNextSecondaryAttack = g_Engine.time + m_iNextSwing;
		return;
	}
	void Attack(int currAnim, float flDamage, int addvelocity)
	{
		bool fDidHit = false;
		TraceResult tr;

		Math.MakeVectors( m_pPlayer.pev.v_angle );
		Vector vecSrc	= m_pPlayer.GetGunPosition();
		Vector vecDir = g_Engine.v_forward * 48;
		if (currAnim == KUNGFU_BACKKICK)
		{
			vecDir = (-1)*vecDir;
			vecDir.z *= 0.1; // back kick should be around the center
		}
		Vector vecEnd	= vecSrc + vecDir;
		g_Utility.TraceLine( vecSrc, vecEnd, dont_ignore_monsters, m_pPlayer.edict(), tr );

		if ( tr.flFraction >= 1.0 )
		{
			g_Utility.TraceHull( vecSrc, vecEnd, dont_ignore_monsters, head_hull, m_pPlayer.edict(), tr );
			if ( tr.flFraction < 1.0 )
			{
				CBaseEntity@ pHit = g_EntityFuncs.Instance( tr.pHit );
				if ( pHit is null || pHit.IsBSPModel() )
					g_Utility.FindHullIntersection( vecSrc, tr, tr, VEC_DUCK_HULL_MIN, VEC_DUCK_HULL_MAX, m_pPlayer.edict() );
				vecEnd = tr.vecEndPos;
			}
		}
		if ( tr.flFraction >= 1.0 )
		{
			self.SendWeaponAnim( currAnim );				
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, MISS_SND, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
		}
		else
		{
			g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, MISS_SND, 1, ATTN_NORM, 0, 94 + Math.RandomLong( 0,0xF ) );
	
			fDidHit = true;
			
			CBaseEntity@ pEntity = g_EntityFuncs.Instance( tr.pHit );			
			self.SendWeaponAnim( currAnim );	
			m_pPlayer.SetAnimation( PLAYER_ATTACK1 ); 
	
			if ( self.m_flCustomDmg > 0 )
				flDamage = self.m_flCustomDmg;
	
			g_WeaponFuncs.ClearMultiDamage();
			pEntity.TraceAttack( m_pPlayer.pev, flDamage, g_Engine.v_forward, tr, DMG_CLUB );  			
			g_WeaponFuncs.ApplyMultiDamage( m_pPlayer.pev, m_pPlayer.pev );
	
			float flVol = 1.0;
			bool fHitWorld = true;
			if( pEntity !is null )
			{
				if( pEntity.Classify() != CLASS_NONE && pEntity.Classify() != CLASS_MACHINE && pEntity.BloodColor() != DONT_BLEED )
				{
					if( addvelocity == 1 )		// lets push them
					{
						pEntity.pev.velocity = pEntity.pev.velocity + m_pPlayer.pev.velocity + ( self.pev.origin - pEntity.pev.origin ).Normalize() * (-150);
						pEntity.pev.velocity.z+=100;
					}
					g_SoundSystem.EmitSound( m_pPlayer.edict(), CHAN_WEAPON, HIT_SND, 1, ATTN_NORM );
					m_pPlayer.m_iWeaponVolume = 128; 
					if( !pEntity.IsAlive() )
						return;
					else
						flVol = 0.1;
					fHitWorld = false;
				}
			}
			if( fHitWorld == true )
			{
				float fvolbar = g_SoundSystem.PlayHitSound( tr, vecSrc, vecSrc + ( vecEnd - vecSrc ) * 2, BULLET_PLAYER_CROWBAR );
				fvolbar = 1;
				g_SoundSystem.EmitSoundDyn( m_pPlayer.edict(), CHAN_WEAPON, MISS_SND, fvolbar, ATTN_NORM, 0, 98 + Math.RandomLong( 0, 3 ) ); 
			}		
			m_trHit = tr;			
			m_pPlayer.m_iWeaponVolume = int( flVol * 512 ); 
		}
		return;
	}
	bool MovingBackwards()
	{
		Vector vel;
		float view = m_pPlayer.pev.angles.y;
		
		g_EngineFuncs.VecToAngles(m_pPlayer.pev.velocity, vel);

		view += 180;
		float a = view - 90;
		float b = view + 90;
		float c = vel.y;

		if (a < 0) 	a += 360;
		if (b < 0) 	b += 360;
		if (a > 360) 	a -= 360;
		if (b > 360) 	b -= 360;	

		if (a <= b)	return (c >= a && c <= b);
		else		return (c >= a || c <= b);
	}
}

string GetKungFuName()
{
	return "weapon_kungfu";
}

void RegisterKungFu()
{
	g_CustomEntityFuncs.RegisterCustomEntity( GetKungFuName(), GetKungFuName() );
	g_ItemRegistry.RegisterWeapon( GetKungFuName(), "ts" );
}
