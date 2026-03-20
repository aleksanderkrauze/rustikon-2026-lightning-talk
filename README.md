# Manual (de)initialization: A Rust and C++ showcase

Slides for Rustikon 2026 lightning talk.

[Presentation](slides.pdf)

## Selected sources

- [Rust Reference section on Destructors](https://doc.rust-lang.org/reference/destructors.html)
- [The Rustonomicon section on Drop check](https://doc.rust-lang.org/nomicon/dropck.html)
- [Rust Project Goal - In-place initialization](https://rust-lang.github.io/rust-project-goals/2025h2/in-place-initialization.html)
- [`pin-init` crate](https://docs.rs/pin-init/latest/pin_init/) used by Rust for Linux project
- [C++ documentation on destructors](https://en.cppreference.com/w/cpp/language/destructor.html)
- [C++ documentation on placement new](https://en.cppreference.com/w/cpp/language/new.html#Placement_new)
- [Ralf Jung's post on uninitialized memory](https://www.ralfj.de/blog/2019/07/14/uninit.html)
- [Rust RFC-1857 stabilizing drop order](https://rust-lang.github.io/rfcs/1857-stabilize-drop-order.html)
