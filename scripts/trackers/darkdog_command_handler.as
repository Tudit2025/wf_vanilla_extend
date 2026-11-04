#include "basic_command_handler.as"

// Extend the existing handler so all inherited campaign commands stay available.
class DarkdogCommandHandler : BasicCommandHandler {
    DarkdogCommandHandler(Metagame@ metagame) {
        super(metagame);
    }

    protected void handleChatEvent(const XmlElement@ event) {
        if (event.getStringAttribute("message") == "/darkdog") {
            // The inherited helper resolves faction 0 to the sender's faction.
            spawnInstanceNearPlayer(event.getIntAttribute("player_id"), "darkdog.vehicle", "vehicle", 0);
            return;
        }
        BasicCommandHandler::handleChatEvent(event);
    }
}
