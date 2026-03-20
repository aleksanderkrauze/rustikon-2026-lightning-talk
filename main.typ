#import "rustikon.typ": *

#show: rustikon

#title-slide(
  [ Manual (de)initialization ],
  subtitle: [ A Rust and C++ showcase ],
)

#slide[
  #text(size: 20pt)[
    Aleksander Krauze \
    #link("https://github.com/aleksanderkrauze")[github.com/aleksanderkrauze] \
    #link( "mailto:aleksander.krauze@zoho.com",)[aleksander.krauze\@zoho.com] \
    #link("https://exein.io")[exein.io]
  ]

  #set align(bottom)
  #set text(size: 18pt)
  ```rust
  trait Exein: Rust + Security {}
  ```
]

#slide[
  About
]

#slide[
  Boring code
]

#slide2(
  left: [
    #set text(size: 8pt)
    #set align(top)

    ```rust
    pub struct Foo {
        name: String,
        data: Vec<i32>,
        len: usize,
    }

    impl Foo {
        pub fn new(name: &str) -> Self {
            let name = name.to_owned();
            let len = name.len();

            Self {
                name,
                data: Vec::new(),
                len,
            }
        }
    }

    fn main() {
        let foo = Foo::new("Rustikon");
    }
    ```
  ],
  right: [
    #set text(size: 8pt)
    #set align(top)

    ```cpp
    #include <string>
    #include <vector>

    class Foo {
      std::string m_name;
      std::vector<int> m_data;
      std::size_t m_len;

    public:
      explicit Foo(const char *name)
          : m_name{name}
          , m_data{}
          , m_len{this->m_name.length()}
        {}
    };

    int main() {
      Foo foo = Foo{"Rustikon"};

      return 0;
    }
    ```
  ],
)

#slide[
  Manual memory initialization in Rust
]

#slide[
  `std::mem::MaybeUninit`
]

#slide2flow[
  #set text(size: 5.8pt)
  ```rust
  use std::mem::MaybeUninit;
  use std::ptr;

  pub struct Foo {
      name: String,
      data: Vec<i32>,
      len: usize,
  }

  impl Foo {
      pub fn new_in<'storage>(
        this: &'storage mut MaybeUninit<Self>,
        name: &str
      ) -> &'storage mut Self {
        let this = this.as_mut_ptr();

        let name = name.to_owned();
        let data = Vec::new();

        unsafe {
          ptr::write(&raw mut (*this).name, name);
          ptr::write(&raw mut (*this).data, data);

          let len = unsafe {
              let name = &*(&raw const (*this).name);
              name.len()
          };
          ptr::write(&raw mut (*this).len, len);
        }

        unsafe { &mut *this }
      }
  }
  ```

  #colbreak()

  #block-with-offset(offset: 33)[
  ```rust
  fn use_foo(_foo: &Foo) {}

  fn main() {
      let mut storage = MaybeUninit::uninit();

      let foo = Foo::new_in(&mut storage, "Rustikon");
      use_foo(&*foo);

      unsafe {
          storage.assume_init_drop();
      }
  }
  ```
  ]
]

#slide[
  Manual memory initialization in C++
]

#slide2flow[
  #set text(size: 8pt)

  ```cpp
  #include <string>
  #include <vector>

  class Foo {
    std::string m_name;
    std::vector<int> m_data;
    std::size_t m_len;

  public:
    explicit Foo(const char *name)
        : m_name{name}
        , m_data{}
        , m_len{this->m_name.length()}
      {}
  };

  void use_foo(const Foo &foo) {}
  ```

  #colbreak()

  #block-with-offset(offset: 17)[
  ```cpp

  int main() {
    alignas(Foo) std::byte buf[sizeof(Foo)];

    Foo *foo = new (buf) Foo{"Rustikon"};
    use_foo(*foo);
    foo->~Foo();

    return 0;
  }
  ```
  ]

]

#slide[
  Destructors, Drop, and Drop-glue
]

#slide[
  Normal memory deinitialization in C++
]


