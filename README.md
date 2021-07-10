Single Cycle CPU
===

## Instructions

The CPU supports the following instructions:
* **R-type**: `add`, `addu`, `subu`, `jr`, `jalr`
* **I-type**: `ori`, `addi`, `addiu`, `slti`, `lw`, `sw`, `beq`, `bne`, `bgez`, `bgtz`, `blez`, `bltz`, `lui`
* **J-type**: `jal`, `j`

## Test

### Generate Verilog from Scala

```scala
import chisel3._
import chisel3.stage.ChiselStage
import chisel3.tester._
import org.scalatest.FreeSpec

class MIPSTest extends FreeSpec with ChiselScalatestTester {
  "MIPSTest" in {
    new ChiselStage().emitVerilog(new MIPS)
  }
}
```

### MIPS Test-bench

```verilog
`timescale 1ns / 1ps
module MIPS_TB;
    reg clock;
    reg reset;
    MIPS uut (
        .clock(clock),
        .reset(reset)
    );
    initial begin
        clock = 0;
        reset = 1;
        #10
        reset = 0;
    end
    always #5 clock = ~clock;
endmodule
```