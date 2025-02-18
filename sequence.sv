//  random stimulus 
class fifo_sequence extends uvm_sequence#(fifo_seq_item);
  `uvm_object_utils(fifo_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  
   
//  `uvm_declare_p_sequencer(mem_sequencer)
  
  // create, randomize and send the item to driver
  virtual task body();
    repeat(15) begin
    req = fifo_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
        
      //initial begin 
    //set_response_queue_error_report_disabled(1);
    // set response queue depth more than 8
      set_response_queue_depth(15) ;
  //end
   end 
  endtask
endclass


// "write" type
class fifo_write_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_write_sequence)
      fifo_seq_item item;

  //Constructor
  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction
  
  //body task of sequence
  virtual task body();
    repeat(8) begin
      item = fifo_seq_item::type_id::create("item");
      
      start_item(item);
      assert(item.randomize() with {item.wr==1;item.rd==0;});
      finish_item(item);
            
      set_response_queue_depth(15) ;

     // `uvm_do_with(req,{req.wr==1;req.rd==0;})
     end

  endtask
endclass

// "read" type
class fifo_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_read_sequence)
   
  //Constructor
  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(8) begin
      `uvm_do_with(req,{req.rd==1;req.wr==0;})
       set_response_queue_depth(15) ;

    end
  endtask
  
endclass
        

// "write" complete first then "read" (sequence's inside sequences)
//used in wr_then_rd_test.sv

class fifo_wr_then_rd_sequence extends uvm_sequence#(fifo_seq_item);
  
  //Declaring sequences
  fifo_write_sequence wr_seq;
  fifo_read_sequence  rd_seq;
  
  `uvm_object_utils(fifo_wr_then_rd_sequence)
   
  //Constructor
  function new(string name = "fifo_wr_then_rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(wr_seq)
    `uvm_do(rd_seq)
  endtask
  
endclass

// "write" followed by "read" 

//used in wr_rd_test.sv
//write read back to back

 class fifo_write_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_write_read_sequence)
   
  //Constructor
  function new(string name = "fifo_write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(5) begin
    ///req = fifo_seq_item::type_id::create("req");
      `uvm_do_with(req,{req.wr==1;req.rd==0;})
      `uvm_do_with(req,{req.wr==0;req.rd==1;})
     
      set_response_queue_error_report_disabled(1); 

      //set_response_queue_depth(10) ;
    end
  endtask
endclass        


//"write" & "read" 
 class fifo_wr_rd_parallel_seq extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_wr_rd_parallel_seq)
  fifo_write_sequence wr_seq;
  fifo_read_sequence  rd_seq;
  //Constructor
  function new(string name = "fifo_wr_rd_parallel_seq");
    super.new(name);
  endfunction
  
  virtual task body();
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==1;req.rd==0;});
      finish_item(req);
      repeat(8) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==1;req.rd==1;});
      finish_item(req);
      set_response_queue_depth(15) ;

      // `uvm_do_with(req,{req.wr==1;req.rd==1;})
     end
  endtask 
endclass        
