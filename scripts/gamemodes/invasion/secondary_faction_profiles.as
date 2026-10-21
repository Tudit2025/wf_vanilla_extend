#include "stage_faction_variant.as"

// Fixed secondary loadouts belong HERE, keyed by the original faction file.
// Weapon pairs follow the original enabled resource pools in wf_base's faction
// definitions, including copy_from and .resources includes. Special groups
// without the old weapon are not granted its replacement. Vehicle groups also
// follow the effective resource pools. Stage opt-ins are configured separately.
FactionVariantProfile@ createSecondaryFactionProfile(string factionFile) {
	FactionVariantProfile profile(factionFile);
	array<string> infantry = {"default", "default_ai", "medic", "prisoner", "mrap"};
	array<string> infantryWithOfficer = {"default", "default_ai", "medic", "prisoner", "officer", "mrap"};
	// sniper has its own pool and must be targeted explicitly. lonewolf copies
	// sniper, then clears weapons in lonewolf_sniper_*.resources for its own kit.
	array<string> sniperRifleGroups = {"default", "medic", "sniper", "prisoner", "mrap"};

	if (factionFile == "green.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("m16a4.weapon", "c7a1.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("mossberg.weapon", "model_870.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("m240.weapon", "c9a1.weapon", infantry));
		profile.m_vehicleGroups = array<string> = {"default", "default_ai", "prisoner", "mrap"};
		profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
			"apc", array<string> = {"apc.vehicle"}, "secondary_acv.vehicle"));
	} else if (factionFile == "grey.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("g36.weapon", "fn_scar.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("imi_negev.weapon", "fn_minimi.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("psg90.weapon", "sr25.weapon", sniperRifleGroups));
		profile.m_vehicleGroups = array<string> = {"default", "default_ai", "medic", "prisoner", "mrap"};
		profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
			"tank", array<string> = {"tank_1.vehicle"}, "secondary_leclerc.vehicle"));
		profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
			"tank_alt", array<string> = {"tank_1_alt.vehicle"}, "secondary_leclerc_alt.vehicle"));
		FactionVariantVehicleSwap deniedTank("tank_denied_player",
			array<string> = {"tank_1_denied_player.vehicle"}, "secondary_leclerc_denied_player.vehicle");
		// The original denied-player tank also carries the ordinary tank tag.
		deniedTank.m_extraSpawnTags.insertLast("tank");
		profile.m_vehicleSwaps.insertLast(deniedTank);
	} else if (factionFile == "brown.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("qbs-09.weapon", "rmb_93.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("pkm.weapon", "rpk_74.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("dragunov_svd.weapon", "ksvk.weapon", sniperRifleGroups));
		profile.m_vehicleGroups = array<string> = {"default", "default_ai", "prisoner", "officer", "mrap"};
		profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
			"apc", array<string> = {"apc_2.vehicle"}, "secondary_bmp3.vehicle"));
	} else if (factionFile == "blue.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("nr97a.weapon", "sar_21.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("civet_12.weapon", "usas_12.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("type_97.weapon", "m1500.weapon", sniperRifleGroups));
		profile.m_vehicleGroups = array<string> = {"default", "default_ai", "prisoner", "officer", "mrap"};
		profile.m_vehicleSwaps.insertLast(FactionVariantVehicleSwap(
			"apc", array<string> = {"apc_3.vehicle"}, "secondary_vn.vehicle"));
	} else {
		return null;
	}
	return profile;
}
