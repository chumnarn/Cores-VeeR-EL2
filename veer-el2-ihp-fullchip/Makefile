SHELL := /bin/bash
.DEFAULT_GOAL := help
PDK_ROOT ?= $(CURDIR)/IHP-Open-PDK
PDK := ihp-sg13g2
PDK_COMMIT := 3b5a704ba6738aa686b08706187830e6284d2a10
LL := python3 -m librelane
ARGS := --pdk $(PDK) --pdk-root "$(PDK_ROOT)" --manual-pdk
.PHONY: help configure rom preflight schema pdk sim sim-chip test-bus test synth-elab validate synthesis floorplan cts route full klayout openroad metrics
help:
	@echo 'Targets: configure rom preflight schema pdk test synth-elab validate synthesis floorplan cts route full klayout openroad metrics'
configure:
	mkdir -p reports
	RV_ROOT="$(CURDIR)/vendor/el2" perl vendor/el2/configs/veer.config -target=default_ahb -snapshot=baseline -set=iccm_enable=0 -set=dccm_enable=0 -set=icache_enable=0 -fpga_optimize=1 > reports/config-generation.log
rom:
	python3 scripts/gen_rom.py
preflight:
	python3 scripts/preflight.py
schema:
	python3 scripts/check_schema.py
pdk:
	python3 -m ciel enable $(PDK_COMMIT) --pdk-root "$(PDK_ROOT)" --pdk-family $(PDK)
sim: rom
	python3 scripts/run_sim.py soc
sim-chip: rom
	python3 scripts/run_sim.py chip
test-bus: rom
	python3 scripts/run_sim.py ahb
test: test-bus sim sim-chip
synth-elab:
	python3 scripts/run_elaboration.py
validate:
	python3 scripts/check_pdk.py --pdk-root "$(PDK_ROOT)"
	python3 scripts/check_config.py --pdk-root "$(PDK_ROOT)"
synthesis: validate
	$(LL) $(ARGS) --to Yosys.Synthesis librelane/config.yaml
floorplan: validate
	$(LL) $(ARGS) --to OpenROAD.GeneratePDN librelane/config.yaml
cts: validate
	$(LL) $(ARGS) --to OpenROAD.CTS librelane/config.yaml
route: validate
	$(LL) $(ARGS) --to OpenROAD.DetailedRouting librelane/config.yaml
full: validate
	$(LL) $(ARGS) --save-views-to final librelane/config.yaml
klayout:
	$(LL) $(ARGS) --last-run --flow OpenInKLayout librelane/config.yaml
openroad:
	$(LL) $(ARGS) --last-run --flow OpenInOpenROAD librelane/config.yaml
metrics:
	python3 scripts/collect_metrics.py
