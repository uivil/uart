#
#load_package external_memif_toolkit
#
global usbblaster_name
global test_device

project_open uart

#initialize_connections
set usbblaster_name [lindex [get_hardware_names] 0]
set test_device [lindex [get_device_names -hardware_name $usbblaster_name] 0]
open_device -hardware_name $usbblaster_name -device_name $test_device

device_lock -timeout 1000

for { set a 0x71}  {$a < 0x87} {incr a} {
 device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value 
 device_virtual_dr_shift -instance_index 0 -length 8 -dr_value [format %x $a] -value_in_hex

  #read stdin 1

  device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value 
  puts [device_virtual_dr_shift -instance_index 0 -length 8 -value_in_hex]
}

catch {device_unlock}
catch {close_device}


