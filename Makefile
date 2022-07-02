
all: build/icezero.bin

prog: build/icezero.bin
	icezprog build/icezero.bin

reset:
	icezprog .

pll: pll.v

pll.v: 
	icepll -i 100M -o 40M -m -p -f pll.v

build/icezero.blif: top.v pll.v blinky.v vga_sync.v reset.v
	yosys -p 'synth_ice40 -top top -blif build/icezero.blif' top.v  | tee log/synth.txt
# yosys -p 'synth_ice40 opt -fine -top top -blif build/icezero.blif; show -colors 1 -width' top.v  | tee log/synth.txt

build/icezero.asc: build/icezero.blif icezero.pcf
	arachne-pnr -d 8k -P tq144:4k -p icezero.pcf -o build/icezero.asc build/icezero.blif | tee log/pnr.txt

build/icezero.bin: build/icezero.asc
	icetime -d hx8k -c 50 build/icezero.asc
	icepack build/icezero.asc build/icezero.bin

clean:
	rm -f build/icezero.blif build/icezero.asc build/icezero.bin
	rm -f pll.v

.PHONY: all prog reset clean

