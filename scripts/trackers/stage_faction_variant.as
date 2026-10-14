#include "tracker.as"
#include "query_helpers.as"
#include "query_helpers2.as"

// Explicit group lists preserve the original weapon's availability. In
// particular, replacing a sniper rifle must not grant it to regular grunts.
class FactionVariantWeaponSwap {
	string m_oldKey;
	string m_newKey;
	array<string> m_groups;

	FactionVariantWeaponSwap(string oldKey, string newKey, const array<string>@ groups) {
		m_oldKey = oldKey;
		m_newKey = newKey;
		m_groups = groups;
	}
}

// A tag describes a base spawn slot. Commands still address resource keys;
// list ALL original candidates for that slot, including inherited resources.
class FactionVariantVehicleSwap {
	string m_tag;
	array<string> m_oldKeys;
	string m_newKey;

	FactionVariantVehicleSwap(string tag, const array<string>@ oldKeys, string newKey) {
		m_tag = tag;
		m_oldKeys = oldKeys;
		m_newKey = newKey;
	}
}

// One fixed profile per base faction file; stage-local faction IDs are not
// faction identities (the campaign shuffles the basic faction configs).
class FactionVariantProfile {
	string m_factionFile;
	array<string> m_weaponGroups;
	array<string> m_removeWeapons;
	array<string> m_addWeapons;
	array<FactionVariantWeaponSwap@> m_weaponSwaps;
	array<string> m_vehicleGroups = {"default"};
	array<FactionVariantVehicleSwap@> m_vehicleSwaps;
	bool m_replaceInitialVehicles = true;

	FactionVariantProfile(string factionFile) {
		m_factionFile = factionFile;
	}

	bool validate() const {
		if (m_factionFile == "") return false;
		if (m_removeWeapons.size() + m_addWeapons.size() + m_weaponSwaps.size() + m_vehicleSwaps.size() == 0) return false;
		// Use either shared bulk changes or group-specific pairs in one profile.
		if (m_weaponSwaps.size() > 0 && m_removeWeapons.size() + m_addWeapons.size() > 0) return false;
		if (m_removeWeapons.size() + m_addWeapons.size() > 0 && m_weaponGroups.size() == 0) return false;
		if (m_vehicleSwaps.size() > 0 && m_vehicleGroups.size() == 0) return false;
		if (!validKeys(m_weaponGroups) || !validKeys(m_vehicleGroups) ||
			!validKeys(m_removeWeapons) || !validKeys(m_addWeapons)) return false;
		for (uint i = 0; i < m_removeWeapons.size(); ++i) {
			if (m_addWeapons.find(m_removeWeapons[i]) >= 0) return false;
		}
		for (uint i = 0; i < m_weaponSwaps.size(); ++i) {
			const FactionVariantWeaponSwap@ swap = m_weaponSwaps[i];
			if (swap is null || swap.m_oldKey == "" || swap.m_newKey == "" || swap.m_oldKey == swap.m_newKey) return false;
			if (swap.m_groups.size() == 0 || !validKeys(swap.m_groups)) return false;
			for (uint j = 0; j < i; ++j) {
				const FactionVariantWeaponSwap@ other = m_weaponSwaps[j];
				for (uint g = 0; g < swap.m_groups.size(); ++g) {
					if (other.m_groups.find(swap.m_groups[g]) < 0) continue;
					if (swap.m_oldKey == other.m_oldKey || swap.m_newKey == other.m_oldKey || swap.m_oldKey == other.m_newKey) return false;
				}
			}
		}
		array<string> tags;
		array<string> oldKeys;
		array<string> newKeys;
		for (uint i = 0; i < m_vehicleSwaps.size(); ++i) {
			const FactionVariantVehicleSwap@ swap = m_vehicleSwaps[i];
			if (swap is null || swap.m_tag == "" || swap.m_newKey == "" || swap.m_oldKeys.size() == 0) return false;
			if (tags.find(swap.m_tag) >= 0 || !validKeys(swap.m_oldKeys)) return false;
			tags.insertLast(swap.m_tag);
			newKeys.insertLast(swap.m_newKey);
			for (uint j = 0; j < swap.m_oldKeys.size(); ++j) {
				if (oldKeys.find(swap.m_oldKeys[j]) >= 0) return false;
				oldKeys.insertLast(swap.m_oldKeys[j]);
			}
		}
		// Also rejects cross-tag cycles, e.g. tank A -> B and jeep B -> A.
		for (uint i = 0; i < newKeys.size(); ++i) {
			if (oldKeys.find(newKeys[i]) >= 0) return false;
		}
		return true;
	}

