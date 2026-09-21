# Pad clock source includes input-pad insertion delay in propagated STA.
create_clock -name core_clk -period 20.0 [get_ports clk_PAD]
set_clock_uncertainty 0.25 [get_clocks core_clk]
set_clock_transition 0.15 [get_clocks core_clk]
set_input_delay -clock core_clk -min 0.0 [get_ports {input_PAD[*]}]
set_input_delay -clock core_clk -max 2.0 [get_ports {input_PAD[*]}]
set_output_delay -clock core_clk -min 0.0 [get_ports {output_PAD[*]}]
set_output_delay -clock core_clk -max 4.0 [get_ports {output_PAD[*]}]
set_load 0.033442 [get_ports {output_PAD[*]}]
# External reset asserts asynchronously. Release is synchronized in chip_core.
# This exception is only for the external reset network, not all reset paths.
set_false_path -from [get_ports rst_n_PAD]
if { [info exists ::env(OPENLANE_SDC_IDEAL_CLOCKS)] && $::env(OPENLANE_SDC_IDEAL_CLOCKS) } {
 unset_propagated_clock [all_clocks]
} else {
 set_propagated_clock [all_clocks]
}
