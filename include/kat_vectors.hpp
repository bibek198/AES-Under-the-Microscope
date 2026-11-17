// kat_vectors.hpp — official AES-128 known-answer vectors (single source of
// truth for the unit tests and the runtime self-test).
#pragma once

namespace aes {

struct KnownAnswer {
  const char* key;
  const char* plaintext;
  const char* ciphertext;
  const char* label;
};

inline constexpr KnownAnswer kKnownAnswers[] = {
    // FIPS-197 Appendix C.1
    {"000102030405060708090a0b0c0d0e0f", "00112233445566778899aabbccddeeff",
     "69c4e0d86a7b0430d8cdb78070b4c55a", "FIPS-197 C.1"},
    // FIPS-197 Appendix B
    {"2b7e151628aed2a6abf7158809cf4f3c", "3243f6a8885a308d313198a2e0370734",
     "3925841d02dc09fbdc118597196a0b32", "FIPS-197 B"},
    // NIST SP 800-38A F.1.1 ECB-AES128.Encrypt, blocks 1-4
    {"2b7e151628aed2a6abf7158809cf4f3c", "6bc1bee22e409f96e93d7e117393172a",
     "3ad77bb40d7a3660a89ecaf32466ef97", "SP 800-38A F.1.1 #1"},
    {"2b7e151628aed2a6abf7158809cf4f3c", "ae2d8a571e03ac9c9eb76fac45af8e51",
     "f5d3d58503b9699de785895a96fdbaaf", "SP 800-38A F.1.1 #2"},
    {"2b7e151628aed2a6abf7158809cf4f3c", "30c81c46a35ce411e5fbc1191a0a52ef",
     "43b1cd7f598ece23881b00e3ed030688", "SP 800-38A F.1.1 #3"},
    {"2b7e151628aed2a6abf7158809cf4f3c", "f69f2445df4f9b17ad2b417be66c3710",
     "7b0c785e27e8ad3f8223207104725dd4", "SP 800-38A F.1.1 #4"},
};

} // namespace aes
