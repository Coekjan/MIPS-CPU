package cpu

import chisel3._
import chisel3.util.MuxCase
import cpu.parts.{ArithmeticLogicUnit, DataMemory, Extender, GeneralRegisterFile, InstructionMemory, NextProgramCounterSelector, ProgramCounter}
import cpu.utils.WordTo4Bytes

object DataPath {
  class IOBundle extends Bundle {
    val grfWriteAddrSel       = Input(Controller.GRFWriteAddrSelector())
    val grfWriteDataSel       = Input(Controller.GRFWriteDataSelector())
    val grfWriteEn            = Input(Bool())
    val aluValue2Sel          = Input(Controller.ALUValue2Selector())
    val memWriteEn            = Input(Bool())
    val npcControl            = Input(NextProgramCounterSelector.Control())
    val extControl            = Input(Extender.Control())
    val aluControl            = Input(ArithmeticLogicUnit.Control())
    val opcode                = Output(UInt(6.W))
    val funct                 = Output(UInt(6.W))
    val flag                  = Output(UInt(5.W))
    val currentPC             = Output(UInt(32.W))
  }
}

class DataPath extends Module{
  val io = IO(new DataPath.IOBundle)
  private val pc = Module(new ProgramCounter(0x3000))
  private val im = Module(new InstructionMemory(12))
  private val npc = Module(new NextProgramCounterSelector)
  private val grf = Module(new GeneralRegisterFile)
  private val ext = Module(new Extender)
  private val alu = Module(new ArithmeticLogicUnit)
  private val dm = Module(new DataMemory(22))

  io.opcode := (im.io.dataOut >> 26).asUInt()
  io.funct := im.io.dataOut & 0x3f.U
  io.flag := (im.io.dataOut >> 16).asUInt() & 0x1f.U
  io.currentPC := pc.io.current

  pc.io.next := npc.io.next
  pc.io.enable := true.B

  im.io.address := pc.io.current

  npc.io.current := pc.io.current
  npc.io.control := io.npcControl
  npc.io.signal := alu.io.signal
  npc.io.branchOffset := im.io.dataOut & 0xffff.U
  npc.io.jumpAddress := im.io.dataOut & 0x3ffffff.U
  npc.io.jumpRegister := grf.io.readData1

  grf.io.currentPC := pc.io.current
  grf.io.writeEn := io.grfWriteEn
  grf.io.readAddr1 := (im.io.dataOut >> 21).asUInt() & 0x1f.U
  grf.io.readAddr2 := (im.io.dataOut >> 16).asUInt() & 0x1f.U
  grf.io.writeAddr := MuxCase(0.U, Seq(
    (io.grfWriteAddrSel === Controller.GRFWriteAddrSelector.RD) -> ((im.io.dataOut >> 11).asUInt() & 0x1f.U),
    (io.grfWriteAddrSel === Controller.GRFWriteAddrSelector.RT) -> ((im.io.dataOut >> 16).asUInt() & 0x1f.U),
    (io.grfWriteAddrSel === Controller.GRFWriteAddrSelector.RA) -> 0x1f.U
  ))
  grf.io.writeData := MuxCase(DontCare, Seq(
    (io.grfWriteDataSel === Controller.GRFWriteDataSelector.ALU_OUT)  -> alu.io.output,
    (io.grfWriteDataSel === Controller.GRFWriteDataSelector.DM_OUT)   -> dm.io.dataOut.asUInt(),
    (io.grfWriteDataSel === Controller.GRFWriteDataSelector.EXT_OUT)  -> ext.io.dataOut,
    (io.grfWriteDataSel === Controller.GRFWriteDataSelector.NPC_PC4)  -> npc.io.currentPlus4
  ))

  ext.io.control := io.extControl
  ext.io.dataIn := im.io.dataOut & 0xffff.U

  alu.io.control := io.aluControl
  alu.io.value1 := grf.io.readData1
  alu.io.value2 := MuxCase(0.U, Seq(
    (io.aluValue2Sel === Controller.ALUValue2Selector.GRF_RD2)  -> grf.io.readData2,
    (io.aluValue2Sel === Controller.ALUValue2Selector.EXT_OUT)  -> ext.io.dataOut
  ))

  dm.io.currentPC := pc.io.current
  dm.io.writeEn := io.memWriteEn
  dm.io.address := alu.io.output
  dm.io.dataIn := WordTo4Bytes(grf.io.readData2)
}
