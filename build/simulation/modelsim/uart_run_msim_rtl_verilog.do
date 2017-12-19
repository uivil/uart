transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart/build {/home/liviu/dev/utm/ic/uart/build/vjtag.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart/build {/home/liviu/dev/utm/ic/uart/build/fifo.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/defs.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/SEG7_LUT_4.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/SEG7_LUT.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/jtag_iface.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/uart.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/baud_gen.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/uart_rx.v}
vlog -vlog01compat -work work +incdir+/home/liviu/dev/utm/ic/uart {/home/liviu/dev/utm/ic/uart/uart_tx.v}

