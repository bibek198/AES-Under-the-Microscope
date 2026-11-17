// json_out.hpp — a tiny JSON object builder (one line per record = NDJSON).
#pragma once

#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace aes {

class Json {
 public:
  Json& str(std::string_view key, std::string_view value);
  Json& num(std::string_view key, double value);
  Json& integer(std::string_view key, int64_t value);
  Json& boolean(std::string_view key, bool value);
  Json& raw(std::string_view key, std::string_view json);  // pre-built JSON value
  Json& nums(std::string_view key, const std::vector<double>& values);
  Json& ints(std::string_view key, const std::vector<int64_t>& values);
  std::string done() const { return "{" + body_ + "}"; }

  static std::string escape(std::string_view s);

 private:
  void key(std::string_view k);
  std::string body_;
};

std::string json_number(double v);

} // namespace aes
