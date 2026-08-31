#include "stage_configurator_invasion.as"
#include "map_events.as"
#include "sniper_ace.as"
#include "agent_manager_campaign.as"
#include "faction_requisition.as"

// ------------------------------------------------------------------------------------------------
class StageConfiguratorCampaign : StageConfiguratorInvasion {
	MapRotatorCampaign@ m_mapRotatorCampaign;

	// ------------------------------------------------------------------------------------------------
	StageConfiguratorCampaign(GameModeInvasion@ metagame, MapRotatorCampaign@ mapRotator) {
		super(metagame, mapRotator);
		// also need to store the adventure specific pointer, avoid casting
		@m_mapRotatorCampaign = @mapRotator;
	}

	// ------------------------------------------------------------------------------------------------
	void setup() {
		StageConfiguratorInvasion::setup();
		setupFinalStages();    

		setupTransports();
		setupStartingMaps();
	}


	// ------------------------------------------------------------------------------------------------
	const array<FactionConfig@>@ getAvailableFactionConfigs() const {
		array<FactionConfig@> availableFactionConfigs;

		availableFactionConfigs.push_back(FactionConfig(-1, "green.xml", "Greenbelts", "0.1 0.5 0", "green.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "grey.xml", "Graycollars", "0.5 0.5 0.5", "grey.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "brown.xml", "Brownpants", "0.5 0.25 0", "brown.xml"));
		availableFactionConfigs.push_back(FactionConfig(-1, "blue.xml", "Blueboots", "0.27 0.5 0.7", "blue.xml"));

		return availableFactionConfigs;
	}

	
	// ------------------------------------------------------------------------------------------------
	Stage@ setupCompletedStage(Stage@ inputStage) {
		Stage@ stage = createStage();

		stage.m_mapInfo = inputStage.m_mapInfo;
		stage.m_finalBattle = inputStage.m_finalBattle;
		stage.m_includeLayers = inputStage.m_includeLayers;

		stage.m_maxSoldiers = 40;

		{
			Faction f(getFactionConfigs()[0], createCommanderAiCommand(0));
			stage.m_factions.insertLast(f);
		}
		
		addFixedSpecialCrates(stage);
		addRandomSpecialCrates(stage, stage.m_minRandomCrates, stage.m_maxRandomCrates);
	
		return stage;
	}

	// ------------------------------------------------------------------------------------------------
    protected void addStage(Stage@ stage) {
        stage.m_includeLayers.insertLast("layer.campaign2");

        // invasion has added a special layer for more resistance, remove it for single player
        int index = stage.m_includeLayers.find("layer1.invasion");
        if (index >= 0) {
            stage.m_includeLayers.removeAt(index);
        }
        StageConfiguratorInvasion::addStage(stage);
    }
 
	// ------------------------------------------------------------------------------------------------
	protected void setupNormalStages() {
		addStage(setupStagewf1());		//map15
		addStage(setupStagewf2());		//map14
		addStage(setupCompletedStage(setupStagewf3()));		//map8 peace
		addStage(setupStagewf4());		//map21
		addStage(setupStagewf5());		//map16
		addStage(setupStagewf6());		//map18
		addStage(setupStagewf7());		//map13
		addStage(setupStagewf8());		//map22
		addStage(setupStagewf9());		//map22

	}

	//dlc maps

	void layerShower(Stage@ stage)
	{
		_log("layer shower");
		for(uint i=0;i<stage.m_includeLayers.length();i++)
		{
			_log(stage.m_includeLayers[i]);
		}
	}

	protected Stage@ setupStagewf1() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Islet of Eflen";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map15_campaign"; //UNDONE
		stage.m_mapInfo.m_id = "map15";
		
