module ProgramCounter(
  input         clock,
  input         reset,
  input  [31:0] io_next,
  output [31:0] io_current
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] REG; // @[ProgramCounter.scala 15:27]
  assign io_current = REG; // @[ProgramCounter.scala 17:14]
  always @(posedge clock) begin
    if (reset) begin // @[ProgramCounter.scala 15:27]
      REG <= 32'h3000; // @[ProgramCounter.scala 15:27]
    end else begin
      REG <= io_next;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  REG = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module InstructionMemory(
  input         clock,
  input  [11:0] io_address,
  output [31:0] io_dataOut
);
  reg [31:0] MEM [0:1023]; // @[InstructionMemory.scala 15:27]
  wire [31:0] MEM_MPORT_data; // @[InstructionMemory.scala 15:27]
  wire [9:0] MEM_MPORT_addr; // @[InstructionMemory.scala 15:27]
  assign MEM_MPORT_addr = io_address[11:2];
  assign MEM_MPORT_data = MEM[MEM_MPORT_addr]; // @[InstructionMemory.scala 15:27]
  assign io_dataOut = MEM_MPORT_data; // @[InstructionMemory.scala 20:14]
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
  integer initvar;
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `endif // RANDOMIZE
  $readmemh("code.txt", MEM);
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module NextProgramCounterSelector(
  input  [3:0]  io_control,
  input  [1:0]  io_signal,
  input  [31:0] io_current,
  input  [15:0] io_branchOffset,
  input  [25:0] io_jumpAddress,
  input  [31:0] io_jumpRegister,
  output [31:0] io_next,
  output [31:0] io_currentPlus4
);
  wire [13:0] hi_hi = io_branchOffset[15] ? 14'h3fff : 14'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_2 = {hi_hi,io_branchOffset,2'h0}; // @[Cat.scala 30:58]
  wire  _T_5 = io_control == 4'h0; // @[NextProgramCounterSelector.scala 33:17]
  wire  _T_6 = io_control == 4'h1; // @[NextProgramCounterSelector.scala 34:17]
  wire [3:0] hi_1 = io_current[31:28]; // @[NextProgramCounterSelector.scala 34:85]
  wire [27:0] lo = {io_jumpAddress, 2'h0}; // @[NextProgramCounterSelector.scala 34:107]
  wire [31:0] _T_7 = {hi_1,lo}; // @[Cat.scala 30:58]
  wire  _T_8 = io_control == 4'h2; // @[NextProgramCounterSelector.scala 35:17]
  wire  _T_10 = io_signal == 2'h0; // @[NextProgramCounterSelector.scala 36:44]
  wire  _T_11 = io_control == 4'h3 & io_signal == 2'h0; // @[NextProgramCounterSelector.scala 36:31]
  wire [31:0] _T_13 = io_currentPlus4 + _T_2; // @[NextProgramCounterSelector.scala 36:87]
  wire  _T_16 = io_control == 4'h4 & io_signal != 2'h0; // @[NextProgramCounterSelector.scala 37:32]
  wire  _T_20 = io_signal == 2'h1; // @[NextProgramCounterSelector.scala 38:44]
  wire  _T_21 = io_control == 4'h5 & io_signal == 2'h1; // @[NextProgramCounterSelector.scala 38:31]
  wire  _T_27 = _T_20 | _T_10; // @[NextProgramCounterSelector.scala 40:35]
  wire  _T_28 = io_control == 4'h6 & _T_27; // @[NextProgramCounterSelector.scala 39:31]
  wire  _T_32 = io_signal == 2'h2; // @[NextProgramCounterSelector.scala 41:44]
  wire  _T_33 = io_control == 4'h7 & io_signal == 2'h2; // @[NextProgramCounterSelector.scala 41:31]
  wire  _T_39 = _T_32 | _T_10; // @[NextProgramCounterSelector.scala 43:35]
  wire  _T_40 = io_control == 4'h8 & _T_39; // @[NextProgramCounterSelector.scala 42:31]
  wire [31:0] _T_43 = _T_40 ? _T_13 : io_currentPlus4; // @[Mux.scala 98:16]
  wire [31:0] _T_44 = _T_33 ? _T_13 : _T_43; // @[Mux.scala 98:16]
  wire [31:0] _T_45 = _T_28 ? _T_13 : _T_44; // @[Mux.scala 98:16]
  wire [31:0] _T_46 = _T_21 ? _T_13 : _T_45; // @[Mux.scala 98:16]
  wire [31:0] _T_47 = _T_16 ? _T_13 : _T_46; // @[Mux.scala 98:16]
  wire [31:0] _T_48 = _T_11 ? _T_13 : _T_47; // @[Mux.scala 98:16]
  wire [31:0] _T_49 = _T_8 ? io_jumpRegister : _T_48; // @[Mux.scala 98:16]
  wire [31:0] _T_50 = _T_6 ? _T_7 : _T_49; // @[Mux.scala 98:16]
  assign io_next = _T_5 ? io_currentPlus4 : _T_50; // @[Mux.scala 98:16]
  assign io_currentPlus4 = io_current + 32'h4; // @[NextProgramCounterSelector.scala 31:33]
endmodule
module GeneralRegisterFile(
  input         clock,
  input         reset,
  input         io_writeEn,
  input  [31:0] io_currentPC,
  input  [4:0]  io_readAddr1,
  input  [4:0]  io_readAddr2,
  input  [4:0]  io_writeAddr,
  input  [31:0] io_writeData,
  output [31:0] io_readData1,
  output [31:0] io_readData2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] REG_0; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_1; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_2; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_3; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_4; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_5; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_6; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_7; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_8; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_9; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_10; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_11; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_12; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_13; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_14; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_15; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_16; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_17; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_18; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_19; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_20; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_21; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_22; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_23; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_24; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_25; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_26; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_27; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_28; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_29; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_30; // @[GeneralRegisterFile.scala 20:34]
  reg [31:0] REG_31; // @[GeneralRegisterFile.scala 20:34]
  wire [31:0] _GEN_1 = 5'h1 == io_readAddr1 ? REG_1 : REG_0; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_2 = 5'h2 == io_readAddr1 ? REG_2 : _GEN_1; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_3 = 5'h3 == io_readAddr1 ? REG_3 : _GEN_2; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_4 = 5'h4 == io_readAddr1 ? REG_4 : _GEN_3; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_5 = 5'h5 == io_readAddr1 ? REG_5 : _GEN_4; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_6 = 5'h6 == io_readAddr1 ? REG_6 : _GEN_5; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_7 = 5'h7 == io_readAddr1 ? REG_7 : _GEN_6; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_8 = 5'h8 == io_readAddr1 ? REG_8 : _GEN_7; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_9 = 5'h9 == io_readAddr1 ? REG_9 : _GEN_8; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_10 = 5'ha == io_readAddr1 ? REG_10 : _GEN_9; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_11 = 5'hb == io_readAddr1 ? REG_11 : _GEN_10; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_12 = 5'hc == io_readAddr1 ? REG_12 : _GEN_11; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_13 = 5'hd == io_readAddr1 ? REG_13 : _GEN_12; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_14 = 5'he == io_readAddr1 ? REG_14 : _GEN_13; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_15 = 5'hf == io_readAddr1 ? REG_15 : _GEN_14; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_16 = 5'h10 == io_readAddr1 ? REG_16 : _GEN_15; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_17 = 5'h11 == io_readAddr1 ? REG_17 : _GEN_16; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_18 = 5'h12 == io_readAddr1 ? REG_18 : _GEN_17; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_19 = 5'h13 == io_readAddr1 ? REG_19 : _GEN_18; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_20 = 5'h14 == io_readAddr1 ? REG_20 : _GEN_19; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_21 = 5'h15 == io_readAddr1 ? REG_21 : _GEN_20; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_22 = 5'h16 == io_readAddr1 ? REG_22 : _GEN_21; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_23 = 5'h17 == io_readAddr1 ? REG_23 : _GEN_22; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_24 = 5'h18 == io_readAddr1 ? REG_24 : _GEN_23; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_25 = 5'h19 == io_readAddr1 ? REG_25 : _GEN_24; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_26 = 5'h1a == io_readAddr1 ? REG_26 : _GEN_25; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_27 = 5'h1b == io_readAddr1 ? REG_27 : _GEN_26; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_28 = 5'h1c == io_readAddr1 ? REG_28 : _GEN_27; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_29 = 5'h1d == io_readAddr1 ? REG_29 : _GEN_28; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_30 = 5'h1e == io_readAddr1 ? REG_30 : _GEN_29; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_31 = 5'h1f == io_readAddr1 ? REG_31 : _GEN_30; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_33 = 5'h1 == io_readAddr2 ? REG_1 : REG_0; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_34 = 5'h2 == io_readAddr2 ? REG_2 : _GEN_33; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_35 = 5'h3 == io_readAddr2 ? REG_3 : _GEN_34; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_36 = 5'h4 == io_readAddr2 ? REG_4 : _GEN_35; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_37 = 5'h5 == io_readAddr2 ? REG_5 : _GEN_36; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_38 = 5'h6 == io_readAddr2 ? REG_6 : _GEN_37; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_39 = 5'h7 == io_readAddr2 ? REG_7 : _GEN_38; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_40 = 5'h8 == io_readAddr2 ? REG_8 : _GEN_39; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_41 = 5'h9 == io_readAddr2 ? REG_9 : _GEN_40; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_42 = 5'ha == io_readAddr2 ? REG_10 : _GEN_41; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_43 = 5'hb == io_readAddr2 ? REG_11 : _GEN_42; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_44 = 5'hc == io_readAddr2 ? REG_12 : _GEN_43; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_45 = 5'hd == io_readAddr2 ? REG_13 : _GEN_44; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_46 = 5'he == io_readAddr2 ? REG_14 : _GEN_45; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_47 = 5'hf == io_readAddr2 ? REG_15 : _GEN_46; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_48 = 5'h10 == io_readAddr2 ? REG_16 : _GEN_47; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_49 = 5'h11 == io_readAddr2 ? REG_17 : _GEN_48; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_50 = 5'h12 == io_readAddr2 ? REG_18 : _GEN_49; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_51 = 5'h13 == io_readAddr2 ? REG_19 : _GEN_50; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_52 = 5'h14 == io_readAddr2 ? REG_20 : _GEN_51; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_53 = 5'h15 == io_readAddr2 ? REG_21 : _GEN_52; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_54 = 5'h16 == io_readAddr2 ? REG_22 : _GEN_53; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_55 = 5'h17 == io_readAddr2 ? REG_23 : _GEN_54; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_56 = 5'h18 == io_readAddr2 ? REG_24 : _GEN_55; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_57 = 5'h19 == io_readAddr2 ? REG_25 : _GEN_56; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_58 = 5'h1a == io_readAddr2 ? REG_26 : _GEN_57; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_59 = 5'h1b == io_readAddr2 ? REG_27 : _GEN_58; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_60 = 5'h1c == io_readAddr2 ? REG_28 : _GEN_59; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_61 = 5'h1d == io_readAddr2 ? REG_29 : _GEN_60; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_62 = 5'h1e == io_readAddr2 ? REG_30 : _GEN_61; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire [31:0] _GEN_63 = 5'h1f == io_readAddr2 ? REG_31 : _GEN_62; // @[GeneralRegisterFile.scala 22:43 GeneralRegisterFile.scala 22:43]
  wire  _T_4 = io_writeAddr != 5'h0; // @[GeneralRegisterFile.scala 29:24]
  assign io_readData1 = io_readAddr1 != 5'h0 ? _GEN_31 : 32'h0; // @[GeneralRegisterFile.scala 22:43]
  assign io_readData2 = io_readAddr2 != 5'h0 ? _GEN_63 : 32'h0; // @[GeneralRegisterFile.scala 22:43]
  always @(posedge clock) begin
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_0 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h0 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_0 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_1 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_1 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_2 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h2 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_2 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_3 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h3 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_3 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_4 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h4 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_4 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_5 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h5 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_5 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_6 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h6 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_6 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_7 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h7 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_7 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_8 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h8 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_8 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_9 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h9 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_9 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_10 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'ha == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_10 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_11 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'hb == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_11 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_12 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'hc == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_12 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_13 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'hd == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_13 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_14 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'he == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_14 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_15 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'hf == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_15 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_16 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h10 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_16 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_17 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h11 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_17 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_18 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h12 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_18 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_19 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h13 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_19 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_20 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h14 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_20 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_21 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h15 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_21 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_22 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h16 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_22 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_23 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h17 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_23 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_24 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h18 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_24 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_25 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h19 == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_25 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_26 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1a == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_26 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_27 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1b == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_27 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_28 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1c == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_28 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_29 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1d == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_29 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_30 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1e == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_30 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    if (reset) begin // @[GeneralRegisterFile.scala 20:34]
      REG_31 <= 32'h0; // @[GeneralRegisterFile.scala 20:34]
    end else if (io_writeEn) begin // @[GeneralRegisterFile.scala 27:21]
      if (5'h1f == io_writeAddr) begin // @[GeneralRegisterFile.scala 28:29]
        REG_31 <= io_writeData; // @[GeneralRegisterFile.scala 28:29]
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_writeEn & _T_4 & ~reset) begin
          $fwrite(32'h80000002,"@%x: $%d <= %x\n",io_currentPC,io_writeAddr,io_writeData); // @[GeneralRegisterFile.scala 30:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  REG_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  REG_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  REG_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  REG_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  REG_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  REG_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  REG_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  REG_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  REG_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  REG_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  REG_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  REG_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  REG_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  REG_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  REG_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  REG_15 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  REG_16 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  REG_17 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  REG_18 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  REG_19 = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  REG_20 = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  REG_21 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  REG_22 = _RAND_22[31:0];
  _RAND_23 = {1{`RANDOM}};
  REG_23 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  REG_24 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  REG_25 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  REG_26 = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  REG_27 = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  REG_28 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  REG_29 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  REG_30 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  REG_31 = _RAND_31[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Extender(
  input  [1:0]  io_control,
  input  [15:0] io_dataIn,
  output [31:0] io_dataOut
);
  wire  _T = io_control == 2'h1; // @[Extender.scala 25:17]
  wire [15:0] hi = io_dataIn[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_3 = {hi,io_dataIn}; // @[Cat.scala 30:58]
  wire  _T_4 = io_control == 2'h0; // @[Extender.scala 26:17]
  wire [31:0] _T_5 = {16'h0,io_dataIn}; // @[Cat.scala 30:58]
  wire  _T_6 = io_control == 2'h2; // @[Extender.scala 27:17]
  wire [31:0] _T_7 = {io_dataIn,16'h0}; // @[Cat.scala 30:58]
  wire [31:0] _T_8 = _T_6 ? _T_7 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_9 = _T_4 ? _T_5 : _T_8; // @[Mux.scala 98:16]
  assign io_dataOut = _T ? _T_3 : _T_9; // @[Mux.scala 98:16]
endmodule
module ArithmeticLogicUnit(
  input  [2:0]  io_control,
  input  [31:0] io_value1,
  input  [31:0] io_value2,
  output [1:0]  io_signal,
  output [31:0] io_output
);
  wire  _T = io_control == 3'h0; // @[ArithmeticLogicUnit.scala 33:17]
  wire [31:0] _T_1 = io_value1 & io_value2; // @[ArithmeticLogicUnit.scala 33:41]
  wire  _T_2 = io_control == 3'h1; // @[ArithmeticLogicUnit.scala 34:17]
  wire [31:0] _T_3 = io_value1 | io_value2; // @[ArithmeticLogicUnit.scala 34:41]
  wire  _T_4 = io_control == 3'h2; // @[ArithmeticLogicUnit.scala 35:17]
  wire [31:0] _T_6 = io_value1 + io_value2; // @[ArithmeticLogicUnit.scala 35:41]
  wire  _T_7 = io_control == 3'h3; // @[ArithmeticLogicUnit.scala 36:17]
  wire [31:0] _T_9 = io_value1 - io_value2; // @[ArithmeticLogicUnit.scala 36:41]
  wire  _T_10 = io_control == 3'h4; // @[ArithmeticLogicUnit.scala 37:17]
  wire  _T_13 = $signed(io_value1) < $signed(io_value2); // @[ArithmeticLogicUnit.scala 37:50]
  wire  _T_14 = _T_10 & _T_13; // @[Mux.scala 98:16]
  wire [31:0] _T_15 = _T_7 ? _T_9 : {{31'd0}, _T_14}; // @[Mux.scala 98:16]
  wire [31:0] _T_16 = _T_4 ? _T_6 : _T_15; // @[Mux.scala 98:16]
  wire [31:0] _T_17 = _T_2 ? _T_3 : _T_16; // @[Mux.scala 98:16]
  wire  _T_19 = io_output == 32'h0; // @[ArithmeticLogicUnit.scala 41:16]
  wire  _T_24 = ~io_output[31]; // @[ArithmeticLogicUnit.scala 43:5]
  wire [1:0] _T_26 = io_output[31] ? 2'h2 : {{1'd0}, _T_24}; // @[Mux.scala 98:16]
  assign io_signal = _T_19 ? 2'h0 : _T_26; // @[Mux.scala 98:16]
  assign io_output = _T ? _T_1 : _T_17; // @[Mux.scala 98:16]
endmodule
module DataMemory(
  input         clock,
  input         reset,
  input         io_writeEn,
  input  [31:0] io_currentPC,
  input  [11:0] io_address,
  input  [7:0]  io_dataIn_0,
  input  [7:0]  io_dataIn_1,
  input  [7:0]  io_dataIn_2,
  input  [7:0]  io_dataIn_3,
  output [7:0]  io_dataOut_0,
  output [7:0]  io_dataOut_1,
  output [7:0]  io_dataOut_2,
  output [7:0]  io_dataOut_3
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_MEM_INIT
  reg [7:0] MEM_0 [0:1023]; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_0_MPORT_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_0_MPORT_addr; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_0_MPORT_1_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_0_MPORT_1_addr; // @[DataMemory.scala 18:27]
  wire  MEM_0_MPORT_1_mask; // @[DataMemory.scala 18:27]
  wire  MEM_0_MPORT_1_en; // @[DataMemory.scala 18:27]
  reg [7:0] MEM_1 [0:1023]; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_1_MPORT_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_1_MPORT_addr; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_1_MPORT_1_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_1_MPORT_1_addr; // @[DataMemory.scala 18:27]
  wire  MEM_1_MPORT_1_mask; // @[DataMemory.scala 18:27]
  wire  MEM_1_MPORT_1_en; // @[DataMemory.scala 18:27]
  reg [7:0] MEM_2 [0:1023]; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_2_MPORT_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_2_MPORT_addr; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_2_MPORT_1_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_2_MPORT_1_addr; // @[DataMemory.scala 18:27]
  wire  MEM_2_MPORT_1_mask; // @[DataMemory.scala 18:27]
  wire  MEM_2_MPORT_1_en; // @[DataMemory.scala 18:27]
  reg [7:0] MEM_3 [0:1023]; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_3_MPORT_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_3_MPORT_addr; // @[DataMemory.scala 18:27]
  wire [7:0] MEM_3_MPORT_1_data; // @[DataMemory.scala 18:27]
  wire [9:0] MEM_3_MPORT_1_addr; // @[DataMemory.scala 18:27]
  wire  MEM_3_MPORT_1_mask; // @[DataMemory.scala 18:27]
  wire  MEM_3_MPORT_1_en; // @[DataMemory.scala 18:27]
  wire [31:0] _T_1 = {20'h0,io_address}; // @[Cat.scala 30:58]
  assign MEM_0_MPORT_addr = io_address[11:2];
  assign MEM_0_MPORT_data = MEM_0[MEM_0_MPORT_addr]; // @[DataMemory.scala 18:27]
  assign MEM_0_MPORT_1_data = io_dataIn_0;
  assign MEM_0_MPORT_1_addr = io_address[11:2];
  assign MEM_0_MPORT_1_mask = 1'h1;
  assign MEM_0_MPORT_1_en = io_writeEn;
  assign MEM_1_MPORT_addr = io_address[11:2];
  assign MEM_1_MPORT_data = MEM_1[MEM_1_MPORT_addr]; // @[DataMemory.scala 18:27]
  assign MEM_1_MPORT_1_data = io_dataIn_1;
  assign MEM_1_MPORT_1_addr = io_address[11:2];
  assign MEM_1_MPORT_1_mask = 1'h1;
  assign MEM_1_MPORT_1_en = io_writeEn;
  assign MEM_2_MPORT_addr = io_address[11:2];
  assign MEM_2_MPORT_data = MEM_2[MEM_2_MPORT_addr]; // @[DataMemory.scala 18:27]
  assign MEM_2_MPORT_1_data = io_dataIn_2;
  assign MEM_2_MPORT_1_addr = io_address[11:2];
  assign MEM_2_MPORT_1_mask = 1'h1;
  assign MEM_2_MPORT_1_en = io_writeEn;
  assign MEM_3_MPORT_addr = io_address[11:2];
  assign MEM_3_MPORT_data = MEM_3[MEM_3_MPORT_addr]; // @[DataMemory.scala 18:27]
  assign MEM_3_MPORT_1_data = io_dataIn_3;
  assign MEM_3_MPORT_1_addr = io_address[11:2];
  assign MEM_3_MPORT_1_mask = 1'h1;
  assign MEM_3_MPORT_1_en = io_writeEn;
  assign io_dataOut_0 = MEM_0_MPORT_data; // @[DataMemory.scala 21:14]
  assign io_dataOut_1 = MEM_1_MPORT_data; // @[DataMemory.scala 21:14]
  assign io_dataOut_2 = MEM_2_MPORT_data; // @[DataMemory.scala 21:14]
  assign io_dataOut_3 = MEM_3_MPORT_data; // @[DataMemory.scala 21:14]
  always @(posedge clock) begin
    if(MEM_0_MPORT_1_en & MEM_0_MPORT_1_mask) begin
      MEM_0[MEM_0_MPORT_1_addr] <= MEM_0_MPORT_1_data; // @[DataMemory.scala 18:27]
    end
    if(MEM_1_MPORT_1_en & MEM_1_MPORT_1_mask) begin
      MEM_1[MEM_1_MPORT_1_addr] <= MEM_1_MPORT_1_data; // @[DataMemory.scala 18:27]
    end
    if(MEM_2_MPORT_1_en & MEM_2_MPORT_1_mask) begin
      MEM_2[MEM_2_MPORT_1_addr] <= MEM_2_MPORT_1_data; // @[DataMemory.scala 18:27]
    end
    if(MEM_3_MPORT_1_en & MEM_3_MPORT_1_mask) begin
      MEM_3[MEM_3_MPORT_1_addr] <= MEM_3_MPORT_1_data; // @[DataMemory.scala 18:27]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (io_writeEn & ~reset) begin
          $fwrite(32'h80000002,"@%x: *%x <= %x\n",io_currentPC,_T_1,{io_dataIn_3,io_dataIn_2,io_dataIn_1,io_dataIn_0}); // @[DataMemory.scala 24:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_0[initvar] = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_1[initvar] = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_2[initvar] = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 1024; initvar = initvar+1)
    MEM_3[initvar] = _RAND_3[7:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DataPath(
  input         clock,
  input         reset,
  input  [1:0]  io_grfWriteAddrSel,
  input  [2:0]  io_grfWriteDataSel,
  input         io_grfWriteEn,
  input  [1:0]  io_aluValue2Sel,
  input         io_memWriteEn,
  input  [3:0]  io_npcControl,
  input  [1:0]  io_extControl,
  input  [2:0]  io_aluControl,
  output [5:0]  io_opcode,
  output [5:0]  io_funct,
  output [4:0]  io_flag,
  output [31:0] io_currentPC
);
  wire  ProgramCounter_clock; // @[DataPath.scala 27:26]
  wire  ProgramCounter_reset; // @[DataPath.scala 27:26]
  wire [31:0] ProgramCounter_io_next; // @[DataPath.scala 27:26]
  wire [31:0] ProgramCounter_io_current; // @[DataPath.scala 27:26]
  wire  InstructionMemory_clock; // @[DataPath.scala 28:26]
  wire [11:0] InstructionMemory_io_address; // @[DataPath.scala 28:26]
  wire [31:0] InstructionMemory_io_dataOut; // @[DataPath.scala 28:26]
  wire [3:0] NextProgramCounterSelector_io_control; // @[DataPath.scala 29:27]
  wire [1:0] NextProgramCounterSelector_io_signal; // @[DataPath.scala 29:27]
  wire [31:0] NextProgramCounterSelector_io_current; // @[DataPath.scala 29:27]
  wire [15:0] NextProgramCounterSelector_io_branchOffset; // @[DataPath.scala 29:27]
  wire [25:0] NextProgramCounterSelector_io_jumpAddress; // @[DataPath.scala 29:27]
  wire [31:0] NextProgramCounterSelector_io_jumpRegister; // @[DataPath.scala 29:27]
  wire [31:0] NextProgramCounterSelector_io_next; // @[DataPath.scala 29:27]
  wire [31:0] NextProgramCounterSelector_io_currentPlus4; // @[DataPath.scala 29:27]
  wire  GeneralRegisterFile_clock; // @[DataPath.scala 30:27]
  wire  GeneralRegisterFile_reset; // @[DataPath.scala 30:27]
  wire  GeneralRegisterFile_io_writeEn; // @[DataPath.scala 30:27]
  wire [31:0] GeneralRegisterFile_io_currentPC; // @[DataPath.scala 30:27]
  wire [4:0] GeneralRegisterFile_io_readAddr1; // @[DataPath.scala 30:27]
  wire [4:0] GeneralRegisterFile_io_readAddr2; // @[DataPath.scala 30:27]
  wire [4:0] GeneralRegisterFile_io_writeAddr; // @[DataPath.scala 30:27]
  wire [31:0] GeneralRegisterFile_io_writeData; // @[DataPath.scala 30:27]
  wire [31:0] GeneralRegisterFile_io_readData1; // @[DataPath.scala 30:27]
  wire [31:0] GeneralRegisterFile_io_readData2; // @[DataPath.scala 30:27]
  wire [1:0] Extender_io_control; // @[DataPath.scala 31:27]
  wire [15:0] Extender_io_dataIn; // @[DataPath.scala 31:27]
  wire [31:0] Extender_io_dataOut; // @[DataPath.scala 31:27]
  wire [2:0] ArithmeticLogicUnit_io_control; // @[DataPath.scala 32:27]
  wire [31:0] ArithmeticLogicUnit_io_value1; // @[DataPath.scala 32:27]
  wire [31:0] ArithmeticLogicUnit_io_value2; // @[DataPath.scala 32:27]
  wire [1:0] ArithmeticLogicUnit_io_signal; // @[DataPath.scala 32:27]
  wire [31:0] ArithmeticLogicUnit_io_output; // @[DataPath.scala 32:27]
  wire  DataMemory_clock; // @[DataPath.scala 33:26]
  wire  DataMemory_reset; // @[DataPath.scala 33:26]
  wire  DataMemory_io_writeEn; // @[DataPath.scala 33:26]
  wire [31:0] DataMemory_io_currentPC; // @[DataPath.scala 33:26]
  wire [11:0] DataMemory_io_address; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataIn_0; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataIn_1; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataIn_2; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataIn_3; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataOut_0; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataOut_1; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataOut_2; // @[DataPath.scala 33:26]
  wire [7:0] DataMemory_io_dataOut_3; // @[DataPath.scala 33:26]
  wire [31:0] _T_1 = InstructionMemory_io_dataOut & 32'h3f; // @[DataPath.scala 36:29]
  wire [15:0] _T_3 = InstructionMemory_io_dataOut[31:16] & 16'h1f; // @[DataPath.scala 37:45]
  wire [31:0] _T_4 = InstructionMemory_io_dataOut & 32'hffff; // @[DataPath.scala 48:40]
  wire [31:0] _T_5 = InstructionMemory_io_dataOut & 32'h3ffffff; // @[DataPath.scala 49:39]
  wire [10:0] _T_7 = InstructionMemory_io_dataOut[31:21] & 11'h1f; // @[DataPath.scala 54:54]
  wire  _T_10 = io_grfWriteAddrSel == 2'h1; // @[DataPath.scala 57:25]
  wire [20:0] _T_12 = InstructionMemory_io_dataOut[31:11] & 21'h1f; // @[DataPath.scala 57:100]
  wire  _T_13 = io_grfWriteAddrSel == 2'h0; // @[DataPath.scala 58:25]
  wire  _T_16 = io_grfWriteAddrSel == 2'h2; // @[DataPath.scala 59:25]
  wire [4:0] _T_17 = _T_16 ? 5'h1f : 5'h0; // @[Mux.scala 98:16]
  wire [15:0] _T_18 = _T_13 ? _T_3 : {{11'd0}, _T_17}; // @[Mux.scala 98:16]
  wire [20:0] _T_19 = _T_10 ? _T_12 : {{5'd0}, _T_18}; // @[Mux.scala 98:16]
  wire  _T_20 = io_grfWriteDataSel == 3'h0; // @[DataPath.scala 62:25]
  wire  _T_21 = io_grfWriteDataSel == 3'h1; // @[DataPath.scala 63:25]
  wire [31:0] _T_22 = {DataMemory_io_dataOut_3,DataMemory_io_dataOut_2,DataMemory_io_dataOut_1,DataMemory_io_dataOut_0}; // @[DataPath.scala 63:94]
  wire  _T_23 = io_grfWriteDataSel == 3'h2; // @[DataPath.scala 64:25]
  wire  _T_24 = io_grfWriteDataSel == 3'h3; // @[DataPath.scala 65:25]
  wire [31:0] _T_25 = _T_24 ? NextProgramCounterSelector_io_currentPlus4 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_26 = _T_23 ? Extender_io_dataOut : _T_25; // @[Mux.scala 98:16]
  wire [31:0] _T_27 = _T_21 ? _T_22 : _T_26; // @[Mux.scala 98:16]
  wire  _T_30 = io_aluValue2Sel == 2'h0; // @[DataPath.scala 74:22]
  wire  _T_31 = io_aluValue2Sel == 2'h1; // @[DataPath.scala 75:22]
  wire [31:0] _T_32 = _T_31 ? Extender_io_dataOut : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _WIRE_2 = GeneralRegisterFile_io_readData2;
  ProgramCounter ProgramCounter ( // @[DataPath.scala 27:26]
    .clock(ProgramCounter_clock),
    .reset(ProgramCounter_reset),
    .io_next(ProgramCounter_io_next),
    .io_current(ProgramCounter_io_current)
  );
  InstructionMemory InstructionMemory ( // @[DataPath.scala 28:26]
    .clock(InstructionMemory_clock),
    .io_address(InstructionMemory_io_address),
    .io_dataOut(InstructionMemory_io_dataOut)
  );
  NextProgramCounterSelector NextProgramCounterSelector ( // @[DataPath.scala 29:27]
    .io_control(NextProgramCounterSelector_io_control),
    .io_signal(NextProgramCounterSelector_io_signal),
    .io_current(NextProgramCounterSelector_io_current),
    .io_branchOffset(NextProgramCounterSelector_io_branchOffset),
    .io_jumpAddress(NextProgramCounterSelector_io_jumpAddress),
    .io_jumpRegister(NextProgramCounterSelector_io_jumpRegister),
    .io_next(NextProgramCounterSelector_io_next),
    .io_currentPlus4(NextProgramCounterSelector_io_currentPlus4)
  );
  GeneralRegisterFile GeneralRegisterFile ( // @[DataPath.scala 30:27]
    .clock(GeneralRegisterFile_clock),
    .reset(GeneralRegisterFile_reset),
    .io_writeEn(GeneralRegisterFile_io_writeEn),
    .io_currentPC(GeneralRegisterFile_io_currentPC),
    .io_readAddr1(GeneralRegisterFile_io_readAddr1),
    .io_readAddr2(GeneralRegisterFile_io_readAddr2),
    .io_writeAddr(GeneralRegisterFile_io_writeAddr),
    .io_writeData(GeneralRegisterFile_io_writeData),
    .io_readData1(GeneralRegisterFile_io_readData1),
    .io_readData2(GeneralRegisterFile_io_readData2)
  );
  Extender Extender ( // @[DataPath.scala 31:27]
    .io_control(Extender_io_control),
    .io_dataIn(Extender_io_dataIn),
    .io_dataOut(Extender_io_dataOut)
  );
  ArithmeticLogicUnit ArithmeticLogicUnit ( // @[DataPath.scala 32:27]
    .io_control(ArithmeticLogicUnit_io_control),
    .io_value1(ArithmeticLogicUnit_io_value1),
    .io_value2(ArithmeticLogicUnit_io_value2),
    .io_signal(ArithmeticLogicUnit_io_signal),
    .io_output(ArithmeticLogicUnit_io_output)
  );
  DataMemory DataMemory ( // @[DataPath.scala 33:26]
    .clock(DataMemory_clock),
    .reset(DataMemory_reset),
    .io_writeEn(DataMemory_io_writeEn),
    .io_currentPC(DataMemory_io_currentPC),
    .io_address(DataMemory_io_address),
    .io_dataIn_0(DataMemory_io_dataIn_0),
    .io_dataIn_1(DataMemory_io_dataIn_1),
    .io_dataIn_2(DataMemory_io_dataIn_2),
    .io_dataIn_3(DataMemory_io_dataIn_3),
    .io_dataOut_0(DataMemory_io_dataOut_0),
    .io_dataOut_1(DataMemory_io_dataOut_1),
    .io_dataOut_2(DataMemory_io_dataOut_2),
    .io_dataOut_3(DataMemory_io_dataOut_3)
  );
  assign io_opcode = InstructionMemory_io_dataOut[31:26]; // @[DataPath.scala 35:31]
  assign io_funct = _T_1[5:0]; // @[DataPath.scala 36:12]
  assign io_flag = _T_3[4:0]; // @[DataPath.scala 37:11]
  assign io_currentPC = ProgramCounter_io_current; // @[DataPath.scala 38:16]
  assign ProgramCounter_clock = clock;
  assign ProgramCounter_reset = reset;
  assign ProgramCounter_io_next = NextProgramCounterSelector_io_next; // @[DataPath.scala 40:14]
  assign InstructionMemory_clock = clock;
  assign InstructionMemory_io_address = ProgramCounter_io_current[11:0]; // @[DataPath.scala 43:17]
  assign NextProgramCounterSelector_io_control = io_npcControl; // @[DataPath.scala 46:18]
  assign NextProgramCounterSelector_io_signal = ArithmeticLogicUnit_io_signal; // @[DataPath.scala 47:17]
  assign NextProgramCounterSelector_io_current = ProgramCounter_io_current; // @[DataPath.scala 45:18]
  assign NextProgramCounterSelector_io_branchOffset = _T_4[15:0]; // @[DataPath.scala 48:23]
  assign NextProgramCounterSelector_io_jumpAddress = _T_5[25:0]; // @[DataPath.scala 49:22]
  assign NextProgramCounterSelector_io_jumpRegister = GeneralRegisterFile_io_readData1; // @[DataPath.scala 50:23]
  assign GeneralRegisterFile_clock = clock;
  assign GeneralRegisterFile_reset = reset;
  assign GeneralRegisterFile_io_writeEn = io_grfWriteEn; // @[DataPath.scala 53:18]
  assign GeneralRegisterFile_io_currentPC = ProgramCounter_io_current; // @[DataPath.scala 52:20]
  assign GeneralRegisterFile_io_readAddr1 = _T_7[4:0]; // @[DataPath.scala 54:20]
  assign GeneralRegisterFile_io_readAddr2 = _T_3[4:0]; // @[DataPath.scala 55:20]
  assign GeneralRegisterFile_io_writeAddr = _T_19[4:0]; // @[DataPath.scala 56:20]
  assign GeneralRegisterFile_io_writeData = _T_20 ? ArithmeticLogicUnit_io_output : _T_27; // @[Mux.scala 98:16]
  assign Extender_io_control = io_extControl; // @[DataPath.scala 68:18]
  assign Extender_io_dataIn = _T_4[15:0]; // @[DataPath.scala 69:17]
  assign ArithmeticLogicUnit_io_control = io_aluControl; // @[DataPath.scala 71:18]
  assign ArithmeticLogicUnit_io_value1 = GeneralRegisterFile_io_readData1; // @[DataPath.scala 72:17]
  assign ArithmeticLogicUnit_io_value2 = _T_30 ? GeneralRegisterFile_io_readData2 : _T_32; // @[Mux.scala 98:16]
  assign DataMemory_clock = clock;
  assign DataMemory_reset = reset;
  assign DataMemory_io_writeEn = io_memWriteEn; // @[DataPath.scala 79:17]
  assign DataMemory_io_currentPC = ProgramCounter_io_current; // @[DataPath.scala 78:19]
  assign DataMemory_io_address = ArithmeticLogicUnit_io_output[11:0]; // @[DataPath.scala 80:17]
  assign DataMemory_io_dataIn_0 = _WIRE_2[7:0]; // @[WordTo4Bytes.scala 6:40]
  assign DataMemory_io_dataIn_1 = _WIRE_2[15:8]; // @[WordTo4Bytes.scala 6:40]
  assign DataMemory_io_dataIn_2 = _WIRE_2[23:16]; // @[WordTo4Bytes.scala 6:40]
  assign DataMemory_io_dataIn_3 = _WIRE_2[31:24]; // @[WordTo4Bytes.scala 6:40]
endmodule
module Controller(
  input  [5:0] io_opcode,
  input  [5:0] io_funct,
  input  [4:0] io_flag,
  output [1:0] io_grfWriteAddrSel,
  output [2:0] io_grfWriteDataSel,
  output       io_grfWriteEn,
  output [1:0] io_aluValue2Sel,
  output       io_memWriteEn,
  output [3:0] io_npcControl,
  output [1:0] io_extControl,
  output [2:0] io_aluControl
);
  wire  _T = io_opcode == 6'h0; // @[Controller.scala 40:39]
  wire  _T_2 = _T & io_funct == 6'h20; // @[Controller.scala 41:37]
  wire  _T_4 = _T & io_funct == 6'h21; // @[Controller.scala 42:37]
  wire  _T_6 = _T & io_funct == 6'h23; // @[Controller.scala 43:37]
  wire  _T_8 = _T & io_funct == 6'h8; // @[Controller.scala 44:37]
  wire  _T_10 = _T & io_funct == 6'h9; // @[Controller.scala 45:37]
  wire  _T_11 = io_opcode == 6'hd; // @[Controller.scala 46:39]
  wire  _T_12 = io_opcode == 6'h8; // @[Controller.scala 47:39]
  wire  _T_13 = io_opcode == 6'h9; // @[Controller.scala 48:39]
  wire  _T_14 = io_opcode == 6'ha; // @[Controller.scala 49:39]
  wire  _T_15 = io_opcode == 6'h23; // @[Controller.scala 50:39]
  wire  _T_16 = io_opcode == 6'h2b; // @[Controller.scala 51:39]
  wire  _T_17 = io_opcode == 6'h4; // @[Controller.scala 52:39]
  wire  _T_18 = io_opcode == 6'h5; // @[Controller.scala 53:39]
  wire  _T_19 = io_opcode == 6'h1; // @[Controller.scala 54:39]
  wire  _T_21 = io_opcode == 6'h1 & io_flag == 5'h1; // @[Controller.scala 54:56]
  wire  _T_22 = io_opcode == 6'h7; // @[Controller.scala 55:39]
  wire  _T_23 = io_opcode == 6'h6; // @[Controller.scala 56:39]
  wire  _T_26 = _T_19 & io_flag == 5'h0; // @[Controller.scala 57:56]
  wire  _T_27 = io_opcode == 6'hf; // @[Controller.scala 58:39]
  wire  _T_28 = io_opcode == 6'h3; // @[Controller.scala 59:39]
  wire  _T_29 = io_opcode == 6'h2; // @[Controller.scala 60:39]
  wire  _T_30 = _T_2 | _T_4; // @[Controller.scala 63:10]
  wire  _T_31 = _T_2 | _T_4 | _T_6; // @[Controller.scala 63:18]
  wire  _T_32 = _T_2 | _T_4 | _T_6 | _T_10; // @[Controller.scala 63:26]
  wire  _T_36 = _T_11 | _T_12 | _T_13 | _T_14 | _T_15; // @[Controller.scala 64:35]
  wire  _T_37 = _T_11 | _T_12 | _T_13 | _T_14 | _T_15 | _T_27; // @[Controller.scala 64:41]
  wire [1:0] _T_38 = _T_28 ? 2'h2 : 2'h3; // @[Mux.scala 98:16]
  wire [1:0] _T_39 = _T_37 ? 2'h0 : _T_38; // @[Mux.scala 98:16]
  wire  _T_46 = _T_31 | _T_11 | _T_12 | _T_13 | _T_14; // @[Controller.scala 68:50]
  wire  _T_47 = _T_28 | _T_10; // @[Controller.scala 71:10]
  wire [2:0] _T_48 = _T_47 ? 3'h3 : 3'h4; // @[Mux.scala 98:16]
  wire [2:0] _T_49 = _T_27 ? 3'h2 : _T_48; // @[Mux.scala 98:16]
  wire [2:0] _T_50 = _T_15 ? 3'h1 : _T_49; // @[Mux.scala 98:16]
  wire  _T_65 = _T_31 | _T_17 | _T_18; // @[Controller.scala 75:33]
  wire  _T_70 = _T_36 | _T_16; // @[Controller.scala 76:41]
  wire [1:0] _T_75 = _T_70 ? 2'h1 : 2'h2; // @[Mux.scala 98:16]
  wire  _T_77 = _T_28 | _T_29; // @[Controller.scala 87:10]
  wire  _T_78 = _T_8 | _T_10; // @[Controller.scala 88:9]
  wire [1:0] _T_79 = _T_78 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire [1:0] _T_80 = _T_77 ? 2'h1 : _T_79; // @[Mux.scala 98:16]
  wire [2:0] _T_81 = _T_26 ? 3'h7 : {{1'd0}, _T_80}; // @[Mux.scala 98:16]
  wire [3:0] _T_82 = _T_23 ? 4'h8 : {{1'd0}, _T_81}; // @[Mux.scala 98:16]
  wire [3:0] _T_83 = _T_22 ? 4'h5 : _T_82; // @[Mux.scala 98:16]
  wire [3:0] _T_84 = _T_21 ? 4'h6 : _T_83; // @[Mux.scala 98:16]
  wire [3:0] _T_85 = _T_18 ? 4'h4 : _T_84; // @[Mux.scala 98:16]
  wire  _T_90 = _T_12 | _T_13 | _T_14 | _T_15 | _T_16; // @[Controller.scala 91:34]
  wire [1:0] _T_91 = _T_27 ? 2'h2 : 2'h0; // @[Mux.scala 98:16]
  wire  _T_97 = _T_30 | _T_12 | _T_13 | _T_15 | _T_16; // @[Controller.scala 95:41]
  wire  _T_103 = _T_6 | _T_17 | _T_18 | _T_21 | _T_22 | _T_23 | _T_26; // @[Controller.scala 96:49]
  wire [2:0] _T_104 = _T_14 ? 3'h4 : 3'h0; // @[Mux.scala 98:16]
  wire [2:0] _T_105 = _T_11 ? 3'h1 : _T_104; // @[Mux.scala 98:16]
  wire [2:0] _T_106 = _T_103 ? 3'h3 : _T_105; // @[Mux.scala 98:16]
  assign io_grfWriteAddrSel = _T_32 ? 2'h1 : _T_39; // @[Mux.scala 98:16]
  assign io_grfWriteDataSel = _T_46 ? 3'h0 : _T_50; // @[Mux.scala 98:16]
  assign io_grfWriteEn = _T_46 | _T_15 | _T_27 | _T_28 | _T_10; // @[Controller.scala 73:92]
  assign io_aluValue2Sel = _T_65 ? 2'h0 : _T_75; // @[Mux.scala 98:16]
  assign io_memWriteEn = io_opcode == 6'h2b; // @[Controller.scala 51:39]
  assign io_npcControl = _T_17 ? 4'h3 : _T_85; // @[Mux.scala 98:16]
  assign io_extControl = _T_90 ? 2'h1 : _T_91; // @[Mux.scala 98:16]
  assign io_aluControl = _T_97 ? 3'h2 : _T_106; // @[Mux.scala 98:16]
endmodule
module MIPS(
  input         clock,
  input         reset,
  output [31:0] io_pc
);
  wire  DataPath_clock; // @[MIPS.scala 12:32]
  wire  DataPath_reset; // @[MIPS.scala 12:32]
  wire [1:0] DataPath_io_grfWriteAddrSel; // @[MIPS.scala 12:32]
  wire [2:0] DataPath_io_grfWriteDataSel; // @[MIPS.scala 12:32]
  wire  DataPath_io_grfWriteEn; // @[MIPS.scala 12:32]
  wire [1:0] DataPath_io_aluValue2Sel; // @[MIPS.scala 12:32]
  wire  DataPath_io_memWriteEn; // @[MIPS.scala 12:32]
  wire [3:0] DataPath_io_npcControl; // @[MIPS.scala 12:32]
  wire [1:0] DataPath_io_extControl; // @[MIPS.scala 12:32]
  wire [2:0] DataPath_io_aluControl; // @[MIPS.scala 12:32]
  wire [5:0] DataPath_io_opcode; // @[MIPS.scala 12:32]
  wire [5:0] DataPath_io_funct; // @[MIPS.scala 12:32]
  wire [4:0] DataPath_io_flag; // @[MIPS.scala 12:32]
  wire [31:0] DataPath_io_currentPC; // @[MIPS.scala 12:32]
  wire [5:0] Controller_io_opcode; // @[MIPS.scala 13:34]
  wire [5:0] Controller_io_funct; // @[MIPS.scala 13:34]
  wire [4:0] Controller_io_flag; // @[MIPS.scala 13:34]
  wire [1:0] Controller_io_grfWriteAddrSel; // @[MIPS.scala 13:34]
  wire [2:0] Controller_io_grfWriteDataSel; // @[MIPS.scala 13:34]
  wire  Controller_io_grfWriteEn; // @[MIPS.scala 13:34]
  wire [1:0] Controller_io_aluValue2Sel; // @[MIPS.scala 13:34]
  wire  Controller_io_memWriteEn; // @[MIPS.scala 13:34]
  wire [3:0] Controller_io_npcControl; // @[MIPS.scala 13:34]
  wire [1:0] Controller_io_extControl; // @[MIPS.scala 13:34]
  wire [2:0] Controller_io_aluControl; // @[MIPS.scala 13:34]
  DataPath DataPath ( // @[MIPS.scala 12:32]
    .clock(DataPath_clock),
    .reset(DataPath_reset),
    .io_grfWriteAddrSel(DataPath_io_grfWriteAddrSel),
    .io_grfWriteDataSel(DataPath_io_grfWriteDataSel),
    .io_grfWriteEn(DataPath_io_grfWriteEn),
    .io_aluValue2Sel(DataPath_io_aluValue2Sel),
    .io_memWriteEn(DataPath_io_memWriteEn),
    .io_npcControl(DataPath_io_npcControl),
    .io_extControl(DataPath_io_extControl),
    .io_aluControl(DataPath_io_aluControl),
    .io_opcode(DataPath_io_opcode),
    .io_funct(DataPath_io_funct),
    .io_flag(DataPath_io_flag),
    .io_currentPC(DataPath_io_currentPC)
  );
  Controller Controller ( // @[MIPS.scala 13:34]
    .io_opcode(Controller_io_opcode),
    .io_funct(Controller_io_funct),
    .io_flag(Controller_io_flag),
    .io_grfWriteAddrSel(Controller_io_grfWriteAddrSel),
    .io_grfWriteDataSel(Controller_io_grfWriteDataSel),
    .io_grfWriteEn(Controller_io_grfWriteEn),
    .io_aluValue2Sel(Controller_io_aluValue2Sel),
    .io_memWriteEn(Controller_io_memWriteEn),
    .io_npcControl(Controller_io_npcControl),
    .io_extControl(Controller_io_extControl),
    .io_aluControl(Controller_io_aluControl)
  );
  assign io_pc = DataPath_io_currentPC; // @[MIPS.scala 15:9]
  assign DataPath_clock = clock;
  assign DataPath_reset = reset;
  assign DataPath_io_grfWriteAddrSel = Controller_io_grfWriteAddrSel; // @[MIPS.scala 17:31]
  assign DataPath_io_grfWriteDataSel = Controller_io_grfWriteDataSel; // @[MIPS.scala 18:31]
  assign DataPath_io_grfWriteEn = Controller_io_grfWriteEn; // @[MIPS.scala 19:26]
  assign DataPath_io_aluValue2Sel = Controller_io_aluValue2Sel; // @[MIPS.scala 20:28]
  assign DataPath_io_memWriteEn = Controller_io_memWriteEn; // @[MIPS.scala 21:26]
  assign DataPath_io_npcControl = Controller_io_npcControl; // @[MIPS.scala 22:26]
  assign DataPath_io_extControl = Controller_io_extControl; // @[MIPS.scala 23:26]
  assign DataPath_io_aluControl = Controller_io_aluControl; // @[MIPS.scala 24:26]
  assign Controller_io_opcode = DataPath_io_opcode; // @[MIPS.scala 26:24]
  assign Controller_io_funct = DataPath_io_funct; // @[MIPS.scala 27:23]
  assign Controller_io_flag = DataPath_io_flag; // @[MIPS.scala 28:22]
endmodule
