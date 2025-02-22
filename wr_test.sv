  class fifo_wr_test extends fifo_test;
  `uvm_component_utils(fifo_wr_test)
  
  fifo_write_sequence seq;
  
  function new(string name = "fifo_wr_test",uvm_component parent=null);
    super.new(name,parent);
        
    seq = fifo_write_sequence::type_id::create("seq");

  endfunction : new
 
  task run_phase(uvm_phase phase);
       
    phase.raise_objection(this);
    seq.start(env.agt.seqr);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 30);
  endtask : run_phase
  
endclass : fifo_wr_test
