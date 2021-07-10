package cpu.parts

import chisel3._
import chisel3.util.experimental._

object InstructionMemory {
  class IOBundle(val addressSize: Int) extends Bundle {
    val address     = Input(UInt(addressSize.W))
    val dataOut     = Output(UInt(32.W))
  }
}

class InstructionMemory(val addressSize: Int) extends Module {
  val io = IO(new InstructionMemory.IOBundle(addressSize))
  private val memory = Mem(1 << (addressSize - 2), UInt(32.W))
  private val address = (io.address >> 2).asUInt()

  loadMemoryFromFileInline(memory, "code.txt")

  io.dataOut := memory.read(address)
}
