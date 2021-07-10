package cpu.parts

import chisel3._

object ProgramCounter {
  class IOBundle extends Bundle {
    val enable      = Input(Bool())
    val next        = Input(UInt(32.W))
    val current     = Output(UInt(32.W))
  }
}

class ProgramCounter(private val init: Int) extends Module {
  val io = IO(new ProgramCounter.IOBundle)
  private val pc = RegInit(init.U)

  io.current := pc
  when (io.enable)  { pc := io.next }
    .otherwise      { pc := pc }
}
