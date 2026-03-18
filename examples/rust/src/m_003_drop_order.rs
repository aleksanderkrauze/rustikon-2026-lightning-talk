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
