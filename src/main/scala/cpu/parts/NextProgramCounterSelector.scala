package cpu.parts

import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util.{Cat, Fill, MuxCase}
import cpu.parts.ArithmeticLogicUnit.Signal

object NextProgramCounterSelector {
  object Control extends ChiselEnum {
    val COMMON, JUMP_ADDR, JUMP_REG, BRANCH_EQ, BRANCH_NEQ, BRANCH_GT, BRANCH_GE, BRANCH_LT, BRANCH_LE = Value
  }

  class IOBundle extends Bundle {
    val control           = Input(Control())
    val signal            = Input(Signal())
    val current           = Input(UInt(32.W))
    val branchOffset      = Input(UInt(16.W))
    val jumpAddress       = Input(UInt(26.W))
    val jumpRegister      = Input(UInt(32.W))
    val next              = Output(UInt(32.W))
    val currentPlus4      = Output(UInt(32.W))
  }
}

import cpu.parts.NextProgramCounterSelector.Control._

class NextProgramCounterSelector extends Module {
  val io = IO(new NextProgramCounterSelector.IOBundle)
  private val branchOffset = Cat(Fill(14, (io.branchOffset >> 15).asUInt()), io.branchOffset, 0.U(2.W))

  io.currentPlus4 := io.current + 4.U
  io.next         := MuxCase(io.currentPlus4, Seq(
    (io.control === COMMON)                                       -> io.currentPlus4,
    (io.control === JUMP_ADDR)                                    -> Cat(io.current >> 28, io.jumpAddress << 2),
    (io.control === JUMP_REG)                                     -> io.jumpRegister,
    (io.control === BRANCH_EQ && io.signal === Signal.EQ_ZR)      -> (io.currentPlus4 + branchOffset),
    (io.control === BRANCH_NEQ && io.signal =/= Signal.EQ_ZR)     -> (io.currentPlus4 + branchOffset),
    (io.control === BRANCH_GT && io.signal === Signal.GT_ZR)      -> (io.currentPlus4 + branchOffset),
    (io.control === BRANCH_GE &&
      (io.signal === Signal.GT_ZR || io.signal === Signal.EQ_ZR)) -> (io.currentPlus4 + branchOffset),
    (io.control === BRANCH_LT && io.signal === Signal.LT_ZR)      -> (io.currentPlus4 + branchOffset),
    (io.control === BRANCH_LE &&
      (io.signal === Signal.LT_ZR || io.signal === Signal.EQ_ZR)) -> (io.currentPlus4 + branchOffset)
  ))
}
