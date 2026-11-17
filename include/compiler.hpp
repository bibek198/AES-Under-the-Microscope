// compiler.hpp — helpers that stop the optimiser from deleting benchmark work.
#pragma once

namespace aes {

// Tells the compiler that `value` is read by something it cannot see, so
// the computation producing it must happen. Emits no instructions.
template <typename T>
inline void do_not_optimize(const T& value) {
  asm volatile("" : : "r,m"(value) : "memory");
}

// Compiler-level memory barrier: no loads or stores move across it.
inline void clobber_memory() { asm volatile("" : : : "memory"); }

} // namespace aes
