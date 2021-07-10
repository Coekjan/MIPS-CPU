package cpu

import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util.MuxCase
import cpu.parts.{ArithmeticLogicUnit, Extender, NextProgramCounterSelector}

object Controller {
  object GRFWriteAddrSelector extends ChiselEnum {
    val RT, RD, RA, ZR = Value
  }

  object GRFWriteDataSelector extends ChiselEnum {
    val ALU_OUT, DM_OUT, EXT_OUT, NPC_PC4, VOID = Value
  }

  object ALUValue2Selector extends ChiselEnum {
    val GRF_RD2, EXT_OUT, ZERO = Value
  }

  class IOBundle extends Bundle {
    val opcode                  = Input(UInt(6.W))
    val funct                   = Input(UInt(6.W))
    val flag                    = Input(UInt(5.W))
    val grfWriteAddrSel         = Output(GRFWriteAddrSelector())
    val grfWriteDataSel         = Output(GRFWriteDataSelector())
    val grfWriteEn              = Output(Bool())
    val aluValue2Sel            = Output(ALUValue2Selector())
    val memWriteEn              = Output(Bool())
    val npcControl              = Output(NextProgramCounterSelector.Control())
    val extControl              = Output(Extender.Control())
    val aluControl              = Output(ArithmeticLogicUnit.Control())
  }
}

import Controller._

class Controller extends Module {
  val io = IO(new Controller.IOBundle)
  private val regType     = io.opcode === "b_000000".U
  private val add         = regType && io.funct === "b_100000".U
  private val addu        = regType && io.funct === "b_100001".U
  private val subu        = regType && io.funct === "b_100011".U
  private val jr          = regType && io.funct === "b_001000".U
  private val jalr        = regType && io.funct === "b_001001".U
  private val ori         = io.opcode === "b_001101".U
  private val addi        = io.opcode === "b_001000".U
  private val addiu       = io.opcode === "b_001001".U
  private val slti        = io.opcode === "b_001010".U
  private val lw          = io.opcode === "b_100011".U
  private val sw          = io.opcode === "b_101011".U
  private val beq         = io.opcode === "b_000100".U
  private val bne         = io.opcode === "b_000101".U
  private val bgez        = io.opcode === "b_000001".U && io.flag === "b_00001".U
  private val bgtz        = io.opcode === "b_000111".U
  private val blez        = io.opcode === "b_000110".U
  private val bltz        = io.opcode === "b_000001".U && io.flag === "b_00000".U
  private val lui         = io.opcode === "b_001111".U
  private val jal         = io.opcode === "b_000011".U
  private val j           = io.opcode === "b_000010".U

  io.grfWriteAddrSel := MuxCase(GRFWriteAddrSelector.ZR, Seq(
    (add || addu || subu || jalr)                   -> GRFWriteAddrSelector.RD,
    (ori || addi || addiu || slti || lw || lui)     -> GRFWriteAddrSelector.RT,
    (jal)                                           -> GRFWriteAddrSelector.RA
  ))
  io.grfWriteDataSel := MuxCase(GRFWriteDataSelector.VOID, Seq(
    (add || addu || subu || ori || addi || addiu || slti)   -> GRFWriteDataSelector.ALU_OUT,
    (lw)                                                    -> GRFWriteDataSelector.DM_OUT,
    (lui)                                                   -> GRFWriteDataSelector.EXT_OUT,
    (jal || jalr)                                           -> GRFWriteDataSelector.NPC_PC4
  ))
  io.grfWriteEn := add || addu || subu || ori || addi || addiu || slti || lw || lui || jal || jalr
  io.aluValue2Sel := MuxCase(ALUValue2Selector.ZERO, Seq(
    (add || addu || subu || beq || bne)             -> ALUValue2Selector.GRF_RD2,
    (ori || addi || addiu || slti || lw || sw)      -> ALUValue2Selector.EXT_OUT,
    (bgez || bgtz || blez || bltz)                  -> ALUValue2Selector.ZERO
  ))
  io.memWriteEn := sw
  io.npcControl := MuxCase(NextProgramCounterSelector.Control.COMMON, Seq(
    (beq)                   -> NextProgramCounterSelector.Control.BRANCH_EQ,
    (bne)                   -> NextProgramCounterSelector.Control.BRANCH_NEQ,
    (bgez)                  -> NextProgramCounterSelector.Control.BRANCH_GE,
    (bgtz)                  -> NextProgramCounterSelector.Control.BRANCH_GT,
    (blez)                  -> NextProgramCounterSelector.Control.BRANCH_LE,
    (bltz)                  -> NextProgramCounterSelector.Control.BRANCH_LT,
    (jal || j)              -> NextProgramCounterSelector.Control.JUMP_ADDR,
    (jr || jalr)            -> NextProgramCounterSelector.Control.JUMP_REG
  ))
  io.extControl := MuxCase(Extender.Control.ZERO, Seq(
    (addi || addiu || slti || lw || sw)   -> Extender.Control.SIGN,
    (lui)                                 -> Extender.Control.HIGH
  ))
  io.aluControl := MuxCase(ArithmeticLogicUnit.Control.AND, Seq(
    (add || addu || addi || addiu || lw || sw)            -> ArithmeticLogicUnit.Control.ADDU,
    (subu || beq || bne || bgez || bgtz || blez || bltz)  -> ArithmeticLogicUnit.Control.SUBU,
    (ori)                                                 -> ArithmeticLogicUnit.Control.OR,
    (slti)                                                -> ArithmeticLogicUnit.Control.SLT
  ))
}
