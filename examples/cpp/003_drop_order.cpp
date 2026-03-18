#include <print>
#include <string>

class Logger {
  std::string m_message;

public:
  Logger(const char *message) : m_message{message} {}
  ~Logger() { std::println("{}", m_message); }
};

class Foo {
  Logger a;
  Logger b;
  Logger c;

public:
  Foo() : a{"a"}, b{"b"}, c{"c"} {}
  ~Foo() { std::println("Foo"); }
};

int main() {
  Foo foo = Foo{};

  return 0;
}
