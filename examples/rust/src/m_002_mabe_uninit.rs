use std::mem::MaybeUninit;
use std::ptr;

pub struct Foo {
    name: String,
    data: Vec<i32>,
    len: usize,
}

impl Foo {
    pub fn new_in<'storage>(this: &mut MaybeUninit<Self>, name: &str) -> &'storage mut Self {
        let this = this.as_mut_ptr();

        let name = name.to_owned();
        let data = Vec::new();
        let len = name.len();

        unsafe {
            ptr::write(&raw mut (*this).name, name);
            ptr::write(&raw mut (*this).data, data);
            ptr::write(&raw mut (*this).len, len);
        }

        unsafe { &mut *this }
    }
}

fn use_foo(_foo: &Foo) {}

fn main() {
    let mut storage = MaybeUninit::uninit();

    let foo = Foo::new_in(&mut storage, "Rustikon");
    use_foo(&*foo);

    unsafe {
        storage.assume_init_drop();
    }
}
