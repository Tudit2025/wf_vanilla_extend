#include "advanced_call.as"

// Use live SNE instances instead of AdvancedCall's unconditional test result.
class SneCallWarning : AdvancedCall {
	SneCallWarning(Metagame@ metagame) {
		super(metagame);
	}

	bool checkVehicleRange(float range, Vector3 position) {
		// Restored vehicles do not replay spawn events. Querying here also
		// reflects destroyed or captured stations before each new warning.
		array<const XmlElement@>@ stations = getVehicles(m_metagame, 0, "sne_station.vehicle");
		if (stations is null) return false;
		for (uint i = 0; i < stations.size(); ++i) {
			if (stations[i] is null) continue;
			int id = stations[i].getIntAttribute("id");
			if (id < 0) continue;
			// Health is available on the vehicle detail, not the list entry.
			const XmlElement@ station = getVehicleInfo(m_metagame, id);
			if (station is null || station.getIntAttribute("id") != id) continue;
			if (station.getStringAttribute("key") != "sne_station.vehicle") continue;
			if (station.getIntAttribute("owner_id") != 0) continue;
			int holder = station.getIntAttribute("holder_id");
			if (holder >= 0 && holder != 0) continue;
			if (station.getFloatAttribute("health") <= 0.0f) continue;
			string stationPosition = station.getStringAttribute("position");
			if (stationPosition == "") continue;
			if (getPositionDistance(stringToVector3(stationPosition), position) < range) return true;
		}
		return false;
	}
}
