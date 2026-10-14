#include "stage_faction_variant.as"

// Fixed secondary loadouts belong HERE, keyed by the original faction file.
// Weapon pairs follow the original enabled resource pools in wf_base's faction
// definitions, including copy_from and .resources includes. Special groups
// without the old weapon are not granted its replacement. Vehicle swaps and
// stage opt-ins are configured separately; no faction files are switched.
FactionVariantProfile@ createSecondaryFactionProfile(string factionFile) {
	FactionVariantProfile profile(factionFile);
	array<string> infantry = {"default", "default_ai", "medic", "prisoner", "mrap"};
	array<string> infantryWithOfficer = {"default", "default_ai", "medic", "prisoner", "officer", "mrap"};
	array<string> rifle = {"default", "medic", "sniper", "prisoner", "lonewolf", "mrap"};

	if (factionFile == "green.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("m16a4.weapon", "c7a1.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("mossberg.weapon", "model_870.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("m240.weapon", "c9a1.weapon", infantry));
	} else if (factionFile == "grey.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("g36.weapon", "fn_scar.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("imi_negev.weapon", "fn_minimi.weapon", infantry));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("psg90.weapon", "sr25.weapon", rifle));
	} else if (factionFile == "brown.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("qbs-09.weapon", "rmb_93.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("pkm.weapon", "rpk_74.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("dragunov_svd.weapon", "ksvk.weapon", rifle));
	} else if (factionFile == "blue.xml") {
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("nr97a.weapon", "sar_21.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("civet_12.weapon", "usas_12.weapon", infantryWithOfficer));
		profile.m_weaponSwaps.insertLast(FactionVariantWeaponSwap("type_97.weapon", "m1500.weapon", rifle));
	} else {
		return null;
	}
	return profile;
}
