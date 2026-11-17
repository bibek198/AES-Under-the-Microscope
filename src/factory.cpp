// factory.cpp — create implementations by name.
#include "aes_impls.hpp"
#include "controls.hpp"

namespace aes {

const std::vector<std::string>& impl_names() {
  static const std::vector<std::string> names = {"ref", "ttable", "ct", "armv8", "openssl"};
  return names;
}

const std::vector<std::string>& all_impl_names() {
  static const std::vector<std::string> names = {"ref",     "ttable",    "ct",      "armv8",
                                                 "openssl", "pos_leaky", "pos_twin"};
  return names;
}

std::unique_ptr<Aes128> make_impl(std::string_view name) {
  if (name == "ref") return make_ref();
  if (name == "ttable") return make_ttable();
  if (name == "ct") return make_ct();
  if (name == "armv8") return make_armv8();
  if (name == "openssl") return make_openssl();
  if (name == "pos_leaky") return make_pos_leaky();
  if (name == "pos_twin") return make_pos_twin();
  return nullptr;
}

} // namespace aes
