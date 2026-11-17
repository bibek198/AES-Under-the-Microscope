// test_differential.cpp — all implementations must agree on random inputs.
#include <cstring>
#include <random>

#include "aes_common.hpp"
#include "check.hpp"

using namespace testing;

int main() {
  constexpr int kPairs = 100000;
  std::mt19937_64 rng(20261117);  // fixed seed: reproducible
  auto rand_block = [&](uint8_t* b) {
    for (int i = 0; i < 16; i += 8) {
      const uint64_t r = rng();
      std::memcpy(b + i, &r, 8);
    }
  };

  const auto& names = aes::all_impl_names();
  std::vector<std::unique_ptr<aes::Aes128>> impls;
  for (const auto& n : names) impls.push_back(aes::make_impl(n));

  std::vector<int> mismatches(names.size(), 0);
  uint8_t key[16], pt[16], expect[16], got[16];
  for (int i = 0; i < kPairs; ++i) {
    rand_block(key);
    rand_block(pt);
    impls[0]->set_key(key);
    impls[0]->encrypt_block(pt, expect);
    for (size_t j = 1; j < impls.size(); ++j) {
      impls[j]->set_key(key);
      impls[j]->encrypt_block(pt, got);
      if (std::memcmp(got, expect, 16) != 0) ++mismatches[j];
    }
  }
  for (size_t j = 1; j < impls.size(); ++j)
    check(mismatches[j] == 0, names[j] + " agrees with ref on " + std::to_string(kPairs) +
                                  " random pairs (" + std::to_string(mismatches[j]) + " mismatches)");

  // Bulk ECB path must equal block-by-block encryption.
  constexpr size_t kBlocks = 1027;  // deliberately not a multiple of 4
  std::vector<uint8_t> in(16 * kBlocks), ref_out(16 * kBlocks), bulk_out(16 * kBlocks);
  for (size_t i = 0; i < kBlocks; ++i) rand_block(in.data() + 16 * i);
  rand_block(key);
  impls[0]->set_key(key);
  impls[0]->encrypt_blocks(in.data(), ref_out.data(), kBlocks);
  for (size_t j = 0; j < impls.size(); ++j) {
    impls[j]->set_key(key);
    impls[j]->encrypt_blocks(in.data(), bulk_out.data(), kBlocks);
    check(bulk_out == ref_out, names[j] + ": bulk encrypt_blocks matches ref");
  }
  return finish("test_differential");
}
