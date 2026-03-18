#include <print>
#include <string>

class Logger {
  std::string m_message;

public:
  Logger(const char *message) : m_message{message} {}
  ~Logger() { std::println("{}", m_message); }
};

class Foo {
  union {
    Logger a;
  };
  union {
    Logger b;
  };
  union {
    Logger c;
  };

public:
  Foo() : a{"a"}, b{"b"}, c{"c"} {}
  ~Foo() {
    a.~Logger();
    c.~Logger();
    b.~Logger();
  }
};

int main() {
  Foo foo = Foo{};

  return 0;
}
