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
