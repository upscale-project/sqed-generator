`include "qed.vh"

module qed_i_cache (/*AUTOARG*/
   // Outputs
   qic_qimux_instruction,
   vld_out,
   // Inputs
   clk, rst,
   exec_dup, IF_stall,	    
   ifu_qed_instruction
   );

   parameter ICACHESIZE = 128;

   input         clk;
   input         rst;
   
   input 	 exec_dup;
   input 	 IF_stall;
   input [31:0]  ifu_qed_instruction;
   output [31:0] qic_qimux_instruction;
   output 	 vld_out;

   reg [31:0]    i_cache[ICACHESIZE-1:0];
   reg [5:0] 	 address_tail;  // to accomodate 256 ICACHESIZE
   reg [5:0] 	 address_head;
   wire 	 is_empty;
   wire 	 is_full;
   
   wire [31:0]   instruction;
   wire 	 is_nop;
   wire 	 insert_cond ;
   wire 	 delete_cond;

   // i_cache is basically a queue
   assign insert_cond = (~rst)&(~exec_dup)&(~is_nop)&(~IF_stall)&(~is_full);
   assign delete_cond = (~rst)&(exec_dup)&(~is_empty)&(~IF_stall);
   assign is_nop = (ifu_qed_instruction[6:0] == 7'b1111111);
   assign is_empty = (address_tail == address_head);
   assign is_full = ((address_tail + 1) == address_head);
   
   assign vld_out = (~insert_cond)&(~delete_cond) ? 1'b0 : 1'b1 ;

   // address computation
   always @(posedge clk)
     begin
        if (rst) begin
           address_tail <= 6'b0;
	   address_head <= 6'b0;
        end else if (insert_cond) begin
	   i_cache[address_tail] <= ifu_qed_instruction;
           address_tail <= address_tail + 1;
        end else if (delete_cond) begin
	   address_head <= address_head + 1;
	end
     end 

   assign instruction = i_cache[address_head];
   assign qic_qimux_instruction = insert_cond ? ifu_qed_instruction : (delete_cond ? instruction : 32'b1111111);  
   
endmodule // qed_i_cache

     

 
        
