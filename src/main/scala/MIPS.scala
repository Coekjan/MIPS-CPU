import chisel3._
import cpu.{Controller, DataPath}

object MIPS {
  class IOBundle extends Bundle {
    val pc = Output(UInt(32.W))
  }
}

class MIPS extends Module {
  val io = IO(new MIPS.IOBundle)
  private val dataPath = Module(new DataPath)
  private val controller = Module(new Controller)

  io.pc := dataPath.io.currentPC

  dataPath.io.grfWriteAddrSel := controller.io.grfWriteAddrSel
  dataPath.io.grfWriteDataSel := controller.io.grfWriteDataSel
  dataPath.io.grfWriteEn := controller.io.grfWriteEn
  dataPath.io.aluValue2Sel := controller.io.aluValue2Sel
  dataPath.io.memWriteEn := controller.io.memWriteEn
  dataPath.io.npcControl := controller.io.npcControl
  dataPath.io.extControl := controller.io.extControl
  dataPath.io.aluControl := controller.io.aluControl

  controller.io.opcode := dataPath.io.opcode
  controller.io.funct := dataPath.io.funct
  controller.io.flag := dataPath.io.flag
}
