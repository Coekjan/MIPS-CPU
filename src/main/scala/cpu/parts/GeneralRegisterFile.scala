package cpu.parts

import chisel3._

object GeneralRegisterFile {
  class IOBundle extends Bundle {
    val writeEn     = Input(Bool())
    val currentPC   = Input(UInt(32.W))
    val readAddr1   = Input(UInt(5.W))
    val readAddr2   = Input(UInt(5.W))
    val writeAddr   = Input(UInt(5.W))
    val writeData   = Input(UInt(32.W))
    val readData1   = Output(UInt(32.W))
    val readData2   = Output(UInt(32.W))
  }
}

class GeneralRegisterFile extends Module {
  val io = IO(new GeneralRegisterFile.IOBundle)
  private val registers = RegInit(VecInit(Seq.fill(32)(0.U(32.W))))

  private def read(addr: UInt): UInt = Mux(addr =/= 0.U(5.W), registers(addr), 0.U)

  io.readData1 := read(io.readAddr1)
  io.readData2 := read(io.readAddr2)

  when (io.writeEn) {
    registers(io.writeAddr) := io.writeData
    when (io.writeAddr =/= 0.U(5.W)) {
      printf("@%x: $%d <= %x\n", io.currentPC, io.writeAddr, io.writeData)
    }
  }
}
