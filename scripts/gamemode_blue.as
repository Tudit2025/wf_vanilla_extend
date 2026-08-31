#include "metagame.as"
#include "log.as"

#include "path://media/packages/wf_base/scripts"
#include "path://media/packages/wf_vanilla_extend/scripts"
#include "basic_command_handler.as"
#include "creeping_barrage.as"
#include "advanced_call.as"
#include "stage_configurator_invasion.as"
// #include "spawn_with_dir.as"

#include "call_marker_tracker.as"
#include "air_support.as"
#include "squad_equipment_kit.as"
#include "b52_carpet_bombing.as"
#include "mod_crane.as"
#include "command_call.as"
#include "false_door.as"
#include "barracks.as"
#include "billboard_manager.as"
#include "kill_commander.as"
#include "sniper_ace.as"
#include "stlms.as"
#include "agent_manager.as"
#include "blue_infiltrators.as"
#include "gazelle_hunt.as"
// making sure CallMarkerConfig actually works.

class GameModeBlueTester : Metagame {

    protected array<Faction@> m_factions;
    GameModeBlueTester(const XmlElement@ settings) {
        super(settings.getStringAttribute("log_level"));
    }

    void init() {
        Metagame::init();

        preBeginMatch();
        postBeginMatch();
    }

    void preBeginMatch() {
		_log("preBeginMatch", 1);

		// all trackers are cleared when match is about to begin
		Metagame::preBeginMatch();
        setupGuardians();
	}

    void postBeginMatch() {
        Metagame::postBeginMatch();

        addTracker(BasicCommandHandler(this));
        addTracker(CreepingBarrage(this));
		addTracker(AirSupport(this));   // unified air support: A10 + AC130 + heli (was A10GunRun + AC130GunRun)
		addTracker(B52BombingRun(this));
		addTracker(CraneWithMod(this));
		addTracker(CommandCall(this));
		addTracker(FakePrisonBreakObjective(this,0));
		addTracker(Barracks(this));
		addTracker(BillboardManager(this));
		// addTracker(enemyCommander(this));
		addTracker(EnemyCommanderEvent(this));
		addTracker(SniperAceEvent(this));    // test via /hvt_sniper (admin)
		addTracker(AgentManager(this));      // 2026_summer agent event, test via /vip (admin); no persistence in blue
		addTracker(BlueInfiltrators(this));  // Blueboots signature call: infiltration detachment
		addTracker(GazelleHunt(this));       // Graycollars signature call: anti-armor patrol
		addTracker(Stlms(this));
        array<CallMarkerConfig@> configs = {
            //CallMarkerConfig(string key, int atlasIndex = 0, float size = 2.0, float range = 1.0, string text = "")
            // CallMarkerConfig("creeping_barrage.call", "call_marker", 4, 0.5, 70.0),  //creeping barrage addition
            CallMarkerConfig("mortar1.call", "call_marker", 6, 0.5, 30.0),
			// CallMarkerConfig("mortar2.call", "call_marker", 17, 0.5, 50.0),            // remplaced in 1.77 with cluster bomb
			// CallMarkerConfig("f117_bombing.call", "call_marker", 17, 0.5, 35.0),
            CallMarkerConfig("cluster_bomb_2.call", "call_marker", 7, 0.5, 35.0),
			CallMarkerConfig("artillery1.call", "call_marker", 8, 1.0, 65.0),   // was 90 size before 1.83
			CallMarkerConfig("artillery2.call", "call_marker", 9, 1.0, 82.0),   // was 90 size before 1.83
			CallMarkerConfig("paratroopers1.call", "call_marker_drop", 10, 0.5),
			CallMarkerConfig("paratroopers2.call", "call_marker_drop", 11, 0.5),
			CallMarkerConfig("paratroopers_medic.call", "call_marker_drop", 14, 0.5),            
			CallMarkerConfig("humvee.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("humvee_alt.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("vfs_alt.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("buggy.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("buggy_alt.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("supply_quad.call", "call_marker_drop", 13, 0.5),
			CallMarkerConfig("supply_quad_alt.call", "call_marker_drop", 13, 0.5), 
			CallMarkerConfig("tank.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("tank_alt.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("cover_drop.call", "call_marker_drop", 13, 0.5),
			// air support markers (author 07-17): A10's circle-then-direction choreography is
			// script-owned in air_support.as (needs a swap at the launch phase, which
			// CallMarkerTracker can't do); rings = engage radius + spread (AC130: scan 35 + 5)
			CallMarkerConfig("f22_airstrike.call", "call_marker", 4, 0.5, 20),   // agent-event reward: 10 bombs, spread 13 + blast
			CallMarkerConfig("gunship_run.call", "call_marker", 20, 0.5, 40),    // atlas 20 = AC130 icon (author)
			CallMarkerConfig("gunship_run2.call", "call_marker", 20, 0.5, 40),
			CallMarkerConfig("heli.call", "call_marker", 21, 0.5, 25),    // ring value == 25m engage radius (semantics test 07-11: if shots land outside the ring, range means diameter -> double these); atlas 21 = heli icon (19 was the evil commander's)
			CallMarkerConfig("rubber_boat.call", "call_marker_drop", 12, 0.5),
			CallMarkerConfig("transponder.call", "call_marker_drop", 11, 0.5),
			CallMarkerConfig("rubber_boat_alt.call", "call_marker_drop", 12, 0.5),
			// 2026_summer agent event (07-10 port)
			CallMarkerConfig("agent_supply_drop.call", "call_marker_drop", 13, 0.5),
			CallMarkerConfig("vip.call", "call_marker_drop", 16, 0.5),
			CallMarkerConfig("vip_agent.call", "call_marker_drop", 16, 0.5),
			// blue_infiltrators.call deliberately has NO marker config: covert placement (see blue_infiltrators.as)
			// ring value == 40m zone radius (must match m_radius in gazelle_hunt.as; same semantics test as heli.call above)
			CallMarkerConfig("gazelle_hunt.call", "call_marker", 21, 0.5, 40)
        };

        addTracker(CallMarkerTracker(this, configs, true));

        XmlElement element(dictionary = {{"TagName", "command"},{"class", "chat"},{"text", "Welcome to blue faction testing! :)"}});
        m_comms.send(element);

        const XmlElement@ player = getPlayerInfo(this, 0);
        if (player !is null) {
            string username = player.getStringAttribute("name");
            // add local player as admin for easy testing, hacks, etc
            if (!getAdminManager().isAdmin(username)) {
                getAdminManager().addAdmin(username);
            }
        }
    }

	protected void setupGuardians() {
		{
			// enable guardians in friendly faction only
			XmlElement command("command");
			command.setStringAttribute("class", "faction");
			command.setIntAttribute("faction_id", 0);
			command.setStringAttribute("soldier_group_name", "guardian");
			command.setFloatAttribute("spawn_score", 0.008f);
			getComms().send(command);
        }

		for (uint i = 1; i < m_factions.size(); ++i) {
			const FactionConfig@ config = m_factions[i].m_config;
		{
			// disable guardians in enemy factions 
			XmlElement command("command");
			command.setStringAttribute("class", "faction");
			command.setIntAttribute("faction_id", i);
			command.setStringAttribute("soldier_group_name", "guardian");
			command.setFloatAttribute("spawn_score", 0.0f);
			getComms().send(command);
		}

      }
	}

    
}