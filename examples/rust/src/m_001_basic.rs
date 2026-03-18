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
