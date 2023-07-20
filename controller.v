module controller 
  (
  input wire zero,
  input wire clk,
  input wire rst,
  input wire [2:0]opcode,
  input reg [2:0] phase,

  output reg  sel,
  output reg rd,
  output reg ld_ir,
  output reg inc_pc,
  output reg halt,
  output reg ld_ac,
  output reg wr,
  output reg ld_pc,
  output reg data_e
  );
  reg HALT;
  reg ALUOP;
  reg SKZ ;
  reg JMP ;
  reg STO;
  always @*
  begin
   HALT = (opcode == 0);
   ALUOP =(opcode == 2 || opcode == 3 || opcode == 4 || opcode == 5); 
   SKZ =(opcode == 1);
   JMP =(opcode == 7);
   STO =(opcode == 6);
   if (rst)
    begin
      sel<=0;
      rd<=0;
      ld_ir<=0;
      halt<=0;
      inc_pc<=0;
      ld_ac<=0;
      wr<=0;
      ld_pc<=0;
      data_e<=0;
    end 
  else  
  begin
   
  
    case(phase)
      3'b000:
     begin  
      sel=1'b1;
      rd=0;
      ld_ir=0;
      halt=0;
      inc_pc=0;
      ld_ac=0;
      wr =0;
      ld_pc=0;
      data_e=0;
    end
      3'b001: begin
      sel=1;
      rd=1;
      ld_ir=0;
      halt=0;
      inc_pc=0;
      ld_ac=0;
      wr=0;
      ld_pc=0;
      data_e=0;
        
        
      end
      3'b010: begin
      sel=1;
      rd=1;
      ld_ir=1;
      halt=0;
      inc_pc=0;
      ld_ac=0;
      wr=0;
      ld_pc=0;
      data_e=0;
        
      end
      3'b011: begin
      sel=1;
      rd=1;
      ld_ir=1;
      halt=0;
      inc_pc=0;
      ld_ac=0;
      wr=0;
      ld_pc=0;
      data_e=0;  
      end
      3'b100: begin
      sel=0;
      rd=0;
      ld_ir=0;
      halt=HALT;
      inc_pc=1;
      ld_ac=0;
      wr=0;
      ld_pc=0;
      data_e=0; 
      end
      3'b101: begin
      sel=0;
      rd=ALUOP;
      ld_ir=0;
      halt=0;
      inc_pc=0;
      ld_ac=0;
      wr=0;
      ld_pc=0;
      data_e=0; 
      end
      3'b110: begin
      sel=0;
      rd=ALUOP;
      ld_ir=0;
      halt=0;
      inc_pc=(SKZ&& zero);
      ld_ac=0;
      wr=0;
      ld_pc=JMP;
      data_e=STO; 
      end
      3'b111: begin
      sel=0;
      rd=ALUOP;
      ld_ir=0;
      halt=0;
      inc_pc=0;
      ld_ac=ALUOP;
      wr=STO;
      ld_pc=JMP;
      data_e=STO; 
      end
    endcase
    end
end 
endmodule




