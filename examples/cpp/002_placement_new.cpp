#include <string>
#include <vector>

class Foo {
  std::string m_name;
  std::vector<int> m_data;
  std::size_t m_len;

public:
  explicit Foo(const char *name)
      : m_name{name}, m_data{}, m_len{this->m_name.length()} {}
};

void use_foo(const Foo &foo) {}

int main() {
  alignas(Foo) std::byte buf[sizeof(Foo)];

  Foo *foo = new (buf) Foo{"Rustikon"};
  use_foo(*foo);
  foo->~Foo();

  return 0;
}
