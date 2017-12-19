project_open uart

create_timing_netlist
check_timing -include {loops latches no_input_delay partial_input_delay}
report_bottleneck

get_clock_fmax_info

project_close


