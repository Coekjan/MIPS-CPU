package cpu.parts

import Chisel.MuxCase
import chisel3._
import chisel3.experimental.ChiselEnum
import cpu.parts.ArithmeticLogicUnit.Signal.EQ_ZR

object ArithmeticLogicUnit {
  object Control extends ChiselEnum {
    val AND, OR, ADDU, SUBU, SLT, XOR = Value
  }

  object Signal extends ChiselEnum {
    val EQ_ZR, GT_ZR, LT_ZR = Value
  }

  class IOBundle extends Bundle {
    val control     = Input(Control())
    val value1      = Input(UInt(32.W))
    val value2      = Input(UInt(32.W))
    val signal      = Output(Signal())
    val output      = Output(UInt(32.W))
  }
}

import cpu.parts.ArithmeticLogicUnit.Control._
import cpu.parts.ArithmeticLogicUnit.Signal._

class ArithmeticLogicUnit extends Module{
  val io = IO(new ArithmeticLogicUnit.IOBundle)

  io.output := MuxCase(0.U, Seq(
    (io.control === AND)  -> (io.value1 & io.value2),
    (io.control === OR)   -> (io.value1 | io.value2),
    (io.control === XOR)  -> (io.value1 ^ io.value2),
    (io.control === ADDU) -> (io.value1 + io.value2),
    (io.control === SUBU) -> (io.value1 - io.value2),
    (io.control === SLT)  -> (io.value1.asSInt() < io.value2.asSInt()).asUInt()
  ))

  io.signal := MuxCase(EQ_ZR, Seq(
    (io.output === 0.U)         -> EQ_ZR,
    (io.output >> 31).asBool()  -> LT_ZR,
    !(io.output >> 31).asBool() -> GT_ZR
  ))
}