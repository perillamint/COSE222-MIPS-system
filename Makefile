PROJ=cose222-ecp5-mips
PIN_DEF := ecp5evn.lpf
DEVICE := um5g-85
PACKAGE := CABGA381

TARGET_FREQ := 30

SIMCOMPILER := iverilog
SIMULATOR := vvp
VIEWER := gtkwave

TOPMODULE := LFE5UM5G_85F_EVN

#SYNTHFLAGS := -abc2 -noccu2 -nobram -nomux
SYNTHFLAGS := -abc2
SIMCOMPFLAGS := -Wimplicit -Wportbind -Wselect-range -Winfloop
SIMFLAGS := -v

RAWSRCS = $(wildcard *.v) $(wildcard */*.v) $(wildcard */*/*.v)
SRCS = $(filter-out Altera_%, $(RAWSRCS))
TBSRCS = $(filter %_tb.v, $(SRCS))
MODSRCS = $(filter-out %_tb.v %_incl.v, $(SRCS))
VVPS = $(patsubst %.v,%.vvp,$(TBSRCS))
VCDS = $(patsubst %_tb.v,%_wave.vcd,$(TBSRCS))

BITS := $(PROJ).bit
RPTS := $(patsubst %.bit,%.rpt,$(BITS))
DOTS := $(PROJ).dot
JSONS := $(patsubst %.bit,%.json,$(BITS))
SVFS := $(patsubst %.bit,%.svf,$(BITS))


all: ${PROJ}.bit

simulate: $(VCDS)

prog: ${PROJ}.svf
	openocd -f ecp5-evn.cfg -c "transport select jtag; init; svf $<; exit"

%.hex: %.xbm
	echo @00000000 > $@
	cat $< | tail -n +4 | sed 's/0x//g' | sed 's/[}; ]//g' | sed 's/,/ /g' >> $@

$(JSONS): %.json: $(MODSRCS) rom.hex
	yosys -p "synth_ecp5 ${SYNTHFLAGS} -top ${TOPMODULE} -json $@" $(filter-out %.hex,$^)

$(DOTS):%.dot: $(MODSRCS) rom.hex
	yosys -p "read_verilog $(filter-out %.hex,$^); hierarchy -check; proc; opt; fsm; opt; memory; opt extract -map top.v"

%_out.config: %.json
	nextpnr-ecp5 --json $< --textcfg $@ --${DEVICE}k --package ${PACKAGE} --lpf ${PIN_DEF} --freq ${TARGET_FREQ}

%.bit: %_out.config
	ecppack --svf ${PROJ}.svf $< $@

${PROJ}.svf : ${PROJ}.bit

%.vvp: %.v $(MODSRCS)
	$(SIMCOMPILER) $(SIMCOMPFLAGS) $^ -o $@

%_wave.vcd: %_tb.vvp
	$(SIMULATOR) $(SIMFLAGS) $<

clean:
	rm -f *.svf *.bit *.config *.json *.vvp *.vcd *.rom xbm2bin

#.PHONY: prog clean
