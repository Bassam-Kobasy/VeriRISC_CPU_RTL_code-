`include "ALU.v"
`include "controller.v"
`include "Data Driver.v"
`include "Gen_count.v"
`include "Gen_Reg.v"
`include "memory.v"
`include "MUX.v"
module Top_level_risc
(
input reg clk,rst,
output wire halt
);

wire [4:0] pc_out;
wire [2:0] cnt_clk_out;
wire [7:0] ir_out;
wire [7:0] ac_out;


ALU#(.WIDTH(8)) b1         //ALU Block

(
.in_a(ac_out),
.in_b(data),
.opcode(ir_out[7:5]),
.a_is_zero(a_is_zero),
.alu_out(alu_out) 
);

controller b2   //Controller Block
(
.zero(a_is_zero),
.clk(clk),
.rst(rst),
.opcode(ir_out[7:5]),
.phase(cnt_clk_out),
.sel(sel),
.rd(rd),
.ld_ir(ld_ir),
.inc_pc(inc_pc),
.halt(halt),
.ld_ac(ld_ac),
.wr(wr),
.ld_pc(ld_pc),
.data_e(data_e)
);

driver #(.WIDTH(8)) b3  ///Driver Block

(
.data_in(alu_out),
.data_en(ld_ir),
.data_out(data)
);

Gen_count #(.WIDTH(5)) b4  ///PC 

(
.rst(rst),
.clk(clk),
.load(ld_pc),
.enab(inc_pc),
.cnt_in(ir_out[4:0]),
.cnt_out(pc_out)
);

Gen_count #(.WIDTH(3))b5  /// counter clk 

(
.rst(rst),
.clk(clk),
.load(1),
.enab(1),
.cnt_in(0),
.cnt_out(cnt_clk_out)
);

Gen_Reg #(.WIDTH(8)) b6 ///ir register 

(
.data_in(data),
.load(1),
.clk(clk),
.rst(rst),
.data_out(ir_out)
);

Gen_Reg #(.WIDTH(8)) b7 ///ac register 

(
.data_in(alu_out),
.load(ld_ac),
.clk(clk),
.rst(rst),
.data_out(ac_out)
);

memory #(.AWIDTH(5),.DWIDTH (8)) b8 ///memory block

(
.rd(rd),
.wr(wr),
.clk(clk),
.addr(mux_out),
.data(data)
);

MUX #(.WIDTH(5)) b9 ///mux block

(
.in0(ir_out[4:0]),
.in1(pc_out),
.sel(sel),
.mux_out(mux_out)
);

endmodule 