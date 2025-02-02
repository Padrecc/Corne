.PHONY: git-submodule, vial-qmk-clean, vial-qmk-init, vial-qmk-compile, vial-qmk-flash, vial-qmk-init-all, vial-qmk-compile-all, update-all

KB := crkbd
KR := rev4_1/standard
KM := vial

git-submodule:
	git submodule update --remote
	git submodule update --init --recursive

vial-qmk-clean:
	rm -rf src/vial-qmk/keyboards/tmp
	cd src/vial-qmk; qmk clean

vial-qmk-init:
	$(eval KB := ${kb})
	rm -rf src/vial-qmk/keyboards/tmp/${KB}
	mkdir -p src/vial-qmk/keyboards/tmp/${KB}
	cp -r $(shell pwd)/keyboards/qmk_firmware/* src/vial-qmk/keyboards/tmp/${KB}
	mkdir -p keyboards/.build

vial-qmk-compile:
	$(eval KB := ${kb})
	$(eval KR := ${kr})
	$(eval KM := ${km})
	$(eval FILE := $(shell echo "${kb}_${kr}_${km}" | sed 's/\//_/'))
	cd src/vial-qmk; qmk compile -kb tmp/${KB}/${KR} -km ${KM}
	cp src/vial-qmk/.build/tmp_${FILE}.hex keyboards/${KB}/vial-qmk/.build/${FILE}.hex | true
	cp src/vial-qmk/.build/tmp_${FILE}.uf2 keyboards/${KB}/vial-qmk/.build/${FILE}.uf2 | true

vial-qmk-flash:
	$(eval KB := ${kb})
	$(eval KR := ${kr})
	$(eval KM := ${km})
	cd src/vial-qmk; qmk flash -kb tmp/${KB}/${KR} -km ${KM}

vial-qmk-init-all:
	kb=crkbd make vial-qmk-init

vial-qmk-compile-all:

	kb=crkbd kr=rev4_1/standard km=vial make vial-qmk-compile



update-all:
	make git-submodule
	make vial-qmk-clean
	make vial-qmk-init-all
	make vial-qmk-compile-all
