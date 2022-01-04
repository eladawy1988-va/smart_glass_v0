TEST = top_tb
WAVE_FILE = wave.do

PREFIX = 
RTLDIR = ..
TRANSCRIPT_FILE = transcript

GITBRANCH = feature

VSIM = $(PREFIX) vsim 
VLOG = $(PREFIX) vlog
VCOM = $(PREFIX) vcom
VLIB = $(PREFIX) vlib

# compile all RTL sources
RTL_FILES = top_tb.v ../rtl/Controller.v ../rtl/image.v ../rtl/display.v ../rtl/RWM_1.v ../rtl/image_arithmetic.v ../rtl/RGB_operator.v ../rtl/top.v

# compile all RTL sources
#RTL_FILES = video_stitcher_tb.v ../rtl/Controller.v ../rtl/image.v ../rtl/image2.v ../rtl/display.v ../rtl/RWM_1.v ../rtl/RWM_2.v ../rtl/camera.v ../rtl/Grayscaler.v ../rtl/filter5x5.v ../rtl/keypoints.v ../rtl/sobel_filter.v ../rtl/descriptor.v ../rtl/matcher.v ../rtl/stitcher.v ../rtl/top.v


compile: rtl tb

rtl:
	if [ ! -d work ]; then $(VLIB) work; fi
	${VLOG} -L -work ${RTL_FILES}
    

# compile verification environment
tb:
	if [ ! -e "${TEST}.v" ]; then false; fi
	${VLOG}  ${TEST}.v

# run simulator in GUI mode 
run:
	${VSIM} -l $(TRANSCRIPT_FILE) -voptargs=+acc work.$(TEST) -do $(WAVE_FILE) -do 'run -all'


runc: tb
	${VSIM} -c -l $(TRANSCRIPT_FILE) -voptargs=+acc work.$(TEST) -do $(WAVEDIR)/nogui.do
    
    
# GIT commands

push:
	git push origin $(GITBRANCH)
        
pull:
	git pull
        
commit:
	git commit -a
        
stat:
	git status
    
    
clean:
	rm -rf work 
	rm -rf vsim.wlf 
	rm -f $(TRANSCRIPT_FILE)s
