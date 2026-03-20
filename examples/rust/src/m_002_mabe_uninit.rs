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
        name: &str,
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

fn use_foo(_foo: &Foo) {}

fn main() {
    let mut storage = MaybeUninit::uninit();

    let foo = Foo::new_in(&mut storage, "Rustikon");
    use_foo(&*foo);

    unsafe {
        storage.assume_init_drop();
    }
}
