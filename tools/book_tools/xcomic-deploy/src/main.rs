use std::fs;
use std::io;

const WORK_FOLDER: &str = "F:\\books";
const DEPLOY_FOLDER: &str = "G:\\ebook\\xbook\\comic";

fn main() {
    for path in fs::read_dir(WORK_FOLDER).unwrap() {
        println!("{}", path.unwrap().path().display().to_string());
    }
}
