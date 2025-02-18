class fifo_environment extends uvm_env;

  `uvm_component_utils(fifo_environment)

  fifo_agent agt;
  fifo_scoreboard scb;
 
 // virtual fifo_interface vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    agt=fifo_agent::type_id::create("agt", this);
    scb=fifo_scoreboard::type_id::create("scb", this);
   // uvm_config_db#(virtual fifo_interface)::set(this, "agt", "vif", vif);
   // uvm_config_db#(virtual fifo_interface)::set(this, "scb", "vif", vif);
    
   // if(! uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) 
   //   begin
   //     `uvm_error("build_phase","Environment virtual interface failed")
   //   end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.scb_port);
    uvm_report_info("FIFO_ENVIRONMENT", "connect_phase, Connected monitor to scoreboard");
  endfunction
endclass
