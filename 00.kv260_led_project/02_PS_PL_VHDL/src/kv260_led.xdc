#==============================================================================
# KV260 LED Project - Pin Constraints (PL Only)
# Target: KRIA KV260 / Vivado 2022.2
#==============================================================================

#------------------------------------------------------------------------------
# PMOD J2 Connector - LED Output
#------------------------------------------------------------------------------
set_property PACKAGE_PIN H12 [get_ports {led[0]}]
set_property PACKAGE_PIN E10 [get_ports {led[1]}]
set_property PACKAGE_PIN D10 [get_ports {led[2]}]
set_property PACKAGE_PIN C11 [get_ports {led[3]}]
set_property PACKAGE_PIN B10 [get_ports {led[4]}]
set_property PACKAGE_PIN E12 [get_ports {led[5]}]
set_property PACKAGE_PIN D11 [get_ports {led[6]}]
set_property PACKAGE_PIN B11 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property DRIVE 12 [get_ports {led[*]}]
set_property SLEW SLOW [get_ports {led[*]}]

#------------------------------------------------------------------------------
# Bitstream Settings
#------------------------------------------------------------------------------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