#slide2flow[
  #set text(size: 7pt)
  ```cpp
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
  ```

  ```
  Output:
  Foo
  c
  b
  a
  ```
]

#slide[
  Normal memory deinitialization in Rust
]

#slide2flow[
  #set text(size: 7pt)

  ```rust
  pub struct Logger(String);

  impl Drop for Logger {
      fn drop(&mut self) {
          println!("{}", self.0);
      }
  }

  pub struct Foo {
      a: Logger,
      b: Logger,
      c: Logger,
  }

  impl Drop for Foo {
      fn drop(&mut self) {
          println!("Foo");
      }
  }
  ```
  
  #colbreak()

  #block-with-offset(offset: 19)[
  ```rust

  impl Foo {
      pub fn new() -> Self {
          Self {
              a: Logger("a".to_owned()),
              b: Logger("b".to_owned()),
              c: Logger("c".to_owned()),
          }
      }
  }

  fn main() {
      let foo = Foo::new();
  }
  ```
  ]

  ```
  Output:
  Foo
  a
  b
  c
  ```
]

#slide[
  Controlling drop order
]

#slide[
  + Disable drop-glue
  + Run destructors manually
]

#slide[
  `std::mem::ManuallyDrop`
]

#slide2flow[
  #set text(size: 6pt)
  ```rust
  use std::mem::ManuallyDrop;

  pub struct Logger(String);

  impl Drop for Logger {
      fn drop(&mut self) {
          println!("{}", self.0);
      }
  }

  struct Foo {
      a: ManuallyDrop<Logger>,
      b: ManuallyDrop<Logger>,
      c: ManuallyDrop<Logger>,
  }

  impl Drop for Foo {
      fn drop(&mut self) {
          unsafe {
              ManuallyDrop::drop(&mut self.a);
              ManuallyDrop::drop(&mut self.c);
              ManuallyDrop::drop(&mut self.b);
          }
      }
  }

  ```

  #colbreak()

  #block-with-offset(offset: 26)[
  ```rust
  impl Foo {
      fn new() -> Self {
          Self {
              a: ManuallyDrop::new(Logger("a".to_owned())),
              b: ManuallyDrop::new(Logger("b".to_owned())),
              c: ManuallyDrop::new(Logger("c".to_owned())),
          }
      }
  }

  fn main() {
      let foo = Foo::new();
  }
  ```
  ]

  ```
  Output:
  a
  c
  b
  ```
]

#slide[
  C++
]

#slide[
  With runtime overhead:

  - `std::optional`
  - `std::unique_ptr`
]

#slide[
  `union`
]

#slide2flow[
  #set text(size: 7pt)

  ```cpp
  #include <print>
  #include <string>

  class Logger {
    std::string m_message;

  public:
    Logger(const char *message)
        : m_message{message}
      {}
    ~Logger() { std::println("{}", m_message); }
  };

  class Foo {
    union { Logger a; };
    union { Logger b; };
    union { Logger c; };

  public:
    Foo() : a{"a"}, b{"b"}, c{"c"} {}
    ~Foo() {
      a.~Logger();
      c.~Logger();
      b.~Logger();
    }
  };

  ```

  #colbreak()

  #block-with-offset(offset: 27)[
  ```cpp
  int main() {
    Foo foo = Foo{};

    return 0;
  }
  ```
  ]

  ```
  Output:
  a
  c
  b
  ```
]

#slide[
  Summary
]

#slide(size: 12pt)[
  #table(
    columns: 3,
    stroke: white,
    table.header[][Rust][C++],
    [ initialization order ], [ unspecified ], [ In the order of declaration ],
    [ in-place initialization ], [ Manual. Open design space ], [ Yes. Placement new ],
    [ destruction order ], [ In the order of declaration ], [ In the _reverse_ order of declaration ],
    [ controlling destruction order ], [ `ManuallyDrop` ], [ `union` ],
    // [ ], [ ], [ ],
  )
]

#slide[
  #figure(
    image("qr-code.svg", width: 40%),
    caption: [
      #set text(size: 12pt)

      Public repository with slides
    ],
    supplement: none,
    numbering: none,
  )
]
