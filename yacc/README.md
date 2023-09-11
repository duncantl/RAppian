# Parsing SAIL Code

Consider the sample.sail file.
How can we extract information from this code?

## Why?
Because we want to analyze the code to
+ identify
  + functions being called 
  + expression rules being inboked
  + interfaces being re-used
  + record types being referenced
  + constants being used
  + rule input values
  + layout functions and parameters in use.
+ find commented out code

## How

### Regular Expressions

We can the "low-brow" apprach of regular expressions to capture a lot of information.
See 
+ `findCalls()`
+ `getDomains()`
+ `getUUIDs()`
+ `mkUUIDMap()`

### Transforming to a known syntax

One approach to parsing SAIL code is to transform it to a pseudo R syntax and parse that and
then process the resulting language objects.


## Parser

The "correct" approach is to have a proper SAIL parser.
We can use lex/yacc, ANTLR, or a hand-written parser to do this.
