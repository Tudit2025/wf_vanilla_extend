#include "path://media/packages/vanilla/scripts"
#include "path://media/packages/wf_base/scripts"
#include "path://media/packages/wf_vanilla_extend/scripts"
#include "gamemode_blue.as"

void main(dictionary@ inputData) {
    XmlElement inputSettings(inputData);
    _log("Achtung! input settings:  " + inputSettings.toString());

    GameModeBlueTester metagame(inputSettings);

    metagame.init();
    metagame.run();
    metagame.uninit();

    _log("ending execution");
}