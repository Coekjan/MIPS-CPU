package cpu.parts

import Chisel.Cat
import chisel3._

object DataMemory {
  class IOBundle(val addressSize: Int) extends Bundle {
    val writeEn     = Input(Bool())
    val currentPC   = Input(UInt(32.W))
    val address     = Input(UInt(addressSize.W))
    val dataIn      = Input(Vec(4, UInt(8.W)))
    val dataOut     = Output(Vec(4, UInt(8.W)))
  }
}

class DataMemory(val addressSize: Int) extends Module {
  val io = IO(new DataMemory.IOBundle(addressSize))
  private val memory = Mem(1 << (addressSize - 2), Vec(4, UInt(8.W)))
  private val address = (io.address >> 2).asUInt()

  io.dataOut := memory.read(address)
  when (io.writeEn) {
    memory.write(address, io.dataIn, Seq(true.B, true.B, true.B, true.B))
    printf("@%x: *%x <= %x\n", io.currentPC, Cat(0.U((32 - addressSize).W), io.address), io.dataIn.asUInt())
  }
}
