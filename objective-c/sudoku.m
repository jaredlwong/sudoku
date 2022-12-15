#import <Foundation/Foundation.h>

// This is the interface block for the Sudoku class
@interface Sudoku : NSObject

// This is the correct way to declare a method in an interface block
// - (NSArray *)stringToPuzzle:(NSString *)input;

@end

@implementation Sudoku

- (NSMutableArray *)stringToPuzzle:(NSString *)input {
    NSMutableArray *puzzle = [[NSMutableArray alloc] init];
    for (int i=0; i < [input length]; i++) {
        NSString* character = [input substringWithRange:NSMakeRange(i, 1)];
        if (![character isEqualToString:@"."]) {
            [puzzle addObject:@([character intValue])];
        } else {
            [puzzle addObject:@(0)];
        }
    }
    return puzzle;
}

- (NSString *)puzzleToString:(NSArray *)puzzle {
    NSMutableArray *s = [NSMutableArray array];
    for (NSNumber *e in puzzle) {
        if (![e isEqualToNumber:@0]) {
            [s addObject:[e stringValue]];
        } else {
            [s addObject:@"."];
        }
    }
    return [s componentsJoinedByString:@""];
}

- (BOOL)isValidRow:(NSArray *)row {
    NSMutableArray *checkset = [NSMutableArray arrayWithArray:@[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0]];
    for (NSNumber *e in row) {
        checkset[[e intValue]] = @([checkset[[e intValue]] intValue] + 1);
    }
    for (int i = 1; i < checkset.count; i++) {
        if ([checkset[i] intValue] > 1) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) isValid:(NSArray *)grid {
    for (int r = 0; r < 9; r++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:9];
        for (int c = 0; c < 9; c++) {
            [row addObject:grid[r*9+c]];
        }
        if (![self isValidRow:row]) {
            return NO;
        }
    }
    for (int c = 0; c < 9; c++) {
        NSMutableArray *col = [NSMutableArray arrayWithCapacity:9];
        for (int r = 0; r < 9; r++) {
            [col addObject:grid[r*9+c]];
        }
        if (![self isValidRow:col]) {
            return NO;
        }
    }
    for (int i = 0; i < 9; i++) {
        int box_row = i / 3;
        int box_col = i % 3;
        NSMutableArray *box = [NSMutableArray arrayWithCapacity:9];
        int k = 0;
        for (int r = box_row * 3; r < box_row * 3 + 3; r++) {
            for (int c = box_col * 3; c < box_col * 3 + 3; c++) {
                [box addObject:grid[r*9+c]];
                k++;
            }
        }
        if (![self isValidRow:box]) {
            return NO;
        }
    }
    return YES;
}

- (int)nextOpen:(NSArray *)grid {
    for (int i = 0; i < 81; i++) {
        if ([[grid objectAtIndex:i] intValue] == 0) {
            return i;
        }
    }
    return -1;
}

- (BOOL)solve:(NSMutableArray *)grid {
    if (![self isValid:grid]) {
        return NO;
    }
    int p = [self nextOpen:grid];
    if (p < 0) {
        return YES;
    }
    for (int v = 1; v <= 9; v++) {
        grid[p] = [NSNumber numberWithInt:v];
        if ([self solve:grid]) {
            return YES;
        }
        grid[p] = [NSNumber numberWithInt:0];
    }
    return NO;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"Please provide a filename as an argument.");
            return 1;
        }

        NSString *filename = [NSString stringWithUTF8String:argv[1]];
        NSError *error = nil;

        NSString *fileContents = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error reading file: %@", error.localizedDescription);
            return 1;
        }

        Sudoku *sudoku = [[Sudoku alloc] init];

        NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
        for (int i = 0; i < lines.count; i += 2) {
            NSString *input = lines[i];
            NSString *expected = lines[i+1];
            NSMutableArray *s = [sudoku stringToPuzzle:input];
            NSDate *start = [NSDate date];
            [sudoku solve:s];
            NSDate *end = [NSDate date];
            if ([[sudoku puzzleToString:s] isEqualToString:expected]) {
                NSLog(@"Solved sudoku %@ in %f ms", input, [end timeIntervalSinceDate:start] * 1000);
            } else {
                NSLog(@"Failed to solve sudoku %@. Expected %@, got %@", input, expected, [sudoku puzzleToString:s]);
                exit(1);
            }
        }
    }
    return 0;
}