	protected bool validKeys(const array<string>@ keys) const {
		for (uint i = 0; i < keys.size(); ++i) {
			if (keys[i] == "" || keys.find(keys[i]) != int(i)) return false;
		}
		return true;
	}
}

class StageFactionVariant : Tracker {
	protected Metagame@ m_metagame;
	protected int m_factionId;
	protected FactionVariantProfile@ m_profile;
	protected bool m_started = false;
	protected bool m_continuing = false;

	StageFactionVariant(Metagame@ metagame, int factionId, FactionVariantProfile@ profile) {
		@m_metagame = metagame;
		m_factionId = factionId;
		@m_profile = profile;
	}

	int getFactionId() const { return m_factionId; }
	bool hasStarted() const { return m_started; }
	bool hasEnded() const { return m_started; }

	// Called by the configurator AFTER normal stage resource commands, BEFORE
	// start_game. This path is shared by a new map and restartMap(). No commands
	// are sent from the constructor: stages are all constructed in the lobby.
	void appendResourceCommands(array<XmlElement@>@ commands) {
		if (!validateLoadedResources()) return;
		for (uint i = 0; i < m_profile.m_weaponSwaps.size(); ++i) {
			const FactionVariantWeaponSwap@ swap = m_profile.m_weaponSwaps[i];
			for (uint g = 0; g < swap.m_groups.size(); ++g) {
				XmlElement@ command = makeCommand(swap.m_groups[g]);
				addFactionResourceElements(command, "weapon", array<string> = {swap.m_oldKey}, false);
				addFactionResourceElements(command, "weapon", array<string> = {swap.m_newKey}, true);
				commands.insertLast(command);
			}
		}
		for (uint i = 0; i < m_profile.m_weaponGroups.size(); ++i) {
			if (m_profile.m_removeWeapons.size() + m_profile.m_addWeapons.size() == 0) break;
			XmlElement@ command = makeCommand(m_profile.m_weaponGroups[i]);
			addFactionResourceElements(command, "weapon", m_profile.m_removeWeapons, false);
			addFactionResourceElements(command, "weapon", m_profile.m_addWeapons, true);
			commands.insertLast(command);
		}
		for (uint i = 0; i < m_profile.m_vehicleGroups.size(); ++i) {
			if (m_profile.m_vehicleSwaps.size() == 0) break;
			XmlElement@ command = makeCommand(m_profile.m_vehicleGroups[i]);
			for (uint j = 0; j < m_profile.m_vehicleSwaps.size(); ++j) {
				const FactionVariantVehicleSwap@ swap = m_profile.m_vehicleSwaps[j];
				addFactionResourceElements(command, "vehicle", swap.m_oldKeys, false);
				addFactionResourceElements(command, "vehicle", array<string> = {swap.m_newKey}, true);
			}
			commands.insertLast(command);
		}
	}

	// onAdd happens before gameContinuePreStart. Defer all world mutations to
	// start(), so continuing a save never runs the fresh-match vehicle pass.
	void onAdd() {
		m_started = false;
		m_continuing = false;
	}

	void gameContinuePreStart() { m_continuing = true; }

	void start() {
		m_started = true;
		array<XmlElement@> commands;
		appendResourceCommands(commands);
		if (commands.size() == 0) return;
		// A continued game bypasses the configurator's pre-start commands.
		// Reapply only explicit toggles, never clear the resource pool/unlocks.
		for (uint i = 0; i < commands.size(); ++i) {
			m_metagame.getComms().send(commands[i]);
		}
		if (!m_continuing && m_profile.m_replaceInitialVehicles) replaceInitialVehicles();
		_log("StageFactionVariant: faction " + m_factionId + " uses " + m_profile.m_factionFile + " secondary assets", 1);
	}

	protected XmlElement@ makeCommand(string group) const {
		XmlElement command("command");
		command.setStringAttribute("class", "faction_resources");
		command.setIntAttribute("faction_id", m_factionId);
		command.setStringAttribute("soldier_group_name", group);
		return command;
	}

