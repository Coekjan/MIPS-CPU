package cpu.parts

import Chisel.Cat
import chisel3._
import chisel3.experimental.{ChiselAnnotation, annotate}
import firrtl.annotations.MemoryScalarInitAnnotation

object DataMemory {
  class IOBundle(val addressSize: Int) extends Bundle {
    val writeEn     = Input(Bool())
    val currentPC   = Input(UInt(32.W))
    val address     = Input(UInt(addressSize.W))
    val dataIn      = Input(UInt(32.W))
    val dataOut     = Output(UInt(32.W))
  }
}

class DataMemory(val addressSize: Int) extends Module {
  val io = IO(new DataMemory.IOBundle(addressSize))
  private val memory = SyncReadMem(1 << (addressSize - 2), UInt(32.W))
  private val address = (io.address >> 2).asUInt()

  io.dataOut := memory.read(address)
  when (io.writeEn) {
    memory.write(address, io.dataIn)
    printf("@%x: *%x <= %x\n", io.currentPC, Cat(0.U((32 - addressSize).W), io.address), io.dataIn.asUInt())
  }

  annotate(new ChiselAnnotation {
    override def toFirrtl = MemoryScalarInitAnnotation(memory.toTarget, 0)
  })
}
