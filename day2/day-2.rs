extern crate regex;

use std::fs;
use regex::Regex;

const RED_MAX_COUNT: i32 = 12;
const GREEN_MAX_COUNT: i32 = 13;
const BLUE_MAX_COUNT: i32 = 14;

fn main() {
    println!("Reading day 2 input...");
    
    // Read day-1-input file
    let file_path = "day-2-input.txt";
    println!("Reading file: {}", file_path);

    let contents = fs::read_to_string(file_path)
        .expect("Should have been able to read the file");

    println!("File contents: {}", contents);

    for line in contents.lines() {
        let segments = line.split(": ");
        println!("Line segments: {:?}", segments);
        // if segments.len() != 2 {
        //     println!("Error: Invalid line: {}", line);
        //     continue;
        // }

    }
}