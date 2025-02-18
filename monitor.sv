`define MON_IF vif.MONITOR.monitor_cb

class fifo_monitor extends uvm_monitor;
  
  virtual fifo_interface vif;

  uvm_analysis_port#(fifo_seq_item) ap;
  
  `uvm_component_utils(fifo_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap=new("ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction  
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
     fifo_seq_item trans;
     trans = fifo_seq_item ::type_id::create("trans");
      
          trans.wr=`MON_IF.wr;
          trans.data_in=`MON_IF.data_in;
          trans.full=`MON_IF.full;
         
          trans.rd=`MON_IF.rd;
          trans.data_out=`MON_IF.data_out;
          trans.empty=`MON_IF.empty;
        
          @(posedge vif.MONITOR.clk);
        
      ap.write(trans);
    end  
    
  endtask
endclass