// declare include paths
#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/wf_base/scripts"
#include "path://media/packages/wf_vanilla_extend/scripts"

#include "gamemode_campaign.as"

// --------------------------------------------
void main(dictionary@ inputData) {
	XmlElement inputSettings(inputData);
	_log("bbstart");
	UserSettings settings;
	settings.m_initialRp = 50;
	settings.m_journalEnabled = true;
	settings.m_fellowDisableEnemySpawnpointsSoldierCountOffset = 2;

	settings.m_difficultyTrackerEnabled = true;
	
	settings.m_testingToolsEnabled = false;
	
	settings.fromXmlElement(inputSettings);
	array<string> overlays = {
		"media/packages/wf_base",
		"media/packages/wf_vanilla_extend"
	};
	settings.m_overlayPaths = overlays;
	_setupLog(inputSettings);
	//_setupLog("dev_verbose");

	//_log("show setting");

/*
11:32:14: SCRIPT: * using savegame name: campaign142
11:32:14: SCRIPT: * using username: MR. GREEN
11:32:14: SCRIPT: * using faction choice: 1
11:32:14: SCRIPT: * using fellow capacity: 1.2
11:32:14: SCRIPT: * using fellow ai accuracy: 0.94
11:32:14: SCRIPT: * using enemy capacity: 1
11:32:14: SCRIPT: * using enemy ai accuracy: 0.94
11:32:14: SCRIPT: * using xp factor: 0.3
11:32:14: SCRIPT: * using rp factor: 1
11:32:14: SCRIPT: * using initial xp: 0
11:32:14: SCRIPT: * using initial rp: 50
11:32:14: SCRIPT: * using max rp: -1
11:32:14: SCRIPT: * using player damage modifier: -0
11:32:14: SCRIPT: * using preset id: 
*/
	settings.print();

	GameModeCampaign metagame(settings);

	metagame.init();
	metagame.run();
	metagame.uninit();

	_log("ending execution");
}
