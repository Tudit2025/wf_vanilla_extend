#include "item_delivery_configurator_invasion.as"

// ------------------------------------------------------------------------------------------------
class ItemDeliveryConfiguratorCampaign : ItemDeliveryConfiguratorInvasion {
	// ------------------------------------------------------------------------------------------------
	ItemDeliveryConfiguratorCampaign(GameModeInvasion@ metagame) {
		super(metagame);
	}
	//m_metagame.m_userSettings.m_factionChoice
	// --------------------------------------------
	protected void processRewardPasses(array<array<ScoredResource@>>@ passes) { 
		// campaign can use this to cleanup unavailable experimental resources in passes 
		array<string> experimental = {
			"emp_grenade.projectile", 
			"repair_crane_resource.weapon", 
			"gps_laptop.weapon"
		};
		for (uint i = 0; i < passes.size(); ++i) {
			for (uint j = 0; j < passes[i].size(); ++j) {
				ScoredResource@ r = passes[i][j];
				if (experimental.find(r.m_key) >= 0) {
					_log("removing experimental scored resource " + r.m_key);
					passes[i].removeAt(j);
					--j;
				}
			}
		}
	}

	// --------------------------------------------
	// -----------------Briefcase-----------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList() const {
		int factionC = m_metagame.getUserSettings().m_factionChoice;
		array<Resource@> list;
		if(factionC==0)
		{
			list.push_back(Resource("m79.weapon", "weapon"));
		}
		else if(factionC==1)
		{
			list.push_back(Resource("gl06.weapon", "weapon"));
		}
		else if(factionC==2)
		{
			list.push_back(Resource("rgm40.weapon", "weapon"));
		}
		else if(factionC==3)
		{
			list.push_back(Resource("hyps_02.weapon", "weapon"));	
		}

		list.push_back(Resource("minig_resource.weapon", "weapon"));
		list.push_back(Resource("desert_eagle.weapon", "weapon"));
		list.push_back(Resource("tow_resource.weapon", "weapon"));   
		list.push_back(Resource("eodvest.carry_item", "carry_item")); 
		list.push_back(Resource("gl_resource.weapon", "weapon"));
		list.push_back(Resource("smaw.weapon", "weapon"));
		list.push_back(Resource("hornet_resource.weapon", "weapon"));		

		return list;
	}

	// --------------------------------------------
	// -----------------Laptop-------------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList2() const {
		int factionC = m_metagame.getUserSettings().m_factionChoice;
		array<Resource@> list;
		if(factionC==0)
		{
			list.push_back(Resource("ump40.weapon", "weapon"));
		}
		else if(factionC==1)
		{
			list.push_back(Resource("mx4_storm.weapon", "weapon"));
		}
		else if(factionC==2)
		{
			list.push_back(Resource("bizon.weapon", "weapon"));
		}
		else if(factionC==3)
		{	
			list.push_back(Resource("vepr_12.weapon", "weapon"));
		}

		list.push_back(Resource("mp5sd.weapon", "weapon"));//kftchhb

		list.push_back(Resource("thermal_grenade.projectile", "projectile")); 
		list.push_back(MultiGroupResource("vest_blackops.carry_item", "carry_item", array<string> = {"default", "supply"}));
		list.push_back(Resource("apr.weapon", "weapon")); 
		list.push_back(MultiGroupResource("mk23.weapon", "weapon", array<string> = {"default", "supply"})); 
		list.push_back(MultiGroupResource("kunai.projectile", "projectile", array<string> = {"supply"}));		

		return list;
	}

	// --------------------------------------------
	// -----------Military Intelligence------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList3() const {
		int factionC = m_metagame.getUserSettings().m_factionChoice;
		array<Resource@> list;
		if(factionC==0)
		{
			list.push_back(Resource("b300.weapon", "weapon"));
			list.push_back(Resource("m16a4_w_m203.weapon", "weapon"));
		}
		else if(factionC==1)
		{
			list.push_back(Resource("m3_carlgustav.weapon", "weapon"));
			list.push_back(Resource("g36_w_ag36.weapon", "weapon"));
		}
		else if(factionC==2)
		{
			list.push_back(Resource("rpg-16.weapon", "weapon"));
			list.push_back(Resource("ak47_w_gp25.weapon", "weapon"));
		}
		else if(factionC==3)
		{
			list.push_back(Resource("lrac_f1.weapon", "weapon"));
			list.push_back(Resource("nr97a_w_qlg.weapon", "weapon"));
		}

//		list.push_back(Resource("panzerfaust_3.weapon", "weapon", array<string> = {"mrap"}));			
//		list.push_back(Resource("g41_w_hk79.weapon", "weapon", array<string> = {"mrap"}));		

		return list;
	}

}
