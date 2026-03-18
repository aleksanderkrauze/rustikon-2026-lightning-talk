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

int main() {
  Foo foo = Foo{"Rustikon"};
  return 0;
}
