// aes_openssl.cpp — OpenSSL 3 EVP AES-128-ECB as a production baseline.
//
// ECB is used ONLY as a single-block experimental interface: it encrypts
// each block independently, so equal plaintext blocks give equal
// ciphertext blocks. Never use ECB for real data; use an authenticated mode
// such as AES-GCM.
//
// OpenSSL selects its AES code path at runtime from the CPU capabilities
// (on Apple Silicon normally the ARMv8 AES instructions). Setting the
// environment variable OPENSSL_armcap=0 disables that detection and forces
// a software fallback. The project does not assume either path is
// constant-time; it measures them.
#include "aes_impls.hpp"

#include <openssl/err.h>
#include <openssl/evp.h>

#include <stdexcept>

namespace aes {
namespace {

class AesOpenSsl final : public Aes128 {
 public:
  AesOpenSsl() {
    cipher_ = EVP_CIPHER_fetch(nullptr, "AES-128-ECB", nullptr);
    ctx_ = EVP_CIPHER_CTX_new();
    if (!cipher_ || !ctx_) throw std::runtime_error("OpenSSL: cannot create AES-128-ECB context");
  }
  ~AesOpenSsl() override {
    EVP_CIPHER_CTX_free(ctx_);
    EVP_CIPHER_free(cipher_);
  }
  AesOpenSsl(const AesOpenSsl&) = delete;
  AesOpenSsl& operator=(const AesOpenSsl&) = delete;

  void set_key(const uint8_t key[kKeyBytes]) override {
    if (EVP_EncryptInit_ex2(ctx_, cipher_, key, nullptr, nullptr) != 1)
      throw std::runtime_error("OpenSSL: EVP_EncryptInit_ex2 failed");
    EVP_CIPHER_CTX_set_padding(ctx_, 0);  // exact 16-byte blocks, no padding
  }

  void encrypt_block(const uint8_t in[16], uint8_t out[16]) const override {
    int len = 0;
    // The context is reused across calls (re-creating it per block would
    // measure allocation, not AES).
    EVP_EncryptUpdate(ctx_, out, &len, in, 16);
  }

  void encrypt_blocks(const uint8_t* in, uint8_t* out, size_t n) const override {
    int len = 0;
    EVP_EncryptUpdate(ctx_, out, &len, in, static_cast<int>(16 * n));
  }

  const char* name() const override { return "openssl"; }

 private:
  EVP_CIPHER* cipher_ = nullptr;
  EVP_CIPHER_CTX* ctx_ = nullptr;
};

} // namespace

std::unique_ptr<Aes128> make_openssl() { return std::make_unique<AesOpenSsl>(); }

} // namespace aes
