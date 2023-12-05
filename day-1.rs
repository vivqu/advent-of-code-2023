// use std::env;
use std::fs;

const VALID_DIGITS: [&str; 9] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

fn get_first_digit_from_word(line: &str, reverse: bool) -> Option<usize> {
    if line.len() == 0 {
        return None;
    }
    let mut first_digit: Option<usize> = None;
    let mut digit_index: Option<usize> = None;
    println!("Checking word: {}", line);
    for (word_index, &word) in VALID_DIGITS.iter().enumerate() {
        if let Some(index) = if reverse { line.rfind(word) } else { line.find(word) } {
            println!("Found {} at index {}", word, index);
            let found_digit = digit_index.is_none() || if reverse {
                index > digit_index.expect("Should have a first digit index")
            } else {
                index < digit_index.expect("Should have a first digit index")
            };
            if found_digit {
                first_digit = Some(word_index + 1);
                digit_index = Some(index);
            }
        }
    }
    first_digit
}

fn main() {
    println!("Reading calibration document...");
    
    // Read day-1-input file
    let file_path = "day-1-input.txt";
    println!("Reading file: {}", file_path);

    let contents = fs::read_to_string(file_path)
        .expect("Should have been able to read the file");

    let mut sum = 0;
    // Check each line for first and last digit in the sequence
    let lines = contents.lines();
    for line in lines {
        if line.len() == 0 {
            println!("Empty line, skipping...");
            continue;
        }
        println!("----- Checking line: {}", line);
        let mut first_digit: Option<usize> = None;
        let mut current_num = 0;
        for (index, c) in line.chars().enumerate() {
            if c.is_digit(10) {
                first_digit = Some(index);
                current_num = 10 * c.to_digit(10).expect("Should be a digit");
                break;
            }
        }
        if first_digit.is_none() {
            println!("Error: No digits found in line {}", line);
            continue;
        } else {
            // Check for an earlier "word" digit
            let earlier_digit = get_first_digit_from_word(
                &line[0..first_digit.expect("Should have a first digit index")],
                false
            );
            if earlier_digit.is_some() {
                println!("Found earlier digit: {}", earlier_digit.expect("Should have an earlier digit"));
                current_num = 10 * earlier_digit.expect("Should have an earlier digit") as u32;
            }
        }

        let mut last_digit: Option<usize> = None;
        for (index, c) in line.chars().rev().enumerate() {
            if index > line.len() - first_digit.expect("Should have a first digit index") {
                break;
            }
            if c.is_digit(10) {
                last_digit = Some(line.len() - index - 1);
                current_num += c.to_digit(10).expect("Should be a digit");
                break;
            }
        }
        if last_digit.is_none() {
            println!("Error - Only 1 digit found in line {}", line);
            continue;
        } else {
            println!("Last digit: {} out of {}", last_digit.expect("Should have a last digit"), line.len());
            let later_digit = get_first_digit_from_word(
                &line[(last_digit.expect("Should have a first digit index") + 1)..],
                true
            );
            if later_digit.is_some() {
                println!("Found later digit: {}", later_digit.expect("Should have an earlier digit"));
                current_num = current_num / 10 * 10;
                current_num += later_digit.expect("Should have an earlier digit") as u32;
            }
        }
        println!("... {} for {}", current_num, line);   
        sum += current_num;
    }

    // Parse each line? Find the first and last digits with two indices
    // I guess print error if the line is invalid
    println!("Sum of all numbers: {}", sum);
}

// fn main() {
//     println!("Reading calibration document...");
    
//     // Read day-1-input file
//     let file_path = "day-1-input.txt";
//     println!("Reading file: {}", file_path);

//     let contents = fs::read_to_string(file_path)
//         .expect("Should have been able to read the file");

//     let mut sum = 0;
//     // Check each line for first and last digit in the sequence
//     let lines = contents.lines();
//     for line in lines {
//         if line.len() == 0 {
//             println!("Empty line, skipping...");
//             continue;
//         }
//         let mut first_digit: Option<usize> = None;
//         let mut current_num = 0;
//         for (index, c) in line.chars().enumerate() {
//             if c.is_digit(10) {
//                 first_digit = Some(index);
//                 current_num = 10 * c.to_digit(10).expect("Should be a digit");
//                 break;
//             }
//         }
//         if first_digit.is_none() {
//             println!("Error: No digits found in line {}", line);
//             continue;
//         }
//         let mut last_digit: Option<usize> = None;
//         for (index, c) in line.chars().rev().enumerate() {
//             if index > line.len() - first_digit.expect("Should have a first digit index") {
//                 break;
//             }
//             if c.is_digit(10) {
//                 last_digit = Some(index);
//                 current_num += c.to_digit(10).expect("Should be a digit");
//                 break;
//             }
//         }
//         if last_digit.is_none() {
//             println!("Error - Only 1 digit found in line {}", line);
//             continue;
//         }
//         println!("{} for {}", current_num, line);   
//         sum += current_num;
//     }

//     // Parse each line? Find the first and last digits with two indices
//     // I guess print error if the line is invalid
//     println!("Sum of all numbers: {}", sum);
// }