module CPU_tb;

  reg  clk  ;
  reg  rst  ;
  wire halt ;

  Top_level_risc Top_level_risc_inst (clk, rst, halt) ;

  task clock (input integer number);
    repeat (number) begin clk=0; #1; clk=1; #1; end
  endtask

  task reset;
    begin
      rst = 1; clock(1);
      rst = 0; clock(1);
    end
  endtask

  task expect (input exp_halt);
    if (halt !== exp_halt) begin
        $display("TEST FAILED");
        $display("time=%0d: halt is %b and should be %b",
                 $time, halt, exp_halt);
        $finish;
      end
  endtask

  localparam [2:0] HLT=0, SKZ=1, ADD=2, AND=3, XOR=4, LDA=5, STO=6, JMP=7;

  reg [7:0] test;

  initial begin

      $display("Testing reset");
      Top_level_risc_inst.b8.array[0] = { HLT, 5'bx };
      reset;
      expect(0);

      $display("Testing HLT instruction");
      Top_level_risc_inst.b8.array[0] = { HLT, 5'bx };
      reset;
      clock(2); expect(0); clock(1); expect(1);

      // TO DO: TEST THE "JMP" INSTRUCTION. MEMORY LOCATIONS 0 and 1 WILL BOTH
      //        CONTAIN AN INSTRUCTION TO JUMP TO LOCATION 2. MEMORY LOCATION 2
      //        WILL CONTAIN A "HALT" INSTRUCTION. IF THE "JMP" INSTRUCTION
      //        WORKS THEN THE HALT WILL OCCUR AFTER A TOTAL OF 11 CLOCKS.
      $display("Testing JMP instruction");
      //here add the required code to complete the testing of JMP instruction



	  reset;
      clock(10); expect(0); clock(1); expect(1);

      // TO DO: TEST THE "SKZ" INSTRUCTION. MEMORY LOCATION 0 WILL CONTAIN AN
      //        INSTRUCTION TO SKIP THE NEXT INSTRUCTION IF THE ACCUMULATOR IS
      //        ZERO (IT IS). MEMORY LOCATION 1 WILL CONTAIN AN INSTRUCTION TO
      //        JUMP TO LOCATION 2. MEMORY LOCATION 2 WILL CONTAIN A "HALT"
      //        INSTRUCTION. IF THE "SKZ" INSTRUCTION WORKS THEN THE HALT WILL
      //        OCCUR AFTER A TOTAL OF 11 CLOCKS.
      $display("Testing SKZ instruction");
      Top_level_risc_inst.b8.array[0] = { SKZ, 5'bx };
      Top_level_risc_inst.b8.array[1] = { JMP, 5'd2 };
      Top_level_risc_inst.b8.array[2] = { HLT, 5'bx };
      reset;
      clock(10); expect(0); clock(1); expect(1);

      $display("Testing LDA instruction");
      Top_level_risc_inst.b8.array[0] = { LDA, 5'd5 };
      Top_level_risc_inst.b8.array[1] = { SKZ, 5'bx };
      Top_level_risc_inst.b8.array[2] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[3] = { JMP, 5'd4 };
      Top_level_risc_inst.b8.array[4] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[5] = {      8'd1 };
      reset;
      clock(18); expect(0); clock(1); expect(1);

      $display("Testing STO instruction");
      Top_level_risc_inst.b8.array[0] = { LDA, 5'd7 };
      Top_level_risc_inst.b8.array[1] = { STO, 5'd8 };
      Top_level_risc_inst.b8.array[2] = { LDA, 5'd8 };
      Top_level_risc_inst.b8.array[3] = { SKZ, 5'bx };
      Top_level_risc_inst.b8.array[4] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[5] = { JMP, 5'd6 };
      Top_level_risc_inst.b8.array[6] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[7] = {      8'd1 };
      Top_level_risc_inst.b8.array[8] = {      8'd0 };
      reset;
      clock(34); expect(0); clock(1); expect(1);

      $display("Testing AND instruction");
      Top_level_risc_inst.b8.array[0] = { LDA, 5'd10};
      Top_level_risc_inst.b8.array[1] = { AND, 5'd11};
      Top_level_risc_inst.b8.array[2] = { SKZ, 5'bx };
      Top_level_risc_inst.b8.array[3] = { JMP, 5'd5 };
      Top_level_risc_inst.b8.array[4] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[5] = { AND, 5'd12};
      Top_level_risc_inst.b8.array[6] = { SKZ, 5'bx };
      Top_level_risc_inst.b8.array[7] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[8] = { JMP, 5'd9 };
      Top_level_risc_inst.b8.array[9] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[10]= {      8'hff};
      Top_level_risc_inst.b8.array[11]= {      8'h01};
      Top_level_risc_inst.b8.array[12]= {      8'hfe};
      reset;
      clock(58); expect(0); clock(1); expect(1);

      $display("Testing XOR instruction");
      Top_level_risc_inst.b8.array[0] = { LDA, 5'd10}; // 1
      Top_level_risc_inst.b8.array[1] = { XOR, 5'd11}; // 2
      Top_level_risc_inst.b8.array[2] = { SKZ, 5'bx }; // 3
      Top_level_risc_inst.b8.array[3] = { JMP, 5'd5 }; // 4
      Top_level_risc_inst.b8.array[4] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[5] = { XOR, 5'd12}; // 5
      Top_level_risc_inst.b8.array[6] = { SKZ, 5'bx }; // 6
      Top_level_risc_inst.b8.array[7] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[8] = { JMP, 5'd9 }; // 7
      Top_level_risc_inst.b8.array[9] = { HLT, 5'bx }; // 8
      Top_level_risc_inst.b8.array[10]= {      8'h55};
      Top_level_risc_inst.b8.array[11]= {      8'h54};
      Top_level_risc_inst.b8.array[12]= {      8'h01};
      reset;
      clock(58); expect(0); clock(1); expect(1);

      $display("Testing ADD instruction");
      Top_level_risc_inst.b8.array[0] = { LDA, 5'd9 }; // 1
      Top_level_risc_inst.b8.array[1] = { ADD, 5'd11}; // 2
      Top_level_risc_inst.b8.array[2] = { SKZ, 5'bx }; // 3
      Top_level_risc_inst.b8.array[3] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[4] = { ADD, 5'd11}; // 4
      Top_level_risc_inst.b8.array[5] = { SKZ, 5'bx }; // 5
      Top_level_risc_inst.b8.array[6] = { HLT, 5'bx }; // 6
      Top_level_risc_inst.b8.array[7] = { JMP, 5'd9 };
      Top_level_risc_inst.b8.array[8] = { HLT, 5'bx };
      Top_level_risc_inst.b8.array[9] = {      8'hff};
      Top_level_risc_inst.b8.array[11]= {      8'h01};
      reset;
      clock(42); expect(0); clock(1); expect(1);

      for (test=1; test<=3; test=test+1) begin : TESTS
          integer clocks;
          reg [1:12*8] testfile ;
          testfile = { "CPUtest", 8'h30+test, ".txt" } ;
          $readmemb ( testfile, Top_level_risc_inst.b8.array ) ;
          $display("Doing test %s", testfile);
          case ( test )
            1: clocks=138;
            2: clocks=106;
            3: clocks=938;
          endcase
          reset;
          clock(clocks); expect(0); clock(1); expect(1);
        end

      $display("TEST PASSED");
      $finish;

    end

endmodule