		// we want to exclude some layers here
	int index = stage.m_includeLayers.find("layer1.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}
	index = stage.m_includeLayers.find("bases.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}

		stage.m_includeLayers.insertLast("bases.campaign2");

		layerShower(stage);

		stage.m_maxSoldiers = 8 * 11;

		stage.m_soldierCapacityVariance = 0.35;
		stage.m_playerAiCompensation = 3;
		stage.m_playerAiReduction = 2;

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Map15Event(m_metagame,stage)); // Add the map event tracker

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0.85, 0.15, 0.0));
			f.m_overCapacity = 5;
			f.m_capacityOffset = 8;
			f.m_capacityMultiplier = 1.0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}

		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(0.0, 0.7, 0.3));
			f.m_overCapacity = 10;
			f.m_capacityOffset = 8; 
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call","creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		array<string> disabledSoliders = {"eod","lonewolf","grenadier","elite","elitefemale","ranger"};
		for(uint i=0;i<disabledSoliders.length();i++)
		{
			XmlElement command("command");
            command.setStringAttribute("class", "faction");
            command.setIntAttribute("faction_id", 1);
            command.setStringAttribute("soldier_group_name", disabledSoliders[i]);
            command.setFloatAttribute("spawn_score", 0.0);
			stage.m_extraCommands.insertLast(command);
		}
		for(uint i=0;i<disabledSoliders.length();i++)
		{
			XmlElement command("command");
            command.setStringAttribute("class", "faction");
            command.setIntAttribute("faction_id", 0);
            command.setStringAttribute("soldier_group_name", disabledSoliders[i]);
            command.setFloatAttribute("spawn_score", 0.0);
			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;
		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	protected Stage@ setupStagewf2() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Misty Heights";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map14";//DONE
		stage.m_mapInfo.m_id = "map14";
		
		stage.m_fogOffset = 20.0;    
		stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 11 * 13;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2.0;

		stage.m_soldierCapacityVariance = 0.45;

		stage.addTracker(PeacefulLastBase(m_metagame, 0));    
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Map14Event(m_metagame, stage)); // Add the map event tracker
		stage.addTracker(SniperAceEvent(m_metagame, stage)); // ace marksman hunt, arms when the AA dies; switches [2]/[3]

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;  

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.2, 0.12));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 35;
			f.m_capacityMultiplier = 1;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.6, 0.25));
			f.m_overCapacity = 10;
			f.m_capacityOffset = 15; 
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "radar_tower.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}

		// array<string> disabledSoliders = {"radioman"};
		// for(uint i=0;i<disabledSoliders.length();i++)
		// {
		// 	XmlElement command("command");
        //     command.setStringAttribute("class", "faction");
        //     command.setIntAttribute("faction_id", 1);
        //     command.setStringAttribute("soldier_group_name", disabledSoliders[i]);
        //     command.setFloatAttribute("spawn_score", 0.0);
		// 	stage.m_extraCommands.insertLast(command);
		// }
		// for(uint i=0;i<disabledSoliders.length();i++)
		// {
		// 	XmlElement command("command");
        //     command.setStringAttribute("class", "faction");
        //     command.setIntAttribute("faction_id", 0);
        //     command.setStringAttribute("soldier_group_name", disabledSoliders[i]);
        //     command.setFloatAttribute("spawn_score", 0.0);
		// 	stage.m_extraCommands.insertLast(command);
		// }

		setDefaultAttackBreakTimes(stage);
		return stage;
	}  

	protected Stage@ setupStagewf3() { //whatever
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Vigil Island"; 
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map8";
		stage.m_mapInfo.m_id = "map8";

		stage.m_includeLayers.insertLast("layer.campaign2"); 

		stage.addTracker(Overtime(m_metagame, 0));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(255,0,344),20, "default_ai"));


		stage.m_maxSoldiers = 21 * 5;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2;
		stage.m_soldierCapacityModel = "constant";

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 2;

		stage.m_defenseWinTime = 720.0;
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.3, 0.1));
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.25, 0.05));
			f.m_overCapacity = 60;
			f.m_capacityMultiplier = 0.0001;
			f.m_capacityOffset = 60;
			stage.m_factions.insertLast(f);
		}
		{
			// neutral
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(2));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call","creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "cover1.vehicle", "deployable_minig.vehicle", "hornet.vehicle", "apc.vehicle", "apc_1.vehicle", "apc_2.vehicle", "tank_denied_player.vehicle", "tank_1_denied_player.vehicle", "tank_2_denied_player.vehicle", "noxe.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Airfield";
		stage.m_radioObjectivePresent = false;

		return stage;
	}

	protected Stage@ setupStagewf4() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Route 666";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map21";
		stage.m_mapInfo.m_id = "map21";
		stage.m_mapInfo.m_size = 1536.0;

	int index = stage.m_includeLayers.find("layer1.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}
	index = stage.m_includeLayers.find("bases.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}

		stage.m_includeLayers.insertLast("bases.campaign2");

		stage.m_fogOffset = 24.0;    
		stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 17 * 14;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2.0;

		stage.m_soldierCapacityVariance = 0.55;

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Emrlc(m_metagame,stage));
		stage.addTracker(SniperAceEvent(m_metagame, stage, 2, 3, "", 30, "sniper ace")); // roaming ace, 30%, base-progress trigger; Emrlc holds [0]/[1]

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 4;  

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.35, 0.12));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 35;
			f.m_capacityMultiplier = 1;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[2], createCommanderAiCommand(1, 0.6, 0.18));
			f.m_overCapacity = 70;
			f.m_capacityOffset = 10;
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"lailv-002.vehicle", "mmls-528.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer2.vehicle", "radar_tower.vehicle", "legion.vehicle", "tank_denied_player.vehicle", "tank_1_denied_player.vehicle", "tank_2_denied_player.vehicle", "flamer_tank.vehicle", "missile_launcher.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"judgement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	protected Stage@ setupStagewf5() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Green Coast";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map16";
		stage.m_mapInfo.m_id = "map16";

		stage.m_maxSoldiers = 18 * 13;
		stage.m_playerAiCompensation = 3;
		stage.m_playerAiReduction = 2;

		stage.m_defenseWinTime = 60.0;   // Timer!
		stage.m_defenseWinTimeMode = "custom";

		stage.m_soldierCapacityVariance = 0.45;

		stage.addTracker(AttackDefenseHandlerMap16(m_metagame, 0));		// we use this instead of peacefullastbase for map16
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Map16Event(m_metagame,stage));
		stage.addTracker(Map16ExtraEvent(m_metagame,stage,m_mapRotatorCampaign));


		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 5;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.3));
			f.m_overCapacity = 5;
			f.m_bases = 1;
			f.m_capacityMultiplier = 1.0;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.6, 0.28));
			f.m_overCapacity = 80;
			f.m_capacityOffset = 10;         
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(2, 0.65, 0.1));
			f.m_overCapacity = 40;
			f.m_capacityOffset = 5;
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"vulcan_tank.vehicle", "radar_tank2.vehicle", "radio_jammer2.vehicle", "apc.vehicle", "apc_1.vehicle", "apc_2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	protected Stage@ setupStagewf6() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Warsalt Legacy";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map18";
		stage.m_mapInfo.m_id = "map18";
		
	int index = stage.m_includeLayers.find("layer1.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}
	index = stage.m_includeLayers.find("bases.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}

		stage.m_includeLayers.insertLast("bases.campaign2");

		stage.m_maxSoldiers = 16 * 13;
		stage.m_playerAiCompensation = 4;
        stage.m_playerAiReduction = 2.0;
  
		stage.m_soldierCapacityVariance = 0.5;		// was 0.3 (1.91), 0.4 (1.96)

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Map18Event(m_metagame,stage));
		stage.addTracker(Emrlc(m_metagame, stage, 0, 3));    // [1] would collide with Map18Event's AA flag
	
		//stage.addTracker(RunAtStart(m_metagame, command));

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;
		
		// make neutral instantly not alive to avoid any possibility to gain capacity, like via not losing all bases first 
		// and then gaining bases which have vehicles that give capacity offset..
		{
			XmlElement command("command");
			command.setStringAttribute("class", "create_instance");
			command.setIntAttribute("faction_id", 1);
			command.setStringAttribute("position", "772 10 949");
			command.setStringAttribute("instance_class", "vehicle");
			command.setStringAttribute("instance_key", "m528.vehicle");
			m_metagame.getComms().send(command);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));
		}

		
		{
			XmlElement command("command");
			command.setStringAttribute("class", "set_match_status");
			command.setIntAttribute("faction_id", 2);
			command.setBoolAttribute("lose", true);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));     
		}
		

		{				
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.35, 0.1));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 20;
			f.m_capacityMultiplier = 1;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(1, 0.64, 0.2));		// was 0.55 0.2 (1.95)
			f.m_overCapacity = 100;
			f.m_capacityOffset = 30;
			stage.m_factions.insertLast(f);
		}

		// whitefang calvary
		{
			Faction f(getFactionConfigs()[5], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		stage.addTracker(VehicleSpawner(m_metagame, 1, Vector3(83,4,689), 1, "humvee_roadblock.vehicle", 7.0f));
		stage.addTracker(VehicleSpawner(m_metagame, 2, Vector3(97,3,695), 1, "pika_k1_broken.vehicle", 1.0f));
		stage.addTracker(VehicleSpawner(m_metagame, 2, Vector3(93,3,705), 1, "mrap_armory.vehicle", 2.0f));
		stage.addTracker(VehicleSpawner(m_metagame, 1, Vector3(104,3,711), 1, "humvee_roadblock.vehicle", 7.0f, "0 1 0 180"));
		stage.addTracker(VehicleSpawner(m_metagame, 2, Vector3(188,4,598), 1, "gas_truck.vehicle", 6.8f));
		stage.addTracker(VehicleSpawner(m_metagame, 2, Vector3(222,4,552), 1, "gas_truck.vehicle", 6.8f));
		stage.addTracker(Spawner(m_metagame, 2, Vector3(100,3,706), 3, "default"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(110,3,713), 7, "default"));


		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "radar_tower.vehicle", "m528.vehicle", "apc.vehicle", "apc_1.vehicles", "apc_2.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"cerberus.vehicle"}, true);
			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	protected Stage@ setupStagewf7() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Iron Enclave";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map13_campaign";
		stage.m_mapInfo.m_id = "map13";

	int index = stage.m_includeLayers.find("bases.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}

		stage.m_includeLayers.insertLast("bases.campaign2");

		stage.m_maxSoldiers = 15 * 13;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2.0; 

		stage.m_soldierCapacityVariance = 0.4;

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(SniperAceEvent(m_metagame, stage, 2, 3, "", 35, "sniper ace")); // roaming ace, 35%, base-progress trigger

		stage.m_minRandomCrates = 1;
		stage.m_maxRandomCrates = 2;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.15));
			f.m_overCapacity = 0;
			f.m_bases = 1;
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(1, 0.5, 0.2));
			f.m_overCapacity = 40;
			f.m_capacityOffset = 20;
			f.m_capacityMultiplier = 1.0; 
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}

	protected Stage@ setupStagewf8() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Sunset Bay";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map22";//DONE
		stage.m_mapInfo.m_id = "map22";

		stage.m_fogOffset = 20.0;    
		stage.m_fogRange = 50.0; 

		stage.m_maxSoldiers = 13 * 13;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2.0;

		stage.m_soldierCapacityVariance = 0.4;

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Emrlc(m_metagame,stage));//test in map22
		stage.addTracker(EnemyCommanderEvent(m_metagame, stage, 2, 3));	// TRIAL: guarded commander at the farthest base, kill paralyzes Blueboots command 150s; Emrlc holds [0]/[1]
		{	// TRIAL: 2026_summer agent escort (hotfix port); scores/tier/rewards persist via the stage save chain
			CampaignAgentManager@ agentManager = CampaignAgentManager(m_metagame);
			stage.addTracker(agentManager);
			stage.m_savedManagers.insertLast(agentManager);
		}
		{	// TRIAL: theater requisition MVP (faction unlock pool, TEST cards); state persists via the stage save chain
			FactionRequisition@ requisition = FactionRequisition(m_metagame);
			stage.addTracker(requisition);
			stage.m_savedManagers.insertLast(requisition);
		}

		stage.m_minRandomCrates = 2; 
		stage.m_maxRandomCrates = 3;  

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.25, 0.1));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 15;
			f.m_capacityMultiplier = 1;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(1, 0.6, 0.25));
			f.m_overCapacity = 70;
			f.m_capacityOffset = 15; 
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle", "radar_tower.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	}  

	protected Stage@ setupStagewf9() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Gotcha Island";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map17";
		stage.m_mapInfo.m_id = "map17";
		
		stage.m_defenseWinTime = 60.0;   // if this ?
		stage.m_defenseWinTimeMode = "custom";

	int index = stage.m_includeLayers.find("layer1.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}
	index = stage.m_includeLayers.find("bases.default");
	if (index >= 0) {
	stage.m_includeLayers.removeAt(index);
	}

		stage.m_includeLayers.insertLast("bases.campaign2");
		stage.m_includeLayers.insertLast("layer1"); 

		layerShower(stage);

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(Map17Event(m_metagame,stage,m_mapRotatorCampaign));
		stage.m_maxSoldiers = 11 * 12;

		stage.m_soldierCapacityVariance = 0.5;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2.0;

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.5, 0.12));
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[2], createCommanderAiCommand(1, 0.60, 0.14));
			f.m_overCapacity = 60;
			f.m_capacityOffset = 5;
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"m113_tank_acav.vehicle", "radio_jammer.vehicle", "radar_tower.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		// setReduceDefenseForFinalAttack(stage, 0.1); // use this for final attack boost if needed for friendlies
		return stage;
	}



	// ------------------------------------------------------------------------------------------------
	protected void setupFinalStages() {
		addStage(setupStagewffin1());	//map23
		addStage(setupStagewffin2());	//13_2
		addStage(setupStagewffin3());	//8_2
		addStage(setupStagewffin4());	//5_2
		addStage(setupStagewffin5());	//24
	}

	protected Stage@ setupStagewffin1() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Flooded Town";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map23";
		stage.m_mapInfo.m_id = "map23";

		stage.m_finalBattle = true;	//we ll do this latter
		stage.m_maxSoldiers = 15 * 14;
		stage.m_playerAiCompensation = 4;                                       
    	stage.m_playerAiReduction = 1.8;                                            //   

		stage.m_soldierCapacityVariance = 0.4; 								 // big map variance

		stage.addTracker(AttackDefenseHandlerMap23(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		// no commander event here: the flooded town is WhiteFang weather-device territory, story-wise unrelated
		// stage.addTracker(BaseHandlerMap23(m_metagame, 4));

    	stage.m_minRandomCrates = 3; 
    	stage.m_maxRandomCrates = 5;

		//WhiteFang's calvary was halted by one of those enemy factions
		{
			XmlElement command("command");
			command.setStringAttribute("class", "set_match_status");
			command.setIntAttribute("faction_id", 3);
			command.setBoolAttribute("lose", true);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));     
		}

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_overCapacity = 8;                                                   
			f.m_bases = 1;
			f.m_capacityMultiplier = 1;                                          
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1));
			f.m_overCapacity = 35;                                                   
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[2], createCommanderAiCommand(2));
			f.m_overCapacity = 50;                                                      
			stage.m_factions.insertLast(f);
		}
		// Whitefangs
		{
			Faction f(getFactionConfigs()[5], createCommanderAiCommand(1));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		stage.addTracker(VehicleSpawner(m_metagame, 3, Vector3(122,6,167), 1, "mrap_armory.vehicle", 1.0f));
		stage.addTracker(Spawner(m_metagame, 3, Vector3(114,6,173), 5, "default_ai"));
		stage.addTracker(VehicleSpawner(m_metagame, 1, Vector3(116,6,183), 1, "humvee_roadblock.vehicle", 7.0f));
		// stage.addTracker(Map23InstanceSpawner(m_metagame, Vector3(113,6,183), 1, "humvee_roadblock.vehicle", "vehicle"));
		// stage.addTracker(Map23InstanceSpawner(m_metagame, Vector3(133,6,180), 1, "humvee_roadblock.vehicle", "vehicle"));
		stage.addTracker(Map23InstanceSpawner(m_metagame, Vector3(130,6,180), 4, "guardian", "character"));
		stage.addTracker(VehicleSpawner(m_metagame, 1, Vector3(133,6,180), 1, "humvee_roadblock.vehicle", 7.0f));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(130,6,180), 3, "default_ai"));
		// aa emplacements work right only if one enemy faction has them
		// - all factions have it disabled by default
		// - manually enable it for faction #1 in map1 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		// {
		// 	XmlElement command("command");
		// 	command.setStringAttribute("class", "faction_resources");
		// 	command.setIntAttribute("faction_id", 0);
		// 	stage.m_extraCommands.insertLast(command);
		// } 

		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}  

	protected Stage@ setupStagewffin2() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Dry Enclave";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map13_2";
		stage.m_mapInfo.m_id = "map13_2";

		stage.m_finalBattle = false;

		stage.addTracker(Overtime(m_metagame, 0));

		stage.m_maxSoldiers = 10 * 18;
		stage.m_playerAiCompensation = 4;
		stage.m_playerAiReduction = 2;
		stage.m_soldierCapacityModel = "constant";

		stage.addTracker(Spawner(m_metagame, 3, Vector3(506,0,465), 40, "default"));	//center
		stage.addTracker(Spawner(m_metagame, 3, Vector3(506,0,485), 2, "bomber"));		//center
		stage.addTracker(Spawner(m_metagame, 3, Vector3(506,0,445), 2, "bomber"));		//center
		stage.addTracker(Spawner(m_metagame, 3, Vector3(438,0,344), 5, "default"));		//NW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(619,0,419), 5, "default"));		//NE
		stage.addTracker(Spawner(m_metagame, 3, Vector3(461,0,540), 5, "default"));		//SW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(588,0,374), 5, "default"));		//SE
		stage.addTracker(Spawner(m_metagame, 3, Vector3(428,0,344), 2, "bomber"));		//NW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(448,0,344), 2, "bomber"));		//NW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(609,0,419), 2, "bomber"));		//NE
		stage.addTracker(Spawner(m_metagame, 3, Vector3(629,0,419), 2, "bomber"));		//NE
		stage.addTracker(Spawner(m_metagame, 3, Vector3(451,0,540), 2, "bomber"));		//SW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(471,0,540), 2, "bomber"));		//SW
		stage.addTracker(Spawner(m_metagame, 3, Vector3(578,0,374), 2, "bomber"));		//SE
		stage.addTracker(Spawner(m_metagame, 3, Vector3(598,0,374), 2, "bomber"));		//SE

		stage.m_minRandomCrates = 0; 
		stage.m_maxRandomCrates = 1;

		stage.m_defenseWinTime = 800; 
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));
		
		{
		XmlElement command("command");
		command.setStringAttribute("class", "change_game_settings");
		for (uint i = 0; i < m_metagame.getFactionCount(); ++i) {
			XmlElement faction("faction");
			if (int(i) == 3) {
				faction.setFloatAttribute("capacity_multiplier", 0.00001);
				faction.setBoolAttribute("lose_without_bases", false);
			}
			command.appendChild(faction);
			}
		m_metagame.getComms().send(command);
		stage.addTracker(RunAtStart(m_metagame, command));
		}
		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.3, 0.1));     
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[2], createCommanderAiCommand(2, 0.32, 0.05));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 5;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(1, 0.32, 0.05));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 5;
			stage.m_factions.insertLast(f);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle", "legion.vehicle", "noxe.vehicle", "m528.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}        
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 2);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}  
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 3);
			addFactionResourceElements(command, "vehicle", array<string> = {"technical.vehicle", "radio_jammer2.vehicle", "radar_tank2.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}		
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}
		{
			// neutral
			Faction f(getFactionConfigs()[4], createCommanderAiCommand(3));
		//	f.m_overCapacity = 60;
			f.m_capacityMultiplier = 0;
			stage.m_factions.insertLast(f);
		}


		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Dry Enclave";

		return stage;
	} 	

	protected Stage@ setupStagewffin3() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Tropical Blizzard";
		stage.m_mapInfo.m_path = "media/packages/vanilla.winter/maps/map8_2";//checkHere
		stage.m_mapInfo.m_id = "map8_2";

		stage.m_finalBattle = false;
		stage.m_fogOffset = 15.0;
		stage.m_fogRange = 42.0;

		stage.m_maxSoldiers = 12 * 11;
		stage.m_soldierCapacityVariance = 0.6;

		stage.m_playerAiCompensation = 3;
		stage.m_playerAiReduction = 1.5;
		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));

		stage.addTracker(Spawner(m_metagame, 1, Vector3(146,10,173), 2, "miniboss"));		// Cargo helicopter filler
		stage.addTracker(Spawner(m_metagame, 1, Vector3(146,10,173), 10, "default_ai"));	// Cargo helicopter filler

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.4, 0.1));
			f.m_overCapacity = 0;
			f.m_capacityOffset = 0; 
			f.m_capacityMultiplier = 1.0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.65, 0.1));
			f.m_overCapacity = 50;
			f.m_capacityOffset = 0;
			stage.m_factions.insertLast(f);
		}

		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radar_tank2.vehicle", "wiesel_tow.vehicle", "cargo_helicopter_broken.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		} 
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"b52_carpet_bombing.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	protected Stage@ setupStagewffin4() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Resort Blizzard";
		stage.m_mapInfo.m_path = "media/packages/vanilla.winter/maps/map5_2";//checkHere
		stage.m_mapInfo.m_id = "map5_2";

		stage.m_finalBattle = true;
		stage.m_fogOffset = 15.0;
		stage.m_fogRange = 42.0;

		stage.m_maxSoldiers = 115;
		stage.m_soldierCapacityVariance = 0.6;

		stage.m_playerAiCompensation = 3;
		stage.m_playerAiReduction = 1.5;

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		stage.addTracker(DestroyVehicleToCaptureBase(m_metagame, "radio_jammer.vehicle", 2));
		stage.addTracker(DestroyVehicleToCaptureBase(m_metagame, "radar_tower.vehicle", 2));
		stage.addTracker(TargetManagerMap5_2(m_metagame));
		stage.addTracker(ReinforcementsManager5_2(m_metagame)); // spawns reinforcements when spec ops ar are killed
		stage.addTracker(enemyCommander(m_metagame));		// 5_2 unique
		stage.addTracker(FakePrisonBreakObjective(m_metagame, 3));	// undead unique

		{
			XmlElement command("command");
			command.setStringAttribute("class", "set_match_status");
			command.setIntAttribute("faction_id", 2);
			command.setBoolAttribute("lose", true);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));     
		}

		stage.addTracker(Spawner(m_metagame, 1, Vector3(380,7,323), 5, "default_ai")); 	// 1st tower

		stage.addTracker(Spawner(m_metagame, 1, Vector3(248,15,421), 5, "default_ai"));         
		stage.addTracker(Spawner(m_metagame, 1, Vector3(229,15,435), 5, "default_ai"));

		stage.addTracker(Spawner(m_metagame, 1, Vector3(159,3,556), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(154,3,564), 5, "default_ai"));
		
		stage.addTracker(Spawner(m_metagame, 1, Vector3(394,7,512), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(382,7,512), 1, "commander"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(517,5,709), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(359,5,673), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(371,13,524), 5, "default_ai"));  // central
		stage.addTracker(Spawner(m_metagame, 1, Vector3(347,14,491), 5, "default_ai"));	// church
		stage.addTracker(Spawner(m_metagame, 1, Vector3(301,15,466), 5, "default_ai"));	// cemetery
		stage.addTracker(Spawner(m_metagame, 1, Vector3(229,15,438), 5, "default_ai"));	// tower north

		stage.addTracker(Spawner(m_metagame, 1, Vector3(177,3,562), 5, "default_ai"));	// central club
		stage.addTracker(Spawner(m_metagame, 1, Vector3(177,3,562), 5, "default_ai"));	// central club

		stage.addTracker(Spawner(m_metagame, 1, Vector3(552,5,680), 1, "commander"));	// dock
		stage.addTracker(Spawner(m_metagame, 1, Vector3(765,7,546), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(770,7,538), 5, "default_ai"));    
		stage.addTracker(Spawner(m_metagame, 1, Vector3(583,4,263), 5, "default_ai"));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(589,4,256), 1, "commander"));    

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.0, 0.0, false));
			f.m_overCapacity = 10;
			f.m_capacityMultiplier = 0.0001;		// script controlled
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[5], createCommanderAiCommand(1, 1.0, 0.0, false));
			stage.m_factions.insertLast(f);
		}

		{
			Faction f(getFactionConfigs()[4], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		// undead
		{
			Faction f(getFactionConfigs()[6], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}
		// metadata
		stage.m_primaryObjective = "capture";
		stage.m_radioObjectivePresent = false;

		// no calls for friendly faction in the last map
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			command.setBoolAttribute("clear_calls", true);
			stage.addTracker(RunAtStart(m_metagame, command));
		}

		{
			int factionId = 0;
			string spec = "spec ops ar";
			array<const XmlElement@>@ groups = getSoldierGroups(m_metagame, factionId);
			for (uint i = 0; i < groups.size(); ++i) {
				const XmlElement@ group = groups[i];
				float spawnScore = 0.0;
				string name = group.getStringAttribute("name");
				if (name == spec) {
					spawnScore = 1.0;
				}
				XmlElement command("command");
				command.setStringAttribute("class", "faction");
				command.setIntAttribute("faction_id", 0);
				command.setStringAttribute("soldier_group_name", name);
				command.setFloatAttribute("spawn_score", spawnScore);
				stage.m_extraCommands.insertLast(command);
			}

		}

		setDefaultAttackBreakTimes(stage);
		return stage;
	} 

	protected Stage@ setupStagewffin5() {
		PhasedStage@ stage = createPhasedStage();
		stage.m_mapInfo.m_name = "Whiteshore";
		stage.m_mapInfo.m_path = "media/packages/wf_base/maps/map24";
		stage.m_mapInfo.m_id = "map24";

		stage.addTracker(PeacefulLastBase(m_metagame, 0));
		stage.addTracker(CommsCapacityHandler(m_metagame));
		stage.addTracker(FakePrisonBreakObjective(m_metagame, 3));
		stage.m_maxSoldiers = 15 * 10;
		stage.m_playerAiCompensation = 4.5;                                         
		stage.m_playerAiReduction = 2.5;                                            
		stage.m_soldierCapacityVariance = 0.35;                              

		stage.m_minRandomCrates = 1; 
		stage.m_maxRandomCrates = 3;

		float enemySpawnCompensationFactor = stage.m_playerAiCompensation * m_metagame.getUserSettings().m_playerAiCompensationFactor;
		enemySpawnCompensationFactor *= 0.5f;
		stage.setPhaseController(PhaseControllerMap24(m_metagame, enemySpawnCompensationFactor));

		{
			XmlElement command("command");
			command.setStringAttribute("class", "set_match_status");
			command.setIntAttribute("faction_id", 2);
			command.setBoolAttribute("lose", true);
			// can't use m_extraCommands, they happen before match start, using trackers instead then
			stage.addTracker(RunAtStart(m_metagame, command));     
		}

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0));
			f.m_capacityOffset = 0; 
			f.m_overCapacity = 0;
			f.m_bases = 1;
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[5], createCommanderAiCommand(1));
			f.m_loseWithoutBases = false;
			f.m_overCapacity = 40;                                              // was 30 (test2)
			f.m_capacityOffset = 5;                                                // was 0 in 1.65
			stage.m_factions.insertLast(f); 
		}

		{
			Faction f(getFactionConfigs()[4], createCommanderAiCommand(3));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		{
			Faction f(getFactionConfigs()[6], createCommanderAiCommand(3));
			f.m_loseWithoutBases = false;
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}
		
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 1);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"darkcat_0.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_1.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_2.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_3.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}
		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"darkcat_0.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"aa_emplacement.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"pika_k1_minig_roadblock.vehicle","deployable_minig.vehicle", "hornet.vehicle", "apc.vehicle", "apc_1.vehicle", "apc_2.vehicle","apc_3.vehicle"}, false);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_1.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_2.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"mod_3.vehicle"}, true);

			stage.m_extraCommands.insertLast(command);
		} 

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 2);
			addFactionResourceElements(command, "vehicle", array<string> = {"heli_extraction.vehicle"}, true);
			addFactionResourceElements(command, "vehicle", array<string> = {"darkcat_0.vehicle"}, false);
			stage.m_extraCommands.insertLast(command);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "call", array<string> = {"creeping_barrage.call"}, false);
			stage.m_extraCommands.insertLast(command);
		}
		// metadata
		stage.m_primaryObjective = "capture";

		setDefaultAttackBreakTimes(stage);
		return stage;
	}  
	// --------------------------------------------
	protected void setupWorld() {
		// World disabled in Invasion for now, map10 elements are missing
		WorldCampaign world(m_metagame);

		dictionary mapIdToRegionIndex;
		mapIdToRegionIndex.set("map18", 0);
		mapIdToRegionIndex.set("map22", 1);
		mapIdToRegionIndex.set("map16", 2);
		mapIdToRegionIndex.set("map24", 3);
		mapIdToRegionIndex.set("map13", 4);
		mapIdToRegionIndex.set("map21", 5);
		mapIdToRegionIndex.set("map14", 6);
		mapIdToRegionIndex.set("map8", 7);
		mapIdToRegionIndex.set("map22", 8);
		mapIdToRegionIndex.set("map17", 9);
		mapIdToRegionIndex.set("map15", 10);
		mapIdToRegionIndex.set("map5", 11);

		world.init(mapIdToRegionIndex);

		m_mapRotatorCampaign.setWorld(world);
	}

	// --------------------------------------------
	protected void setupTransports() {
		addTransport("map15", "hitbox_extraction14", "map14");
		addTransport("map15", "hitbox_extraction8", "map8");

		addTransport("map14", "hitbox_extraction8", "map8");
		addTransport("map14", "hitbox_extraction15", "map15");
		addTransport("map14", "hitbox_extraction21", "map21");
		addTransport("map14", "hitbox_extraction16", "map16");
		
		addTransport("map21", "hitbox_extraction18", "map18");
		addTransport("map21", "hitbox_extraction13", "map13");
		addTransport("map21", "hitbox_extraction17", "map17");
		addTransport("map21", "hitbox_extraction14", "map14");
		addTransport("map21", "hitbox_extraction16", "map16");
		
		addTransport("map8", "hitbox_extraction15", "map15");	
		addTransport("map8", "hitbox_extraction14", "map14");	

		addTransport("map16", "hitbox_extraction18", "map18");//
		addTransport("map16", "hitbox_extraction21", "map21");
		addTransport("map16", "hitbox_extraction14", "map14");
		
		addTransport("map13", "hitbox_extraction18", "map18");	
		addTransport("map13", "hitbox_extraction21", "map21");	
		addTransport("map13", "hitbox_extraction22", "map22");	

		addTransport("map18", "hitbox_extraction16", "map16");//
		addTransport("map18", "hitbox_extraction13", "map13");
		addTransport("map18", "hitbox_extraction21", "map21");
		
		addTransport("map22", "hitbox_extraction17", "map17");
		addTransport("map22", "hitbox_extraction13", "map13");
		
		addTransport("map17", "hitbox_extraction21", "map21");
		addTransport("map17", "hitbox_extraction22", "map22");

		
		addTransport("map15", "hitbox_extraction23", "map23");
		addTransport("map14", "hitbox_extraction23", "map23");
		addTransport("map21", "hitbox_extraction23", "map23");
		addTransport("map8",  "hitbox_extraction23", "map23");
		addTransport("map16", "hitbox_extraction23", "map23");
		addTransport("map13", "hitbox_extraction23", "map23");
		addTransport("map18", "hitbox_extraction23", "map23");
		addTransport("map22", "hitbox_extraction23", "map23");
		addTransport("map17", "hitbox_extraction23", "map23");

		addTransport("map23", "hitbox_extraction132", "map13_2");

		addTransport("map13_2", "hitbox_extraction82", "map8_2");
		
		addTransport("map8_2", "hitbox_extraction52", "map5_2");

		addTransport("map5_2", "hitbox_extraction24", "map24");
	}

	protected void setupTransportsTo23() {

	}

	// --------------------------------------------
	protected void addTransport(string sourceMapName, string hitboxId, string targetMapName) {
		m_mapRotatorCampaign.addTransport(sourceMapName, hitboxId, targetMapName);
	}

	// --------------------------------------------
	protected void setupStartingMaps() {
		m_mapRotatorCampaign.delcareDoneMap("map8");
		//m_mapRotatorCampaign.addStartingMap("map15");	//TEST: restore this and remove map22 below when the commander/Emrlc trials are done
		m_mapRotatorCampaign.addStartingMap("map22");
		// map4 no longer an option as a starting map
		//m_mapRotatorCampaign.addStartingMap("map4");

		const UserSettings@ settings = m_metagame.getUserSettings();
		if (settings.m_continueAsNewCampaign) {
			// add more starting maps when continuing the campaign after finishing it
			m_mapRotatorCampaign.addStartingMap("map14");
			m_mapRotatorCampaign.addStartingMap("map21");
			m_mapRotatorCampaign.addStartingMap("map17");
			m_mapRotatorCampaign.addStartingMap("map22");
			m_mapRotatorCampaign.addStartingMap("map13");
			m_mapRotatorCampaign.addStartingMap("map18");
			m_mapRotatorCampaign.addStartingMap("map16");
		}
	}
	
	// --------------------------------------------
	protected void addLotteryVehicle(Stage@ stage) {
		// not in campaign? comment this out
		StageConfiguratorInvasion::addLotteryVehicle(stage);
	}
	
	// --------------------------------------------
	protected void addDarkcatVehicle(Stage@ stage) {
		// not in campaign? comment this out
		// StageConfiguratorInvasion::addDarkcatVehicle(stage);
	}	
	
	// ------------------------------------------------------------------------------------------------
	protected Stage@ setupStage8() {
		Stage@ stage = createStage();
		stage.m_mapInfo.m_name = "Vigil Island";
		stage.m_mapInfo.m_path = "media/packages/vanilla/maps/map8";
		stage.m_mapInfo.m_id = "map8";

		stage.m_includeLayers.insertLast("layer1.invasion"); 

		stage.addTracker(Overtime(m_metagame, 0));
		stage.addTracker(Spawner(m_metagame, 1, Vector3(255,0,344),20, "default_ai"));          // added 15 in 1.65, less over_capacity to compensate


		stage.m_maxSoldiers = 21 * 5;     // was 33 * 3 in 1.65
		stage.m_playerAiCompensation = 4;                                         // was 4 (1.81) was 5 (1.86)
    stage.m_playerAiReduction = 2;                                            // was 2 (1.81) was 2.5 (1.86)  
		stage.m_soldierCapacityModel = "constant";

    stage.m_minRandomCrates = 1; 
    stage.m_maxRandomCrates = 2;

		stage.m_defenseWinTime = 720.0;   // was 600 in 1.65
		stage.m_defenseWinTimeMode = "custom";
		stage.addTracker(PausingKothTimer(m_metagame, stage.m_defenseWinTime));

		{
			Faction f(getFactionConfigs()[0], createFellowCommanderAiCommand(0, 0.3, 0.1));      // was  0.1 0.1 in 1.65
			stage.m_factions.insertLast(f);
		}
		{
			Faction f(getFactionConfigs()[1], createCommanderAiCommand(1, 0.25, 0.05));             // was 0.2 0.1 in 1.65
			f.m_overCapacity = 60;
			f.m_capacityMultiplier = 0.0001;                                                      // was 1.32 in 1.65, now working with offset only
			f.m_capacityOffset = 60;
			stage.m_factions.insertLast(f);
		}
		{
			// neutral
			Faction f(getFactionConfigs()[3], createCommanderAiCommand(2));
			f.m_capacityMultiplier = 0.0;
			stage.m_factions.insertLast(f);
		}

		{
			XmlElement command("command");
			command.setStringAttribute("class", "faction_resources");
			command.setIntAttribute("faction_id", 0);
			addFactionResourceElements(command, "vehicle", array<string> = {"radio_jammer.vehicle", "radio_jammer2.vehicle"}, false);

			stage.m_extraCommands.insertLast(command);
		}

		// metadata
		stage.m_primaryObjective = "koth";
		stage.m_kothTargetBase = "Airfield";
		stage.m_radioObjectivePresent = false;
		
		stage.m_presetBases.insertLast(array<int> = {2,3,6});
		stage.m_presetBases.insertLast(array<int> = {0,4,5});
		stage.m_presetBases.insertLast(array<int> = {1,-1,-1});

		return stage;
	}
}

// generated by atlas.exe
#include "world_init.as"
#include "world_offender_visual.as"
#include "world_marker.as"

// ------------------------------------------------------------------------------------------------
class WorldCampaign : World {
	WorldCampaign(Metagame@ metagame) {
		super(metagame);
	}

	// ------------------------------------------------------------------------------------------------
	protected string getOffenderVisualCommand(string transportName, int colorFactionId, int id) const {
		return getWorldOffenderVisualCommand(transportName, colorFactionId, id);
	}

	// ----------------------------------------------------------------------------
	protected Marker getMarker(string key) const {
		return getWorldMarker(key);
	}

	// ----------------------------------------------------------------------------
	protected string getPosition(string key) const {
		return getWorldPosition(key);
	}

	// ------------------------------------------------------------------------------------------------
	protected string getInitCommand() const {
		return getWorldInitCommand();
	}
}