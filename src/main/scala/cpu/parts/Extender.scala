package cpu.parts

import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util.{Cat, Fill, MuxCase}

object Extender {
  object Control extends ChiselEnum {
    val ZERO, SIGN, HIGH = Value
  }

  class IOBundle extends Bundle {
    val control     = Input(Control())
    val dataIn      = Input(UInt(16.W))
    val dataOut     = Output(UInt(32.W))
  }
}

import cpu.parts.Extender.Control._

class Extender extends Module {
  val io = IO(new Extender.IOBundle)

  io.dataOut := MuxCase(0.U, Seq(
    (io.control === SIGN) -> Cat(Fill(16, (io.dataIn >> 15).asUInt()), io.dataIn),
    (io.control === ZERO) -> Cat(0.U(16.W), io.dataIn),
    (io.control === HIGH) -> Cat(io.dataIn, 0.U(16.W))
  ))
}
