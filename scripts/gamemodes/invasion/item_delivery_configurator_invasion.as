// generic trackers
#include "item_delivery_objective.as"
#include "item_delivery_organizer.as"
#include "gift_item_delivery_rewarder.as"

// ------------------------------------------------------------------------------------------------
class ItemDeliveryConfiguratorInvasion : ItemDeliveryConfigurator {
	protected GameModeInvasion@ m_metagame;
	protected ItemDeliveryOrganizer@ m_itemDeliveryOrganizer;

	// ------------------------------------------------------------------------------------------------
	ItemDeliveryConfiguratorInvasion(GameModeInvasion@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	void setup(ItemDeliveryOrganizer@ organizer) {
		@m_itemDeliveryOrganizer = @organizer;
		// -------------------------
		setupBriefcaseUnlocks();
		setupEnemyWeaponUnlocks();
		setupLaptopUnlocks();
		setupIcecream();
		// -------------------------
		setupGift1();
		setupGift2();
		setupGift3();
		// -------------------------
		setupCommunity1();	
		setupCommunity2(); 
		setupCommunity3(); 
		setupCommunity4();  
		setupCommunity5();
		setupCommunity6(); 
		setupCommunity7();
		// -------------------------
		setupHalloween1();
		setupHalloween2();
		setupHalloween3();
		// -------------------------
		setupXmasBox();
		// -------------------------
		setupBeachBall();
		setupSummerBox1();
		setupSummerBox2();
		setupSummerBox3();
		// -------------------------
		setupEasterBasket();
		setupEasterEgg1();
		setupEasterEgg2();
		setupEasterEgg3();
		setupEasterEgg4();
		setupEasterEgg5();
		setupEasterEggSilver();
		setupEasterEggGold();
		// -------------------------
		setupTicketSummer();
		setupTicketHalloween();
		setupTicketEaster();
		setupTicketBoxes();
		// -------------------------
		setupWFLaptopUnlocks();
		setupWeaponCrateWF();
		setupWeaponCrateVest();
		// -------------------------
		setupMedalGreen();
		setupMedalGrey();
		setupMedalBrown();
		setupMedalBlue();
		setupMedalWhite();
	}

	// --------------------------------------------
	void refresh() {
		// called each time an item unlock is removed
		refreshEnemyWeaponDeliveryObjectives();
	}

	// --------------------------------------------
	// -------------------Medals-----------------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupMedalGreen() {
		_log("adding medal green config", 1);
		array<Resource@> deliveryList = {
			 Resource("medal_green.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("the_art_of_commander.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("b300.weapon", "weapon", 3.0f, 1),
		ScoredResource("stoner63.weapon", "weapon", 3.0f, 1),
		ScoredResource("m2_hmg.weapon", "weapon", 1.0f, 1),
		ScoredResource("model_500.weapon", "weapon", 3.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupMedalGrey() {
		_log("adding medal grey config", 1);
		array<Resource@> deliveryList = {
			 Resource("medal_grey.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("the_art_of_commander.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("m3_carlgustav.weapon", "weapon", 3.0f, 1),
		ScoredResource("fn_minimi.weapon", "weapon", 3.0f, 1),
		ScoredResource("m2_hmg.weapon", "weapon", 1.0f, 1),
		ScoredResource("psdr_3.weapon", "weapon", 3.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupMedalBrown() {
		_log("adding medal brown config", 1);
		array<Resource@> deliveryList = {
			 Resource("medal_brown.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("the_art_of_commander.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("rpg-16.weapon", "weapon", 3.0f, 1),
		ScoredResource("rpk203.weapon", "weapon", 3.0f, 1),
		ScoredResource("kord_hmg.weapon", "weapon", 1.0f, 1),
		ScoredResource("rsh_12.weapon", "weapon", 3.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupMedalBlue() {
		_log("adding medal blue config", 1);
		array<Resource@> deliveryList = {
			 Resource("medal_blue.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("the_art_of_commander.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("lrac_f1.weapon", "weapon", 3.0f, 1),
		ScoredResource("w95.weapon", "weapon", 3.0f, 1),
		ScoredResource("kord_hmg.weapon", "weapon", 1.0f, 1),
		ScoredResource("raging_judge.weapon", "weapon", 3.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupMedalWhite() {
		_log("adding medal white config", 1);
		array<Resource@> deliveryList = {
			 Resource("medal_white.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("the_art_of_commander.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("panzerfaust_3.weapon", "weapon", 3.0f, 1),
		ScoredResource("mg3.weapon", "weapon", 3.0f, 1),
		ScoredResource("gmw.weapon", "weapon", 1.0f, 1),
		ScoredResource("hkp_11.weapon", "weapon", 3.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	// -------------------Tickets-----------------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupTicketSummer() {
		_log("adding tickets config", 1);
		array<Resource@> deliveryList = {
			 Resource("ticket_summer.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("popsicle.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("orange_juice.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("iced_coffee.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("amethyst.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("pyrite.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("energy_drink.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("beer_can.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_coconut.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_grape.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_mango.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_melon.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_bananas.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_dragonfruit.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("rotten_banana.carry_item", "carry_item", 20.0f, 1),
		ScoredResource("pacific_travel_guide.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("parasol_red.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_blue.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_yellow.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_green.weapon", "weapon", 1.0f, 2),
		ScoredResource("sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 10.0f),
		ScoredResource("cooler_box_1.carry_item", "carry_item", 30.0f),
		ScoredResource("cooler_box_2.carry_item" , "carry_item", 30.0f),
		ScoredResource("cooler_box_3.carry_item", "carry_item", 30.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupTicketHalloween() {
		_log("adding tickets config", 1);
		array<Resource@> deliveryList = {
			 Resource("ticket_halloween.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("balloon.carry_item", "carry_item", 1.0f, 5),
		ScoredResource("banana_peel.projectile", "projectile", 1.0f, 1),
		ScoredResource("rotten_banana.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("halloween_box_1.carry_item", "carry_item", 1.0f),
		ScoredResource("halloween_box_2.carry_item" , "carry_item", 1.0f),
		ScoredResource("halloween_box_3.carry_item" , "carry_item", 1.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupTicketEaster() {
		_log("adding tickets config", 1);
		array<Resource@> deliveryList = {
			 Resource("ticket_easter.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("chocolate.carry_item", "carry_item", 1.0f)
			},
			{
		ScoredResource("rotten_banana.carry_item", "carry_item", 5.0f),
		ScoredResource("easter_egg_1.carry_item", "carry_item", 5.0f),
		ScoredResource("easter_egg_2.carry_item", "carry_item", 5.0f),
		ScoredResource("easter_egg_3.carry_item", "carry_item", 5.0f),
		ScoredResource("easter_egg_4.carry_item", "carry_item", 5.0f),
		ScoredResource("easter_egg_5.carry_item", "carry_item", 5.0f),	
		ScoredResource("easter_basket.carry_item", "carry_item", 5.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupTicketBoxes() {
		_log("adding tickets config", 1);
		array<Resource@> deliveryList = {
			 Resource("ticket_boxes.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("gift_box_1.carry_item", "carry_item", 1.0f),
		ScoredResource("gift_box_2.carry_item", "carry_item", 1.0f),
		ScoredResource("gift_box_3.carry_item", "carry_item", 1.0f)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 10.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_6.carry_item", "carry_item", 13.0f),
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 13.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	// --------------Easter Event------------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupEasterBasket() {
		_log("adding easterbasket config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_basket.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("easter_egg_1.carry_item", "carry_item", 24.0f),
		ScoredResource("easter_egg_2.carry_item", "carry_item", 24.0f),
		ScoredResource("easter_egg_3.carry_item", "carry_item", 24.0f),
		ScoredResource("easter_egg_4.carry_item", "carry_item", 24.0f),
		ScoredResource("egg_gold.carry_item", "carry_item", 4.0f)
			},
			{
		ScoredResource("easter_egg_1.carry_item", "carry_item", 3.0f),
		ScoredResource("easter_egg_2.carry_item", "carry_item", 3.0f),
		ScoredResource("easter_egg_3.carry_item", "carry_item", 3.0f),
		ScoredResource("easter_egg_4.carry_item", "carry_item", 3.0f),
		ScoredResource("egg_resource.weapon", "weapon", 34.0f, 3),
		ScoredResource("egg.projectile" , "projectile", 34.0f, 10),
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupEasterEgg1() {
		_log("adding easteregg1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_egg_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("aks_tishina.weapon", "weapon", 8.0f), 
		ScoredResource("truvelo_amris.weapon", "weapon", 8.0f), 
		ScoredResource("corn_launcher.weapon", "weapon", 4.0f), 
		ScoredResource("qts11.weapon", "weapon", 4.0f), 
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f), 
		ScoredResource("banner_rabbit.weapon" , "weapon", 8.0f),
		ScoredResource("camo_shield.weapon" , "weapon", 6.0f),
		ScoredResource("compound.projectile" , "projectile", 12.0f, 4),
		ScoredResource("chicken_carrier.weapon", "weapon", 12.0f, 5),
		ScoredResource("tracer_dart.weapon", "weapon", 12.0f, 5),
		ScoredResource("torch.weapon", "weapon", 6.0f, 2)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 2.0f),
		ScoredResource("bizarre_carrot.carry_item", "carry_item", 10.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest3.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest_exo.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("beer_can.carry_item", "carry_item", 10.0f),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("sunglasses.carry_item" , "carry_item", 10.0f),	
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 3.0f),
		ScoredResource("cigars.carry_item", "carry_item", 10.0f),
		ScoredResource("gamingdevice.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_pink.carry_item", "carry_item", 10.0f),
		ScoredResource("underpants.carry_item", "carry_item", 10.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEgg2() {
		_log("adding easteregg2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_egg_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("dp64.weapon", "weapon", 8.0f), 
		ScoredResource("mp7_isl200.weapon", "weapon", 8.0f), 
		ScoredResource("m200.weapon", "weapon", 4.0f), 
		ScoredResource("corn_launcher.weapon", "weapon", 4.0f), 
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f), 
		ScoredResource("banner_rabbit.weapon" , "weapon", 8.0f),
		ScoredResource("camo_shield.weapon" , "weapon", 6.0f),
		ScoredResource("balloon.carry_item", "carry_item", 12.0f, 5),
		ScoredResource("vest_repair.weapon", "weapon", 12.0f, 5),
		ScoredResource("fhj01.weapon", "weapon", 12.0f, 5),
		ScoredResource("shovel.weapon", "weapon", 6.0f)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 2.0f),
		ScoredResource("bizarre_carrot.carry_item", "carry_item", 10.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest3.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest_exo.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("chewing_gum.carry_item", "carry_item", 10.0f),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("playing_cards.carry_item" , "carry_item", 10.0f),	
		ScoredResource("gift_box_community_6.carry_item", "carry_item", 3.0f),
		ScoredResource("gem.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_silver.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_green.carry_item", "carry_item", 10.0f),
		ScoredResource("underpants.carry_item", "carry_item", 10.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEgg3() {
		_log("adding easteregg3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_egg_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("tac50.weapon", "weapon", 8.0f), 
		ScoredResource("m4a1_m26.weapon", "weapon", 8.0f), 
		ScoredResource("corn_launcher.weapon", "weapon", 4.0f), 
		ScoredResource("qts11.weapon", "weapon", 4.0f), 
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f), 
		ScoredResource("banner_rabbit.weapon" , "weapon", 8.0f),
		ScoredResource("camo_shield.weapon" , "weapon", 6.0f),
		ScoredResource("gps_laptop.weapon", "weapon", 12.0f, 4),
		ScoredResource("dooms_hammer.projectile" , "projectile", 12.0f, 5),
		ScoredResource("dogbone.projectile", "projectile", 12.0f, 4),
		ScoredResource("dartgun.weapon", "weapon", 6.0f)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 2.0f),
		ScoredResource("bizarre_carrot.carry_item", "carry_item", 10.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest3.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest_exo.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("energy_drink.carry_item", "carry_item", 10.0f),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("dollars.carry_item" , "carry_item", 10.0f),	
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 3.0f),
		ScoredResource("radio.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_yellow.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_red.carry_item", "carry_item", 10.0f),
		ScoredResource("underpants.carry_item", "carry_item", 10.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEgg4() {
		_log("adding easteregg4 config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_egg_4.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("scar_mk13.weapon", "weapon", 8.0f), 
		ScoredResource("mpt76_ak40.weapon", "weapon", 8.0f), 
		ScoredResource("m200.weapon", "weapon", 4.0f), 
		ScoredResource("corn_launcher.weapon", "weapon", 4.0f), 
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f), 
		ScoredResource("banner_rabbit.weapon" , "weapon", 8.0f),
		ScoredResource("camo_shield.weapon" , "weapon", 6.0f),
		ScoredResource("squad_equipment_kit.weapon", "weapon", 12.0f, 5),
		ScoredResource("stim.projectile", "projectile", 12.0f, 5),
		ScoredResource("emp_grenade.projectile", "projectile", 12.0f, 5),
		ScoredResource("shock_paddle.weapon", "weapon", 6.0f)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 2.0f),
		ScoredResource("bizarre_carrot.carry_item", "carry_item", 10.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest3.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest_exo.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("whiskey_bottle.carry_item", "carry_item", 10.0f),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 10.0f),	
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 3.0f),
		ScoredResource("teddy.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_white.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_blue.carry_item", "carry_item", 10.0f),
		ScoredResource("underpants.carry_item", "carry_item", 10.0f)
			}
		};

		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEgg5() {
		_log("adding easteregg5 config", 1);
		array<Resource@> deliveryList = {
			 Resource("easter_egg_5.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("flintlock_1.weapon", "weapon", 8.0f), 
		ScoredResource("qlu_11.weapon", "weapon", 4.0f), 
		ScoredResource("corn_launcher.weapon", "weapon", 4.0f), 
		ScoredResource("chocolate.carry_item", "carry_item", 20.0f), 
		ScoredResource("banner_rabbit.weapon" , "weapon", 8.0f),
		ScoredResource("camo_shield.weapon" , "weapon", 6.0f),
		ScoredResource("squad_equipment_kit.weapon", "weapon", 12.0f, 5),
		ScoredResource("stim.projectile", "projectile", 12.0f, 5),
		ScoredResource("emp_grenade.projectile", "projectile", 12.0f, 5),
		ScoredResource("shock_paddle.weapon", "weapon", 6.0f)
			},
			{
		ScoredResource("lottery.carry_item", "carry_item", 2.0f),
		ScoredResource("bizarre_carrot.carry_item", "carry_item", 8.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest3.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("vest_exo.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("whiskey_bottle.carry_item", "carry_item", 10.0f),
		ScoredResource("banana_peel.projectile", "projectile", 10.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 10.0f),	
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 3.0f),
		ScoredResource("teddy.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_white.carry_item", "carry_item", 10.0f),
		ScoredResource("ipoo_player_blue.carry_item", "carry_item", 10.0f),
		ScoredResource("underpants.carry_item", "carry_item", 10.0f)
			}
		};

		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEggSilver() {
		_log("adding eastereggSilver config", 1);
		array<Resource@> deliveryList = {
			 Resource("egg_silver.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("painting.carry_item", "carry_item", 5.0f),
		ScoredResource("painting_memory.carry_item", "carry_item", 5.0f),
		ScoredResource("painting_sunflower.carry_item", "carry_item", 5.0f),
		ScoredResource("dollars.carry_item", "carry_item", 20.0f),
		ScoredResource("m1887.weapon", "weapon", 5.0f), 
		ScoredResource("flintlock_1.weapon", "weapon", 5.0f)
			},
			{
		ScoredResource("gem.carry_item", "carry_item", 20.0f),
		ScoredResource("collector_m1911.weapon", "weapon", 2.0f), 
		ScoredResource("collector_p08.weapon", "weapon", 2.0f), 
		ScoredResource("kar98k.weapon", "weapon", 1.0f), 
		ScoredResource("stg44.weapon", "weapon", 1.0f), 
		ScoredResource("mp40.weapon", "weapon", 1.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupEasterEggGold() {
		_log("adding eastereggGold config", 1);
		array<Resource@> deliveryList = {
			 Resource("egg_gold.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("gold_bar.carry_item", "carry_item", 30.0f),
		ScoredResource("golden_knife.weapon", "weapon", 20.0f), 
		ScoredResource("desert_eagle_gold.weapon", "weapon", 20.0f), 
		ScoredResource("golden_dragunov_svd.weapon", "weapon", 10.0f), 
		ScoredResource("golden_mp5sd.weapon", "weapon", 15.0f), 
		ScoredResource("golden_ak47.weapon", "weapon", 15.0f)
			},
			{
		ScoredResource("aks_tishina.weapon", "weapon", 7.0f), 
		ScoredResource("dp64.weapon", "weapon", 7.0f), 
		ScoredResource("truvelo_amris.weapon", "weapon", 7.0f), 
		ScoredResource("m4a1_m26.weapon", "weapon", 7.0f), 
		ScoredResource("mpt76_ak40.weapon", "weapon", 7.0f), 
		ScoredResource("scar_mk13.weapon", "weapon", 7.0f), 
		ScoredResource("tac50.weapon", "weapon", 7.0f), 
		ScoredResource("mp7_isl200.weapon", "weapon", 7.0f), 
		ScoredResource("m200.weapon", "weapon", 7.0f), 
		ScoredResource("qts11.weapon", "weapon", 7.0f), 
		ScoredResource("easter_mgl.weapon", "weapon", 30.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	// -----------Weapon Crate WF-----------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupWeaponCrateWF() {
		_log("adding WeaponCrateWF config", 1);
		array<Resource@> deliveryList = {
			 Resource("weapon_crate_wf.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("wf_handbook.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("laptop_wf.carry_item", "carry_item", 5.0f, 1)
			},
			{
		ScoredResource("medical_syringe.weapon", "weapon", 5.0f, 10),
		ScoredResource("puma_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("wf_01_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("darkcat_resource.weapon", "weapon", 5.0f, 2),
		ScoredResource("compound.projectile", "projectile", 5.0f, 5),
		ScoredResource("stlms_terminal.weapon", "weapon", 5.0f, 1),
		ScoredResource("gau_00.weapon", "weapon", 5.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	// -----------Weapon Crate Vest-----------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupWeaponCrateVest() {
		_log("adding WeaponCrateVest config", 1);
		array<Resource@> deliveryList = {
			 Resource("weapon_crate_vest.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("vest_repair.weapon", "weapon", 1.0f, 10)
			},
			{
		ScoredResource("uniform_grenadier.carry_item", "carry_item", 5.0f, 5),
		ScoredResource("uniform_paratrooper.carry_item", "carry_item", 5.0f, 5),
		ScoredResource("uniform_ranger.carry_item", "carry_item", 5.0f, 5),
		ScoredResource("uniform_smedic.carry_item", "carry_item", 5.0f, 5),
		ScoredResource("uniform_mp.carry_item", "carry_item", 5.0f, 5),
		ScoredResource("vest_commander.carry_item", "carry_item", 1.0f, 1)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	// -----------------Unlocks------------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupWFLaptopUnlocks() {
		_log("adding wf laptop unlocks", 1);
		array<Resource@> deliveryList;
		{
			 deliveryList.insertLast(Resource("laptop_wf.carry_item", "carry_item"));
		}

		dictionary unlockList;
		{
			string target = "laptop_wf.carry_item";
			array<Resource@>@ list = getUnlockWeaponList3();
			unlockList.set(target, @list);
		}

		// thanks happens at ResourceUnlocker now instead at ItemDeliveryObjective, in order to avoid it when nothing to unlock anymore
		string thanks = "item objective thanks";
		ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame, "", thanks);

		string instructions = "item objective instruction";
		string mapText = "item objective map text";

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, mapText, "", "", -1 /* loop */)
			);
	}

	// ----------------------------------------------------
	protected void setupLaptopUnlocks() {
		_log("adding laptop unlocks", 1);
		array<Resource@> deliveryList;
		{
			 deliveryList.insertLast(Resource("laptop.carry_item", "carry_item"));
		}

		dictionary unlockList;
		{
			string target = "laptop.carry_item";
			array<Resource@>@ list = getUnlockWeaponList2();
			unlockList.set(target, @list);
		}

		// thanks happens at ResourceUnlocker now instead at ItemDeliveryObjective, in order to avoid it when nothing to unlock anymore
		string thanks = "item objective thanks";
		ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame, "", thanks);

		string instructions = "item objective instruction";
		string mapText = "item objective map text";

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, mapText, "", "", -1 /* loop */)
			);
	}
	
	// ----------------------------------------------------
	protected void setupBriefcaseUnlocks() {
		_log("adding briefcase unlocks", 1);
		array<Resource@> deliveryList;
		{
			 deliveryList.insertLast(Resource("suitcase.carry_item", "carry_item"));
		}

		dictionary unlockList;
		{
			string target = "suitcase.carry_item";
			array<Resource@>@ list = getUnlockWeaponList();
			unlockList.set(target, @list);
		}
		// thanks happens at ResourceUnlocker now instead at ItemDeliveryObjective, in order to avoid it when nothing to unlock anymore
		string thanks = "item objective thanks";
		ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame, "", thanks);

		string instructions = "item objective instruction";
		string mapText = "item objective map text";

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, mapText, "", "", -1 /* loop */)
			);
	}

	// --------------------------------------------
	protected void processRewardPasses(array<array<ScoredResource@>>@ passes) {
		// campaign can use this to cleanup unavailable experimental resources in passes 
	}


	// --------------------------------------------
	// -----------------Gift Boxes----------------
	// --------------------------------------------

	// --------------------------------------------
	protected void setupGift1() {
		_log("adding gift1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("dollars.carry_item", "carry_item", 30.0f),
		ScoredResource("dollars_300.carry_item", "carry_item", 15.0f),
		ScoredResource("cigarettes.carry_item", "carry_item", 30.0f),
		ScoredResource("gem.carry_item", "carry_item", 12.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 6.0f),
		ScoredResource("sawnoff.weapon", "weapon", 4.0f)	  
			},
			{
		ScoredResource("playing_cards.carry_item", "carry_item", 44.0f),
		ScoredResource("underpants.carry_item", "carry_item", 20.0f),
		ScoredResource("vest2.carry_item", "carry_item", 18.0f),
		ScoredResource("vest3.carry_item", "carry_item", 9.0f),
		ScoredResource("laptop.carry_item", "carry_item", 4.0f),
		ScoredResource("xm25.weapon", "weapon", 4.0f),
		ScoredResource("ares_shrike.weapon", "weapon", 2.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupGift2() {
		_log("adding gift2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{	
		ScoredResource("dollars_300.carry_item", "carry_item", 22.0f),
		ScoredResource("dollars.carry_item", "carry_item", 8.0f),
		ScoredResource("gem.carry_item", "carry_item", 38.0f),
		ScoredResource("costume_clown.carry_item", "carry_item", 11.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 8.0f),
		ScoredResource("laptop.carry_item", "carry_item", 6.0f),
		ScoredResource("suitcase.carry_item", "carry_item", 4.0f),
		ScoredResource("ares_shrike.weapon", "weapon", 4.0f)
			},
			{ 
		ScoredResource("underpants.carry_item", "carry_item", 25.0f),
		ScoredResource("vest3.carry_item", "carry_item", 16.0f),
		ScoredResource("teddy.carry_item", "carry_item", 15.0f), 
		ScoredResource("cigars.carry_item", "carry_item", 25.0f),
		ScoredResource("mk23.weapon", "weapon", 7.0f),
		ScoredResource("honey_badger.weapon", "weapon", 2.0f),
		ScoredResource("m60e4.weapon", "weapon", 2.0f),
		ScoredResource("gift_box_3.carry_item", "carry_item", 8.0f)		 
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupGift3() {
		_log("adding gift3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("dollars_300.carry_item", "carry_item", 8.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 36.0f),
		ScoredResource("gem.carry_item", "carry_item", 15.0f),
		ScoredResource("desert_eagle_gold.weapon", "weapon", 8.0f),
		ScoredResource("mp7.weapon", "weapon", 4.0f),
		ScoredResource("painting.carry_item", "carry_item", 16.0f),
		ScoredResource("ares_shrike.weapon", "weapon", 7.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 4.0f),
		ScoredResource("golden_dragunov_svd.weapon", "weapon", 2.0f)		
			},
			{
		ScoredResource("vest_blackops.carry_item", "carry_item", 25.0f),
		ScoredResource("suitcase.carry_item", "carry_item", 20.0f),
		ScoredResource("laptop.carry_item", "carry_item", 17.0f),
		ScoredResource("costume_werewolf.carry_item", "carry_item", 15.0f),
		ScoredResource("cd.carry_item", "carry_item", 10.0f),
		ScoredResource("honey_badger.weapon", "weapon", 3.0f),
		ScoredResource("m60e4.weapon", "weapon", 3.0f),
		ScoredResource("paw20.weapon", "weapon", 2.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 5.0f),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 5.0f)				
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	
	// --------------------------------------------
	// --------------Halloween Event------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupHalloween1() {
		_log("adding halloween box 1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("halloween_box_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("costume_chicken.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("costume_bat.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("costume_butcher.carry_item" , "carry_item", 6.0f, 1),
		ScoredResource("costume_lizard.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_clown.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("banner_rwr.weapon" , "weapon", 5.0f),
		ScoredResource("banner_ee.weapon", "weapon", 8.0f),
		ScoredResource("banner_voting_0.weapon", "weapon", 8.0f),
		ScoredResource("banner_smile.weapon", "weapon", 7.0f),
		ScoredResource("scythe.weapon", "weapon", 18.0f),
		ScoredResource("banner_president.weapon", "weapon", 5.0f),
		ScoredResource("chainsaw.weapon", "weapon", 10.0f),
		ScoredResource("lijia_pumpkin_spawn.projectile", "projectile", 12.0f, 2),
		ScoredResource("balloon.carry_item", "carry_item", 8.0f, 5)
			},
			{
		ScoredResource("shock_paddle.weapon" , "weapon", 6.0f),
		ScoredResource("g3_1x.weapon", "weapon", 5.0f),
		ScoredResource("golden_dragunov_svd.weapon", "weapon", 4.0f),
		ScoredResource("dp28.weapon", "weapon", 5.0f),
		ScoredResource("m14k.weapon", "weapon", 4.0f),
		ScoredResource("qbz95.weapon", "weapon", 5.0f),
		ScoredResource("fd338.weapon", "weapon", 4.0f),
		ScoredResource("torch.weapon", "weapon", 9.0f, 2),
		ScoredResource("vampire.projectile", "projectile", 7.0f, 10),
		ScoredResource("werewolf.projectile", "projectile", 7.0f, 10),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 5.0f, 1),	
		ScoredResource("costume_underpants.carry_item" , "carry_item", 4.0f, 1),
		ScoredResource("costume_werewolf.carry_item" , "carry_item", 12.0f, 2),
		ScoredResource("costume_scream.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("costume_banana.carry_item" , "carry_item", 3.0f, 1),
		ScoredResource("evil_pumpkin.projectile", "projectile", 7.0f, 10)
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupHalloween2() {
		_log("adding halloween box 2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("halloween_box_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("costume_chicken.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("costume_bat.carry_item" , "carry_item", 5.0f, 2),
		ScoredResource("costume_butcher.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_lizard.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_clown.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_coin.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("compound.projectile" , "projectile", 20.0f, 4),
		ScoredResource("banner_rwr.weapon" , "weapon", 5.0f),
		ScoredResource("banner_ee.weapon", "weapon", 8.0f),
		ScoredResource("banner_voting_0.weapon", "weapon", 8.0f),
		ScoredResource("banner_smile.weapon", "weapon", 7.0f),
		ScoredResource("scythe.weapon", "weapon", 18.0f),
		ScoredResource("banner_president.weapon", "weapon", 5.0f),
		ScoredResource("chainsaw.weapon", "weapon", 10.0f),
		ScoredResource("lijia_pumpkin_spawn.projectile", "projectile", 12.0f, 2),
		ScoredResource("dogbone.projectile", "projectile", 8.0f, 4),
		ScoredResource("balloon.carry_item", "carry_item", 8.0f, 5)
			},
			{
		ScoredResource("galil.weapon", "weapon", 5.0f),
		ScoredResource("chiapparhino.weapon", "weapon", 5.0f),
		ScoredResource("m1_garand_m.weapon", "weapon", 5.0f),
		ScoredResource("rg6_a.weapon", "weapon", 5.0f),
		ScoredResource("hunting_crossbow_h.weapon", "weapon", 5.0f),
		ScoredResource("gm94.weapon", "weapon", 5.0f),
		ScoredResource("gun_tommy.weapon", "weapon", 5.0f),
		ScoredResource("gun_lewis.weapon", "weapon", 5.0f),
		ScoredResource("vampire.projectile", "projectile", 7.0f, 10),
		ScoredResource("werewolf.projectile", "projectile", 7.0f, 10),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 5.0f, 1),	
		ScoredResource("costume_underpants.carry_item" , "carry_item", 4.0f, 1),
		ScoredResource("costume_werewolf.carry_item" , "carry_item", 12.0f, 2),
		ScoredResource("costume_scream.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("costume_banana.carry_item" , "carry_item", 3.0f, 1),
		ScoredResource("evil_pumpkin.projectile", "projectile", 7.0f, 10)
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupHalloween3() {
		_log("adding halloween box 3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("halloween_box_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("costume_chicken.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("costume_bat.carry_item" , "carry_item", 5.0f, 2),
		ScoredResource("costume_butcher.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_lizard.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_clown.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_coin.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("compound.projectile" , "projectile", 12.0f, 4),
		ScoredResource("emp_grenade.projectile", "projectile", 6.0f, 5),
		ScoredResource("banner_ee.weapon", "weapon", 5.0f),
		ScoredResource("banner_voting_0.weapon", "weapon", 5.0f),
		ScoredResource("banner_smile.weapon", "weapon", 5.0f),
		ScoredResource("scythe.weapon", "weapon", 8.0f),
		ScoredResource("banner_president.weapon", "weapon", 5.0f),
		ScoredResource("lijia_pumpkin_spawn.projectile", "projectile", 6.0f, 2),
		ScoredResource("dogbone.projectile", "projectile", 10.0f, 4),
		ScoredResource("balloon.carry_item", "carry_item", 8.0f, 5),
		ScoredResource("hand_axe.weapon", "weapon", 8.0f, 30),
		ScoredResource("whoopee_cushion.projectile", "projectile", 10.0f, 10)
			},
			{
		ScoredResource("beowulf.weapon", "weapon", 7.0f),
		ScoredResource("apr308s.weapon", "weapon", 7.0f),
		ScoredResource("fn57.weapon", "weapon", 7.0f),
		ScoredResource("sa81.weapon", "weapon", 4.0f),
		ScoredResource("origin_12.weapon", "weapon", 7.0f),
		ScoredResource("fmg9.weapon", "weapon", 7.0f),
		ScoredResource("can_cannon.weapon", "weapon", 7.0f),
		ScoredResource("torch.weapon", "weapon", 6.0f, 2),
		ScoredResource("headtaker.weapon", "weapon", 4.0f),
		ScoredResource("vampire.projectile", "projectile", 7.0f, 10),
		ScoredResource("werewolf.projectile", "projectile", 7.0f, 10),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 6.0f, 1),
		ScoredResource("costume_werewolf.carry_item" , "carry_item", 12.0f, 2),
		ScoredResource("costume_scream.carry_item" , "carry_item", 10.0f, 2),
		ScoredResource("evil_pumpkin.projectile", "projectile", 7.0f, 10)
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	// --------------Xmas Event------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupXmasBox() {
		_log("adding xmas box config", 1);
		array<Resource@> deliveryList = {
			 Resource("xmas_box.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("banner_santa.weapon" , "weapon", 10.0f),
		ScoredResource("banner_gingerbread.weapon" , "weapon", 10.0f),
		ScoredResource("banner_rwr.weapon" , "weapon", 4.0f),
		ScoredResource("xmas_tree_resource.weapon" , "weapon", 20.0f, 5),
		ScoredResource("gift_box_1.carry_item", "carry_item", 10.0f, 1),
		ScoredResource("gift_box_2.carry_item", "carry_item", 8.0f, 1),
		ScoredResource("gift_box_3.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_6.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 4.0f, 1),
		ScoredResource("balloon.carry_item", "carry_item", 8.0f, 5),
		ScoredResource("snowball.projectile", "projectile", 12.0f, 20)
			},
			{
		ScoredResource("costume_santa.carry_item", "carry_item", 20.0f, 2),
		ScoredResource("lottery.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("xmas_candycane.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("xmas_bell.carry_item", "carry_item", 10.0f, 3),
		ScoredResource("xmas_biscuit.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("xmas_stocking.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("jeep_xmas_flare.projectile", "projectile", 15.0f, 3),
		ScoredResource("chocolate.carry_item", "carry_item", 7.0f, 1),
		ScoredResource("teddy.carry_item", "carry_item", 7.0f, 1),
		ScoredResource("gamingdevice.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("xmas_rl.weapon" , "weapon", 1.0f, 1)
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	// --------------Summer Event--------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupBeachBall() {
		_log("adding BeachBall config", 1);
		array<Resource@> deliveryList = {
			 Resource("beach_ball.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("fruit_coconut.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_grape.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_mango.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_melon.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_bananas.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_dragonfruit.carry_item", "carry_item", 1.0f, 1)
        	},
			{
		ScoredResource("cooler_box_1.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("cooler_box_2.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("cooler_box_3.carry_item", "carry_item", 5.0f, 1),
		ScoredResource("popsicle.carry_item", "carry_item", 17.0f, 1),
		ScoredResource("orange_juice.carry_item", "carry_item", 12.0f, 1),
		ScoredResource("iced_coffee.carry_item", "carry_item", 17.0f, 1),
		ScoredResource("energy_drink.carry_item", "carry_item", 12.0f, 1),
		ScoredResource("beer_can.carry_item", "carry_item", 12.0f, 1),
		ScoredResource("whoopee_cushion.projectile", "projectile", 15.0f, 5)
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupSummerBox1() {
		_log("adding sb1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("cooler_box_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
        ScoredResource("popsicle.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("orange_juice.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("iced_coffee.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("amethyst.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("pyrite.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("energy_drink.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("beer_can.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_coconut.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_grape.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_mango.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_melon.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_bananas.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_dragonfruit.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("banana_peel.projectile", "projectile", 1.0f, 1),
		ScoredResource("rotten_banana.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("pacific_travel_guide.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("parasol_red.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_blue.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_yellow.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_green.weapon", "weapon", 1.0f, 2),
		ScoredResource("sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("gift_box_community_2.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("gift_box_community_3.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("gift_box_community_4.carry_item", "carry_item", 1.0f, 1)
        	},
			{
		ScoredResource("water_gun.weapon", "weapon", 8.0f, 3),
		ScoredResource("lounger_resource.weapon", "weapon", 8.0f, 5),
		ScoredResource("vulcan_acav_flare.projectile", "projectile", 6.0f, 2),
		ScoredResource("zjx19_flare.projectile", "projectile", 6.0f, 2),
		ScoredResource("taser.weapon", "weapon", 6.0f),
		ScoredResource("m202_flash.weapon", "weapon", 6.0f, 4),
		ScoredResource("costume_fancy_sunglasses.carry_item", "carry_item", 8.0f, 2),
		ScoredResource("banner_clover.weapon", "weapon", 8.0f, 1),
		ScoredResource("squad_equipment_kit_navy.weapon", "weapon", 5.0f, 10),
		
		ScoredResource("fv101_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("hovercraft_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("m551_flare.projectile", "projectile", 5.0f, 2), 
		
		ScoredResource("fhj01.weapon", "weapon", 7.0f, 5),
		ScoredResource("m249.weapon", "weapon", 5.0f, 1),
		ScoredResource("ksg_b.weapon", "weapon", 4.0f, 1),
		ScoredResource("m14ebr.weapon", "weapon", 4.0f, 1),
		ScoredResource("chinalake.weapon", "weapon", 3.0f, 1),
		ScoredResource("ar15_th.weapon", "weapon", 3.0f, 1),
		ScoredResource("mrl_resource.weapon", "weapon", 2.0f, 1)
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupSummerBox2() {
		_log("adding sb2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("cooler_box_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
        ScoredResource("popsicle.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("orange_juice.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("iced_coffee.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("amethyst.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("pyrite.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("energy_drink.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("beer_can.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_coconut.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_grape.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_mango.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_melon.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_bananas.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_dragonfruit.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("banana_peel.projectile", "projectile", 1.0f, 1),
		ScoredResource("rotten_banana.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("pacific_travel_guide.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("parasol_red.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_blue.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_yellow.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_green.weapon", "weapon", 1.0f, 2),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("gift_box_community_6.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("water_gun.weapon", "weapon", 8.0f, 5),
		ScoredResource("lounger_resource.weapon", "weapon", 8.0f, 5),
		ScoredResource("costume_fancy_sunglasses.carry_item", "carry_item", 8.0f, 2),
		ScoredResource("banner_clover.weapon", "weapon", 8.0f, 1),
		ScoredResource("squad_equipment_kit_navy.weapon", "weapon", 5.0f, 10),
		ScoredResource("aav7_flare.projectile", "projectile", 6.0f, 2),
		ScoredResource("wiesel_flare.projectile", "projectile", 6.0f, 2),
		ScoredResource("tracer_dart.weapon", "weapon", 6.0f, 5),
		ScoredResource("fv101_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("hovercraft_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("m551_flare.projectile", "projectile", 5.0f, 2),  
		
		ScoredResource("fhj01.weapon", "weapon", 6.0f, 5),
		ScoredResource("rpk16.weapon", "weapon", 4.0f, 1),
		ScoredResource("ots14.weapon", "weapon", 4.0f, 1),
		ScoredResource("sv98.weapon", "weapon", 4.0f, 1),
		ScoredResource("vks.weapon", "weapon", 4.0f, 1),
		ScoredResource("qlz87_b.weapon", "weapon", 4.0f, 1),
		ScoredResource("ks23_b.weapon", "weapon", 4.0f, 1)

			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupSummerBox3() {
		_log("adding sb3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("cooler_box_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
        ScoredResource("popsicle.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("orange_juice.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("iced_coffee.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("amethyst.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("pyrite.carry_item", "carry_item", 2.0f, 1),
        ScoredResource("energy_drink.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("beer_can.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fruit_coconut.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_grape.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_mango.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_melon.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_bananas.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("fruit_dragonfruit.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("banana_peel.projectile", "projectile", 1.0f, 1),
		ScoredResource("rotten_banana.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("pacific_travel_guide.carry_item", "carry_item", 2.0f, 1),
		ScoredResource("sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("parasol_red.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_blue.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_yellow.weapon", "weapon", 1.0f, 2),
		ScoredResource("parasol_green.weapon", "weapon", 1.0f, 2),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 1.0f, 1),
        ScoredResource("gift_box_community_6.carry_item", "carry_item", 1.0f, 1),
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 1.0f, 1)
			},
			{
		ScoredResource("water_gun.weapon", "weapon", 8.0f, 3),
		ScoredResource("lounger_resource.weapon", "weapon", 8.0f, 5),
		
		ScoredResource("costume_fancy_sunglasses.carry_item", "carry_item", 8.0f, 2),
		ScoredResource("banner_clover.weapon", "weapon", 8.0f, 1),
		ScoredResource("squad_equipment_kit_navy.weapon", "weapon", 5.0f, 10),
		
		ScoredResource("fv101_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("hovercraft_flare.projectile", "projectile", 5.0f, 2),
		ScoredResource("m551_flare.projectile", "projectile", 5.0f, 2),  
		ScoredResource("emp_grenade.projectile", "projectile", 6.0f, 5),
		ScoredResource("flamer_tank_flare.projectile", "projectile", 6.0f, 2),
		ScoredResource("torch.weapon", "weapon", 6.0f, 2),
		ScoredResource("vest_repair.weapon", "weapon", 5.0f, 10),
		ScoredResource("fhj01.weapon", "weapon", 5.0f, 5),
		ScoredResource("benelli_m3.weapon", "weapon", 5.0f, 1),
		ScoredResource("mag7.weapon", "weapon", 5.0f, 1),
		ScoredResource("hcar_3x.weapon", "weapon", 5.0f, 1),
		ScoredResource("ac556.weapon", "weapon", 5.0f, 1)
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	// ------------Community Boxes------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupCommunity1() {
		_log("adding community box 1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("gold_bar.carry_item", "carry_item", 22.0f),
		ScoredResource("costume_lizard.carry_item", "carry_item", 20.0f),
		ScoredResource("tracer_dart.weapon", "weapon", 40.0f, 5),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 7.0f),   
		ScoredResource("g3_1x.weapon", "weapon", 3.0f),
		ScoredResource("flamethrower.weapon", "weapon", 15.0f),
		ScoredResource("javelin_ap.weapon", "weapon", 3.0f)		 
			},
			{
		ScoredResource("banana_car_flare.projectile", "projectile", 20.0f, 2),
		ScoredResource("costume_underpants.carry_item", "carry_item", 20.0f),
		ScoredResource("taser.weapon", "weapon", 20.0f),
		ScoredResource("aa12_frag.weapon", "weapon", 15.0f),
		ScoredResource("wiesel_flare.projectile", "projectile", 20.0f, 2),
		ScoredResource("camo_vest.carry_item", "carry_item", 20.0f),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 5.0f)				  
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity2() {
		_log("adding community box 2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("golden_knife.weapon", "weapon", 15.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 5.0f),
		ScoredResource("shock_paddle.weapon" , "weapon", 5.0f),
		ScoredResource("m16a4_support.weapon", "weapon", 20.0f),		
		ScoredResource("dooms_hammer.projectile", "projectile", 35.0f, 5),
		ScoredResource("banana_peel.projectile", "projectile", 15.0f, 20),
		ScoredResource("javelin_ap.weapon", "weapon", 5.0f)		 
			},
			{
		ScoredResource("costume_banana.carry_item", "carry_item", 25.0f),
		ScoredResource("fal_bayonet.weapon", "weapon", 20.0f),
		ScoredResource("dartgun.weapon", "weapon", 10.0f),
		ScoredResource("l30p.weapon", "weapon", 10.0f),
		ScoredResource("tti.weapon", "weapon", 15.0f),		 
		ScoredResource("aav7_flare.projectile", "projectile", 20.0f, 2)
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity3() {
		_log("adding community box 3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("ump40.weapon", "weapon", 10.0f), 
		ScoredResource("mx4_storm.weapon", "weapon", 10.0f),
		ScoredResource("bizon.weapon", "weapon", 10.0f),
		ScoredResource("dragons_breath.weapon", "weapon", 8.0f), 
		ScoredResource("enforcer.weapon", "weapon", 8.0f),
		ScoredResource("squall.weapon", "weapon", 8.0f),
		ScoredResource("chainsaw.weapon", "weapon", 10.0f),
		ScoredResource("qbz95.weapon", "weapon", 5.0f),
		ScoredResource("emp_grenade.projectile", "projectile", 16.0f, 10),
		ScoredResource("kunai.projectile", "projectile", 15.0f, 20)
			},
			{
		ScoredResource("gps_laptop.weapon", "weapon", 17.0f, 5),
		ScoredResource("hornet_resource.weapon", "weapon", 15.0f, 2), 
		ScoredResource("repair_crane_resource.weapon", "weapon", 15.0f, 2),
		ScoredResource("squall.weapon", "weapon", 8.0f),
		ScoredResource("costume_butcher.carry_item", "carry_item", 12.0f),		
		ScoredResource("vest_repair.weapon", "weapon", 15.0f, 10), 
		ScoredResource("guntruck_flare.projectile", "projectile", 10.0f, 2),
		ScoredResource("vulcan_acav_flare.projectile", "projectile", 8.0f, 2)
			} 
		};   

		processRewardPasses(rewardPasses);
	
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity4() {
		_log("adding community box 4 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_4.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("lottery.carry_item", "carry_item", 25.0f), 
		ScoredResource("tkb059.weapon", "weapon", 5.0f),
		ScoredResource("compound_bow.weapon", "weapon", 10.0f),
		ScoredResource("blowgun.weapon", "weapon", 12.0f),
		ScoredResource("g11.weapon", "weapon", 20.0f),
		ScoredResource("pf98.weapon", "weapon", 8.0f),				  
		ScoredResource("icecream.projectile", "projectile", 20.0f, 1)
			},
			{
		ScoredResource("gepard_m6_lynx.weapon", "weapon", 8.0f),
		ScoredResource("fd338.weapon", "weapon", 5.0f),
		ScoredResource("golden_ak47.weapon", "weapon", 8.0f), 
		ScoredResource("zjx19_flare.projectile", "projectile", 15.0f, 2),
		ScoredResource("portable_mortar.weapon", "weapon", 10.0f),
		ScoredResource("rgm40.weapon", "weapon", 18.0f), 
		ScoredResource("gl06.weapon", "weapon", 18.0f),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 6.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 6.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 6.0f),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 6.0f)
			} 
		};   

		processRewardPasses(rewardPasses);
	
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity5() {
		_log("adding community box 5 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_5.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("balloon.carry_item", "carry_item", 20.0f, 10),
		ScoredResource("vest_exo.carry_item", "carry_item", 25.0f, 5),
		ScoredResource("suomi.weapon", "weapon", 10.0f),
		ScoredResource("ninjato.weapon", "weapon", 20.0f),
		ScoredResource("noxe_flare.projectile", "projectile", 15.0f, 2),
		ScoredResource("m528_flare.projectile", "projectile", 15.0f, 2),
		ScoredResource("m320.weapon", "weapon", 15.0f),
		ScoredResource("p416.weapon", "weapon", 10.0f)

			},
			{
		ScoredResource("stim.projectile", "projectile", 25.0f, 10), 
		ScoredResource("flamer_tank_flare.projectile", "projectile", 15.0f, 2),
		ScoredResource("sev90_flare.projectile", "projectile", 15.0f, 2),
		ScoredResource("chicken_carrier.weapon", "weapon", 10.0f, 5),
		ScoredResource("squad_equipment_kit.weapon", "weapon", 15.0f, 10),
		ScoredResource("m14k.weapon", "weapon", 4.0f),
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 4.0f),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 4.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 4.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 4.0f)
			} 
		};   

		processRewardPasses(rewardPasses);
	
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity6() {
		_log("adding community box 6 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_6.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		 
		 ScoredResource("kulakov.weapon", "weapon", 10.0f),
		 ScoredResource("rpd.weapon", "weapon", 15.0f),
		 ScoredResource("ak47_w_gp25.weapon", "weapon", 14.0f),
		 ScoredResource("g36_w_ag36.weapon", "weapon", 14.0f),
		 ScoredResource("m16a4_w_m203.weapon", "weapon", 14.0f),
		 ScoredResource("mac10.weapon", "weapon", 20.0f),
		 ScoredResource("ash12.weapon", "weapon", 9.0f),
		 ScoredResource("torch.weapon", "weapon", 4.0f, 2)

			},
			{
		 ScoredResource("ultimax.weapon", "weapon", 10.0f),
		 ScoredResource("zweihander.weapon", "weapon", 20.0f), 
		 ScoredResource("sabre.weapon", "weapon", 20.0f),
		 ScoredResource("doublebarrel.weapon", "weapon", 20.0f),
		 ScoredResource("golden_mp5sd.weapon", "weapon", 12.0f),
		 ScoredResource("gift_box_community_4.carry_item", "carry_item", 3.0f),
		 ScoredResource("gift_box_community_3.carry_item", "carry_item", 4.0f),
		 ScoredResource("gift_box_community_5.carry_item", "carry_item", 6.0f),
		 ScoredResource("gift_box_community_2.carry_item", "carry_item", 5.0f)
			} 
		};

		processRewardPasses(rewardPasses);
	
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}	
	
	// ----------------------------------------------------
	protected void setupCommunity7() {
		_log("adding community box 7 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_7.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("gilboa_dbr.weapon", "weapon", 12.0f),
		ScoredResource("mgv176.weapon", "weapon", 13.0f),
		ScoredResource("mpx.weapon", "weapon", 11.0f),
		ScoredResource("sks.weapon", "weapon", 11.0f),
		ScoredResource("costume_panda.carry_item", "carry_item", 12.0f, 2),
		ScoredResource("lailv-002_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("mmls-528_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("gps_laptop.weapon", "weapon", 11.0f, 5),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 2.0f),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 2.0f),
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 2.0f)
			},
			{
		ScoredResource("dogbone.projectile", "projectile", 18.0f, 4),
		ScoredResource("shovel.weapon", "weapon", 16.0f),
		ScoredResource("sbl.weapon", "weapon", 12.0f),
		ScoredResource("lai-109_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("f1_flare.projectile", "projectile", 12.0f, 2),		 
		ScoredResource("an94.weapon", "weapon", 14.0f),  
		ScoredResource("rotten_banana.carry_item", "carry_item", 10.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 2.0f),
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 2.0f),
		ScoredResource("gift_box_community_6.carry_item", "carry_item", 2.0f)
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	// ------------------Lottery------------------
	// --------------------------------------------

	// ----------------------------------------------------
	protected void setupIcecream() {
		_log("adding icecream van config", 1);
		array<Resource@> deliveryList = {
			 Resource("lottery.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{

		ScoredResource("icecream.projectile", "projectile", 1.0f, 1)
   
			},  		
			{

		ScoredResource("cigarettes.carry_item", "carry_item", 40.0f),
		ScoredResource("playing_cards.carry_item", "carry_item", 39.0f),
		ScoredResource("cigars.carry_item", "carry_item", 38.0f),
		ScoredResource("dollars.carry_item", "carry_item", 37.0f),
		ScoredResource("teddy.carry_item", "carry_item", 36.0f),		
		ScoredResource("dollars_300.carry_item", "carry_item", 35.0f),
		ScoredResource("gem.carry_item", "carry_item", 34.0f),
		ScoredResource("laptop.carry_item", "carry_item", 33.0f),
		ScoredResource("suitcase.carry_item", "carry_item", 32.0f), 
   		ScoredResource("painting.carry_item", "carry_item", 31.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 30.0f),
		ScoredResource("cd.carry_item", "carry_item", 19.0f),		
					
		ScoredResource("gift_box_1.carry_item", "carry_item", 38.0f),
		ScoredResource("gift_box_2.carry_item", "carry_item", 19.0f),
		ScoredResource("gift_box_3.carry_item", "carry_item", 10.0f),
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 10.0f),
		ScoredResource("gift_box_community_2.carry_item", "carry_item", 10.0f),
		ScoredResource("gift_box_community_3.carry_item", "carry_item", 10.0f), 
		ScoredResource("gift_box_community_4.carry_item", "carry_item", 10.0f),					   
		ScoredResource("gift_box_community_5.carry_item", "carry_item", 10.0f),		 
		ScoredResource("gift_box_community_6.carry_item", "carry_item", 10.0f),		 
		ScoredResource("gift_box_community_7.carry_item", "carry_item", 10.0f),		 

		ScoredResource("underpants.carry_item", "carry_item", 60.0f, 2),
		ScoredResource("rotten_banana.carry_item", "carry_item", 60.0f, 5),
		ScoredResource("costume_clown.carry_item", "carry_item", 30.0f, 2),
		ScoredResource("costume_banana.carry_item", "carry_item", 25.0f, 2),
		ScoredResource("costume_lizard.carry_item", "carry_item", 20.0f, 2),				
		ScoredResource("costume_werewolf.carry_item", "carry_item", 15.0f, 2),		
		ScoredResource("vest2.carry_item", "carry_item", 28.0f, 5),
		ScoredResource("vest_blackops.carry_item", "carry_item", 25.0f, 5),
		ScoredResource("costume_butcher.carry_item", "carry_item", 20.0f, 2),
		ScoredResource("camo_vest.carry_item", "carry_item", 30.0f, 4),				
		ScoredResource("vest3.carry_item", "carry_item", 20.0f, 5),
		
		ScoredResource("banana_peel.projectile", "projectile", 60.0f, 2),
		ScoredResource("mk23.weapon", "weapon", 40.0f),
		ScoredResource("gps_laptop.weapon", "weapon", 40.0f, 5),
		ScoredResource("shuriken.projectile", "projectile", 39.0f, 20), 
		ScoredResource("kunai.projectile", "projectile", 39.0f, 20),		
		ScoredResource("emp_grenade.projectile", "projectile", 40.0f, 5),				
		ScoredResource("desert_eagle_gold.weapon", "weapon", 38.0f),
		ScoredResource("taser.weapon", "weapon", 37.0f),	
		ScoredResource("dooms_hammer.projectile", "projectile", 36.0f, 5),		 
	 	ScoredResource("ump40.weapon", "weapon", 35.0f),
		ScoredResource("emp_grenade.projectile", "projectile", 34.0f, 10),	   
		ScoredResource("mx4_storm.weapon", "weapon", 33.0f),
		ScoredResource("bizon.weapon", "weapon", 32.0f),
		ScoredResource("m202_flash.weapon", "weapon", 31.0f, 4),
		ScoredResource("steyr_aug.weapon", "weapon", 30.0f),
		ScoredResource("vest_repair.weapon", "weapon", 30.0f, 5),		   
		ScoredResource("jackhammer.weapon", "weapon", 28.0f),					   
		ScoredResource("xm25.weapon", "weapon", 20.0f),
		ScoredResource("sawnoff.weapon", "weapon", 26.0f),
		ScoredResource("l30p.weapon", "weapon", 25.0f),	 
		ScoredResource("chain_saw.weapon", "weapon", 24.0f),
		ScoredResource("vss_vintorez.weapon", "weapon", 24.0f),
		ScoredResource("ns2000.weapon", "weapon", 24.0f),			  
		ScoredResource("pecheneg_bullpup.weapon", "weapon", 23.0f),		
		ScoredResource("aa12_frag.weapon", "weapon", 22.0f),		
		ScoredResource("mp7.weapon", "weapon", 21.0f),
		ScoredResource("tti.weapon", "weapon", 20.0f), 
		ScoredResource("musket.weapon", "weapon", 19.0f), 
		ScoredResource("barrett_m107.weapon", "weapon", 18.0f),		
		ScoredResource("m16a4_support.weapon", "weapon", 17.0f),
		ScoredResource("tracer_dart.weapon", "weapon", 16.0f, 5), 
		ScoredResource("kriss_vector.weapon", "weapon", 15.0f),								
		ScoredResource("ares_shrike.weapon", "weapon", 14.0f),
		ScoredResource("vest_repair.weapon", "weapon", 13.0f, 10),		
		ScoredResource("scarssr.weapon", "weapon", 12.0f),
		ScoredResource("paw20.weapon", "weapon", 11.0f),
		ScoredResource("golden_knife.weapon", "weapon", 10.0f),		
		ScoredResource("chainsaw.weapon", "weapon", 10.0f),	   
		ScoredResource("fal_bayonet.weapon", "weapon", 10.0f), 
		ScoredResource("microgun.weapon", "weapon", 10.0f),
		ScoredResource("stoner62.weapon", "weapon", 10.0f),		
		ScoredResource("squall.weapon", "weapon", 8.0f),			   
		ScoredResource("enforcer.weapon", "weapon", 8.0f),
		ScoredResource("dragons_breath.weapon", "weapon", 7.0f),		
		ScoredResource("flamethrower.weapon", "weapon", 7.0f), 
		ScoredResource("dartgun.weapon", "weapon", 7.0f),					   
		ScoredResource("javelin_ap.weapon", "weapon", 6.0f),
		ScoredResource("honey_badger.weapon", "weapon", 5.0f),
		ScoredResource("milkor_mgl.weapon", "weapon", 5.0f),
		ScoredResource("m60e4.weapon", "weapon", 4.0f),
		ScoredResource("lahti_l39.weapon", "weapon", 4.0f),
		ScoredResource("mg42.weapon", "weapon", 4.0f),
		ScoredResource("tkb059.weapon", "weapon", 4.0f),
		ScoredResource("compound_bow.weapon", "weapon", 10.0f),
		ScoredResource("blowgun.weapon", "weapon", 12.0f),
		ScoredResource("g11.weapon", "weapon", 8.0f),
		ScoredResource("pf98.weapon", "weapon", 8.0f),				  
		ScoredResource("gepard_m6_lynx.weapon", "weapon", 7.0f),
		ScoredResource("golden_ak47.weapon", "weapon", 5.0f), 
		ScoredResource("zjx19_flare.projectile", "projectile", 8.0f, 2),
		ScoredResource("portable_mortar.weapon", "weapon", 6.0f),
		ScoredResource("rgm40.weapon", "weapon", 25.0f), 
		ScoredResource("gl06.weapon", "weapon", 25.0f),					 
 
		ScoredResource("banana_car_flare.projectile", "projectile", 40.0f, 2),
		ScoredResource("hornet_resource.weapon", "weapon", 50.0f, 2),		
		ScoredResource("repair_crane_resource.weapon", "weapon", 40.0f, 2),		
		ScoredResource("guntruck_flare.projectile", "projectile", 35.0f, 2),
		ScoredResource("aav7_flare.projectile", "projectile", 20.0f, 2),
		ScoredResource("wiesel_flare.projectile", "projectile", 15.0f, 2),				
		ScoredResource("vulcan_acav_flare.projectile", "projectile", 10.0f, 2),
		ScoredResource("stim.projectile", "projectile", 40.0f, 10),
		ScoredResource("balloon.carry_item", "carry_item", 20.0f, 10),
		ScoredResource("vest_exo.carry_item", "carry_item", 20.0f, 5),
		ScoredResource("squad_equipment_kit.weapon", "weapon", 20.0f, 10),
		ScoredResource("chicken_carrier.weapon", "weapon", 10.0f, 5),
		ScoredResource("noxe_flare.projectile", "projectile", 10.0f, 2),				
		ScoredResource("m528_flare.projectile", "projectile", 10.0f, 2),				
		ScoredResource("flamer_tank_flare.projectile", "projectile", 10.0f, 2),				
		ScoredResource("sev90_flare.projectile", "projectile", 10.0f, 2),				
		ScoredResource("suomi.weapon", "weapon", 4.0f),
		ScoredResource("p416.weapon", "weapon", 4.0f), 
		ScoredResource("m320.weapon", "weapon", 7.0f),					 
		ScoredResource("ninjato.weapon", "weapon", 7.0f),
		ScoredResource("ak47_w_gp25.weapon", "weapon", 8.0f),
		ScoredResource("g36_w_ag36.weapon", "weapon", 8.0f),
		ScoredResource("m16a4_w_m203.weapon", "weapon", 8.0f),
		ScoredResource("kulakov.weapon", "weapon", 5.0f),
		ScoredResource("rpd.weapon", "weapon", 7.0f),
		ScoredResource("mac10.weapon", "weapon", 12.0f),
		ScoredResource("ash12.weapon", "weapon", 6.0f),			
		ScoredResource("ultimax.weapon", "weapon", 6.0f),
		ScoredResource("zweihander.weapon", "weapon", 10.0f), 
		ScoredResource("sabre.weapon", "weapon", 12.0f),
		ScoredResource("doublebarrel.weapon", "weapon", 10.0f),
		ScoredResource("golden_mp5sd.weapon", "weapon", 7.0f),
		ScoredResource("gilboa_dbr.weapon", "weapon", 8.0f),
		ScoredResource("mgv176.weapon", "weapon", 7.0f),
		ScoredResource("mpx.weapon", "weapon", 6.0f),
		ScoredResource("sks.weapon", "weapon", 6.0f),
		ScoredResource("costume_panda.carry_item", "carry_item", 12.0f, 2),
		ScoredResource("lailv-002_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("mmls-528_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("dogbone.projectile", "projectile", 18.0f, 4),
		ScoredResource("shovel.weapon", "weapon", 10.0f),
		ScoredResource("sbl.weapon", "weapon", 6.0f),
		ScoredResource("lai-109_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("f1_flare.projectile", "projectile", 12.0f, 2),		 
		ScoredResource("an94.weapon", "weapon", 7.0f),  
		ScoredResource("rotten_banana.carry_item", "carry_item", 40.0f, 2),
		
		ScoredResource("fv101_flare.projectile", "projectile", 10.0f, 2),
		ScoredResource("hovercraft_flare.projectile", "projectile", 12.0f, 2),
		ScoredResource("m551_flare.projectile", "projectile", 10.0f, 2), 
		ScoredResource("fhj01.weapon", "weapon", 15.0f, 5),
		ScoredResource("m249.weapon", "weapon", 5.0f, 1),
		ScoredResource("ksg_b.weapon", "weapon", 5.0f, 1),
		ScoredResource("m14ebr.weapon", "weapon", 4.0f, 1),
		ScoredResource("chinalake.weapon", "weapon", 4.0f, 1),
		ScoredResource("ar15_th.weapon", "weapon", 4.0f, 1),
		ScoredResource("mrl_resource.weapon", "weapon", 3.0f, 1),

		ScoredResource("supershorty.weapon", "weapon", 6.0f, 1),
		ScoredResource("rpk16.weapon", "weapon", 4.0f, 1),
		ScoredResource("ots14.weapon", "weapon", 4.0f, 1),
		ScoredResource("sv98.weapon", "weapon", 5.0f, 1),
		ScoredResource("vks.weapon", "weapon", 5.0f, 1),
		ScoredResource("qjz89.weapon", "weapon", 4.0f, 1),
		ScoredResource("qlz87_b.weapon", "weapon", 4.0f, 1),
		ScoredResource("ks23_b.weapon", "weapon", 5.0f, 1),

		ScoredResource("shock_paddle.weapon" , "weapon", 9.0f),
		ScoredResource("g3_1x.weapon", "weapon", 4.0f),
		ScoredResource("golden_dragunov_svd.weapon", "weapon", 4.0f),
		ScoredResource("dp28.weapon", "weapon", 4.0f),
		ScoredResource("m14k.weapon", "weapon", 5.0f),
		ScoredResource("qbz95.weapon", "weapon", 5.0f),
		ScoredResource("fd338.weapon", "weapon", 5.0f),
		ScoredResource("torch.weapon", "weapon", 4.0f, 2),

		ScoredResource("galil.weapon", "weapon", 5.0f),
		ScoredResource("chiapparhino.weapon", "weapon", 5.0f),
		ScoredResource("m1_garand_m.weapon", "weapon", 5.0f),
		ScoredResource("rg6_a.weapon", "weapon", 4.0f),
		ScoredResource("hunting_crossbow_h.weapon", "weapon", 5.0f),
		ScoredResource("gm94.weapon", "weapon", 4.0f),
		ScoredResource("gun_tommy.weapon", "weapon", 5.0f),
		ScoredResource("gun_lewis.weapon", "weapon", 5.0f)
			} 
		};   
	
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}



	// --------------------------------------------
	// -----------------Unlocks------------------
	// --------------------------------------------

	// ----------------------------------------------------  
	protected void setupEnemyWeaponUnlocks() {
		array<ItemDeliveryObjective@> objectives = createEnemyWeaponDeliveryObjectives();

		for (uint i = 0; i < objectives.size(); ++i) {
			m_itemDeliveryOrganizer.addObjective(objectives[i]);
		}
	}

	// ----------------------------------------------------
	protected array<Resource@>@ getEnemyWeaponDeliverables() const {
		array<Resource@> results;

		string type = "weapon";
		string typePlural = "weapons";

		// get the stuff we have in stock
		array<const XmlElement@> own = getFactionDeliverables(m_metagame, 0, type, typePlural);
		if (own is null) {
			_log("WARNING, getEnemyWeaponDeliverables, couldn't get own resources", -1);
			return results;
		}

		// get the grand list of deliverable weapons, all of them
		array<Resource@> deliverables = getDeliverablesList();
		for (uint i = 0; i < deliverables.size(); ++i) {
			Resource@ r = deliverables[i];
			// go through the list and only leave the ones in we're interested of, those which we don't have yet
			// check if we have this key
			bool add = true;
			for (uint j = 0; j < own.size(); ++j) {
				const XmlElement@ ownNode = own[j];
				string ownKey = ownNode.getStringAttribute("key");
				if (r.m_key != ownKey) {
					// no match, continue searching
				} else {
					// we already have this, skip it
					add = false;
					break;
				}
			}

			if (add) {
				// ensure it's not already in results
				if (results.findByRef(r) < 0) {
					results.insertLast(r);
				}
			}
		}

		return results;
	}

	// ----------------------------------------------------
	protected array<ItemDeliveryObjective@>@ createEnemyWeaponDeliveryObjectives() const {
		_log("createEnemyWeaponDeliveryObjectives", 1);

		array<ItemDeliveryObjective@> newObjectives;

		string instructions = "enemy item objective instruction";
		string thanks = "enemy item objective thanks";
		string thanksIncomplete = "enemy item objective thanks incomplete";

		// add objective for every enemy weapon not owned by friendlies yet
		array<Resource@>@ enemyWeaponResources = getEnemyWeaponDeliverables();
		for (uint i = 0; i < enemyWeaponResources.size(); ++i) {
			Resource@ resource = enemyWeaponResources[i];
			_log("enemy unlock target " + resource.m_key, 1);
			array<Resource@> deliveryList = {resource};
			// delivering certain amount of specific weapon unlocks that particular weapon
			dictionary unlockList = {
				{resource.m_key, array<Resource@> = {resource}}
			};
			ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame, /* custom stat tracker tag */ "enemy_weapon_delivered");

			int amount = 5;

			ItemDeliveryObjective objective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, "", thanks, thanksIncomplete, amount, 0, 50);

			if (m_itemDeliveryOrganizer.getObjectiveById(objective.getId()) is null) {
				newObjectives.insertLast(objective);
			}			
		}

		return newObjectives;
	}

	// ----------------------------------------------------
	protected void refreshEnemyWeaponDeliveryObjectives() {
		// only creates ones that don't already exist
		array<ItemDeliveryObjective@>@ newObjectives = createEnemyWeaponDeliveryObjectives();

		for (uint i = 0; i < newObjectives.size(); ++i) {
			ItemDeliveryObjective@ objective = newObjectives[i];
			m_itemDeliveryOrganizer.addObjective(objective);
			// insta-add tracker
			m_metagame.addTracker(objective);
		}
	}


	// --------------------------------------------
	// -----------------Briefcase-----------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList() const {
		array<Resource@> list;
		
		list.push_back(MultiGroupResource("minig_resource.weapon", "weapon", array<string> = {"default", "mrap"})); 
		list.push_back(MultiGroupResource("desert_eagle.weapon", "weapon", array<string> = {"default", "mrap"})); 
		list.push_back(MultiGroupResource("tow_resource.weapon", "weapon", array<string> = {"default", "mrap"}));   
		list.push_back(MultiGroupResource("eodvest.carry_item", "carry_item", array<string> = {"default", "mrap"}));    
		list.push_back(MultiGroupResource("gl_resource.weapon", "weapon", array<string> = {"default", "mrap"}));   
		list.push_back(MultiGroupResource("smaw.weapon", "weapon", array<string> = {"default", "mrap"}));   
		list.push_back(MultiGroupResource("hornet_resource.weapon", "weapon", array<string> = {"default", "mrap"}));   
		list.push_back(MultiGroupResource("thermal_grenade.projectile", "projectile", array<string> = {"default", "supply", "mrap"}));		

		return list;
	}

	// --------------------------------------------
	// -----------------Laptop-------------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList2() const {
		array<Resource@> list;

		list.push_back(MultiGroupResource("kunai.projectile", "projectile", array<string> = {"supply"}));	
		list.push_back(MultiGroupResource("mk23.weapon", "weapon", array<string> = {"default", "supply"})); 
		list.push_back(Resource("apr.weapon", "weapon")); 
		list.push_back(MultiGroupResource("vest_blackops.carry_item", "carry_item", array<string> = {"default", "supply"}));
		list.push_back(Resource("mp5sd.weapon.weapon", "weapon"));		
		list.push_back(Resource("scorpion-evo.weapon", "weapon"));	
		list.push_back(Resource("qcw-05.weapon", "weapon"));	
		list.push_back(Resource("sr3m.weapon", "weapon"));	

		 
		return list;
	}
	
	// --------------------------------------------
	// ---------------WF Laptop----------------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList3() const {
		array<Resource@> list;

		list.push_back(Resource("g41.weapon", "weapon"));
		list.push_back(Resource("ump45.weapon", "weapon"));
		list.push_back(Resource("hk21e.weapon", "weapon"));
		list.push_back(Resource("msg90.weapon", "weapon"));
		list.push_back(Resource("matador.weapon", "weapon"));	
 
		return list;
	}

	// --------------------------------------------
	// ----------base weapon unlocks----------
	// --------------------------------------------

	// --------------------------------------------
	array<Resource@>@ getDeliverablesList() const {
		array<Resource@> list;

		// list here what we want to track as delivering to armory, with intention of unlocking that same item

		// the upgrade weapons, l85a2, famas, sg552, are considered semi-rare, only unlockable through cargo truck & suitcases, see get_unlock_weapon_list
		// in 1.31 we removed the weapons as unlockables that are not dropped by the AI 

		// green weapons
		list.push_back(Resource("m16a4.weapon", "weapon"));
		list.push_back(Resource("m240.weapon", "weapon"));
		list.push_back(Resource("m24_a2.weapon", "weapon"));
		//list.push_back(Resource("mp5sd.weapon", "weapon"));
		list.push_back(Resource("mossberg.weapon", "weapon"));
		//list.push_back(Resource("l85a2.weapon", "weapon"));
		list.push_back(Resource("m72_law.weapon", "weapon"));
		//list.push_back(Resource("beretta_m9.weapon", "weapon"));
		//list.push_back(Resource("mini_uzi.weapon", "weapon"));	 

		// grey weapons
		list.push_back(Resource("g36.weapon", "weapon"));
		list.push_back(Resource("imi_negev.weapon", "weapon"));
		list.push_back(Resource("psg90.weapon", "weapon"));
		//list.push_back(Resource("scorpion-evo.weapon", "weapon"));
		list.push_back(Resource("spas-12.weapon", "weapon"));
		//list.push_back(Resource("famasg1.weapon", "weapon"));
		list.push_back(Resource("m2_carlgustav.weapon", "weapon"));
		//list.push_back(Resource("glock17.weapon", "weapon"));
		//list.push_back(Resource("steyr_tmp.weapon", "weapon"));	 

		// brown weapons
		list.push_back(Resource("ak47.weapon", "weapon"));
		list.push_back(Resource("pkm.weapon", "weapon"));
		list.push_back(Resource("dragunov_svd.weapon", "weapon"));
		//list.push_back(Resource("qcw-05.weapon", "weapon"));
		list.push_back(Resource("qbs-09.weapon", "weapon"));
		//list.push_back(Resource("sg552.weapon", "weapon"));
		list.push_back(Resource("rpg-7.weapon", "weapon"));
		//list.push_back(Resource("pb.weapon", "weapon")); 
		//list.push_back(Resource("aek_919k.weapon", "weapon"));	 

		// blue weapons
		list.push_back(Resource("nr97a.weapon", "weapon"));
		list.push_back(Resource("qjy88.weapon", "weapon"));
		list.push_back(Resource("type_97.weapon", "weapon"));
		//list.push_back(Resource("sr3m.weapon", "weapon"));
		list.push_back(Resource("civet_12.weapon", "weapon"));
		//list.push_back(Resource("t03.weapon", "weapon"));
		list.push_back(Resource("at4.weapon", "weapon"));
		//list.push_back(Resource("np34_s.weapon", "weapon")); 
		//list.push_back(Resource("pm63.weapon", "weapon"));	 

		return list;
	}
}
