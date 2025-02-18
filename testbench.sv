import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "interface.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
`include "wr_test.sv"
`include "wr_rd_test.sv"
`include "wr_then_rd_test.sv"
`include "wr_rd_parll_test.sv"

module tbench_top;
  
  bit clk;
  bit reset;
  
  initial begin
    clk=0;
    forever #5 clk = ~clk; 
  end

  initial begin
    reset = 0;
    #2 reset =1;
  end
  
  fifo_interface in(clk,reset);
  
  fifo_sync dut(.data_in(in.data_in),
                .clk(in.clk),
                .rst(in.rst),
                .wr(in.wr),
                .rd(in.rd),
                .empty(in.empty),
                .full(in.full),
                .data_out(in.data_out)
               );
 
   initial begin 
     uvm_config_db#(virtual fifo_interface)::set(null,"*","vif",in);
  end
  
  initial begin
    run_test("fifo_test");   
    //run_test("fifo_wr_test"); 
    //run_test("fifo_wr_rd_test");    
    //run_test("fifo_wr_then_rd_test"); 
    //run_test("fifo_wr_rd_parll_test"); 
  end
  
  initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule