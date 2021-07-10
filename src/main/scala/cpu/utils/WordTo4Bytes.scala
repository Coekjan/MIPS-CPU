package cpu.utils

import chisel3._

object WordTo4Bytes {
  def apply(word: UInt) = word.asTypeOf(new WordTo4Bytes).bytes
}

class WordTo4Bytes extends Bundle {
  val bytes = Vec(4, UInt(8.W))
}
