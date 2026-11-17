// json_out.cpp
#include "json_out.hpp"

#include <cmath>
#include <cstdio>

namespace aes {

std::string json_number(double v) {
  if (!std::isfinite(v)) return "null";
  char buf[32];
  std::snprintf(buf, sizeof buf, "%.10g", v);
  return buf;
}

std::string Json::escape(std::string_view s) {
  std::string out = "\"";
  for (char c : s) {
    switch (c) {
      case '"': out += "\\\""; break;
      case '\\': out += "\\\\"; break;
      case '\n': out += "\\n"; break;
      case '\r': out += "\\r"; break;
      case '\t': out += "\\t"; break;
      default:
        if (static_cast<unsigned char>(c) < 0x20) {
          char buf[8];
          std::snprintf(buf, sizeof buf, "\\u%04x", c);
          out += buf;
        } else {
          out += c;
        }
    }
  }
  return out + "\"";
}

void Json::key(std::string_view k) {
  if (!body_.empty()) body_ += ",";
  body_ += escape(k) + ":";
}

Json& Json::str(std::string_view k, std::string_view v) { key(k); body_ += escape(v); return *this; }
Json& Json::num(std::string_view k, double v) { key(k); body_ += json_number(v); return *this; }
Json& Json::integer(std::string_view k, int64_t v) { key(k); body_ += std::to_string(v); return *this; }
Json& Json::boolean(std::string_view k, bool v) { key(k); body_ += v ? "true" : "false"; return *this; }
Json& Json::raw(std::string_view k, std::string_view j) { key(k); body_ += j; return *this; }

Json& Json::nums(std::string_view k, const std::vector<double>& v) {
  key(k);
  body_ += "[";
  for (size_t i = 0; i < v.size(); ++i) body_ += (i ? "," : "") + json_number(v[i]);
  body_ += "]";
  return *this;
}

Json& Json::ints(std::string_view k, const std::vector<int64_t>& v) {
  key(k);
  body_ += "[";
  for (size_t i = 0; i < v.size(); ++i) body_ += (i ? "," : "") + std::to_string(v[i]);
  body_ += "]";
  return *this;
}

} // namespace aes
