set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_system" -name SPD_FILE [file join $::quartus(sip_path) "../system.spd"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "../../system.qsys"]

set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "system.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_video_pll_0.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_avalon_reset_from_locked_signal.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_video_pll_0_video_pll.vo"]
