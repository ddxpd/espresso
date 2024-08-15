#删除work工作目录
file delete -force work
 
#设置uvm环境变量，指定uvm的dpi位置
#set  UVM_HOME       ~/questasim_startup/questasim/verilog_src/uvm-1.2/
#set  UVM_DPI_HOME   ~/questasim_startup/questasim/uvm-1.2/linux_x86_64
set  UVM_HOME       /home/happydog/QuestaSim2021/questasim/verilog_src/uvm-1.2
set  UVM_DPI_HOME   /home/happydog/QuestaSim2021/questasim/uvm-1.2/linux_x86_64
 
#创建work工作目录,存放仿真数据文件
vlib work 
vmap work work
 
#vlog表示编译 *.sv表示do文件同级路径下所有.sv文件 -L表示添加库文件
vlog +incdir+$UVM_HOME/src\
	-L mtiAvm\
	-L mtiOvm\
	-L mtiUvm\
	-L mtiUPF\
	-timescale=1ns/1ps\
	./host/host_pkg.sv\
        ./test/test_pkg.sv\
	./top.sv

vsim -c work.top +UVM_TESTNAME=init_test  -do "run -all; q"

##合并覆盖率
##vcover merge -out merged.ucdb ./test_covdb
# 
##添加波形，top_sim_tb文件例化的top_inst 实例，将top的所有信号添加到波形中
##add wave top/dif/*
#Add wave -position insertpoint  \
#Sim:/top_sim_tb/top_inst/* 
# 
# 
# 
##运行仿真
#Run 20us