	protected bool validateLoadedResources() {
		if (m_profile is null || m_factionId < 0 || !m_profile.validate()) {
			_log("ERROR, StageFactionVariant: invalid profile for faction " + m_factionId, -1);
			return false;
		}
		array<const XmlElement@> groups = getSoldierGroups(m_metagame, m_factionId);
		array<string> names;
		for (uint i = 0; i < groups.size(); ++i) names.insertLast(groups[i].getStringAttribute("name"));
		array<string> required = m_profile.m_weaponGroups;
		for (uint i = 0; i < m_profile.m_weaponSwaps.size(); ++i) {
			const FactionVariantWeaponSwap@ swap = m_profile.m_weaponSwaps[i];
			for (uint g = 0; g < swap.m_groups.size(); ++g) required.insertLast(swap.m_groups[g]);
		}
		if (m_profile.m_vehicleSwaps.size() > 0) {
			for (uint i = 0; i < m_profile.m_vehicleGroups.size(); ++i) required.insertLast(m_profile.m_vehicleGroups[i]);
		}
		for (uint i = 0; i < required.size(); ++i) {
			if (names.find(required[i]) < 0) {
				_log("ERROR, StageFactionVariant: missing soldier group " + required[i] + " in faction " + m_factionId, -1);
				return false;
			}
		}
		if (!resourcesExist(m_profile.m_removeWeapons, "weapon") || !resourcesExist(m_profile.m_addWeapons, "weapon")) return false;
		for (uint i = 0; i < m_profile.m_weaponSwaps.size(); ++i) {
			const FactionVariantWeaponSwap@ swap = m_profile.m_weaponSwaps[i];
			if (!resourcesExist(array<string> = {swap.m_oldKey, swap.m_newKey}, "weapon")) return false;
		}
		for (uint i = 0; i < m_profile.m_vehicleSwaps.size(); ++i) {
			const FactionVariantVehicleSwap@ swap = m_profile.m_vehicleSwaps[i];
			if (!resourcesExist(swap.m_oldKeys, "vehicle") || !resourcesExist(array<string> = {swap.m_newKey}, "vehicle")) return false;
		}
		return true;
	}

	protected bool resourcesExist(const array<string>@ keys, string resourceClass) {
		for (uint i = 0; i < keys.size(); ++i) {
			const XmlElement@ resource = getResource(m_metagame, keys[i], resourceClass);
			if (resource is null || resource.getStringAttribute("key") != keys[i]) {
				_log("ERROR, StageFactionVariant: resource not loaded: " + keys[i], -1);
				return false;
			}
		}
		return true;
	}

	// A one-time repair for engine versions which have already picked the old
	// vehicle when the resource command arrives. Limit it to pristine, empty,
	// faction-owned vehicles still at a matching generic spawn node. No ongoing
	// polling, no captured vehicles, no resetting saved vehicle instances.
	protected void replaceInitialVehicles() {
		for (uint i = 0; i < m_profile.m_vehicleSwaps.size(); ++i) {
			const FactionVariantVehicleSwap@ swap = m_profile.m_vehicleSwaps[i];
			array<const XmlElement@> nodes = getGenericNodes(m_metagame, "", swap.m_tag);
			for (uint k = 0; k < swap.m_oldKeys.size(); ++k) {
				array<const XmlElement@> vehicles = getVehicles(m_metagame, m_factionId, swap.m_oldKeys[k]);
				for (uint v = 0; v < vehicles.size(); ++v) {
					int id = vehicles[v].getIntAttribute("id");
					if (id < 0) continue;
					const XmlElement@ vehicle = getVehicleInfo(m_metagame, id);
					if (vehicle is null || vehicle.getIntAttribute("id") != id) continue;
					if (vehicle.getStringAttribute("key") != swap.m_oldKeys[k]) continue;
					if (vehicle.getIntAttribute("owner_id") != m_factionId) continue;
					int holder = vehicle.getIntAttribute("holder_id");
					if (holder >= 0 && holder != m_factionId) continue;
					if (vehicle.getBoolAttribute("locked")) continue;
					if (vehicle.getElementsByTagName("character").size() > 0) continue;
					float maxHealth = vehicle.getFloatAttribute("max_health");
					if (maxHealth <= 0.0f || vehicle.getFloatAttribute("health") != maxHealth) continue;
					string position = vehicle.getStringAttribute("position");
					if (position == "") continue;
					for (uint n = 0; n < nodes.size(); ++n) {
						const XmlElement@ node = nodes[n];
						if (getPositionDistance(stringToVector3(position), stringToVector3(node.getStringAttribute("position"))) > 3.0f) continue;
						string orientation = vehicle.getStringAttribute("orientation");
						if (orientation == "") orientation = node.getStringAttribute("orientation");
						if (orientation == "") continue;
						XmlElement command("command");
						command.setStringAttribute("class", "create_instance");
						command.setStringAttribute("instance_class", "vehicle");
						command.setStringAttribute("instance_key", swap.m_newKey);
						command.setIntAttribute("faction_id", m_factionId);
						command.setStringAttribute("position", position);
						command.setStringAttribute("orientation", orientation);
						removeVehicle(m_metagame, id);
						m_metagame.getComms().send(command);
						_log("StageFactionVariant: replaced " + swap.m_oldKeys[k] + " with " + swap.m_newKey + " at " + swap.m_tag, 1);
						break;
					}
				}
			}
		}
	}
}
