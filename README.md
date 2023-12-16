# RAppian

This is a package for code analysis of an Appian application/package. 
We use the "Export App" functionality to get the XML for all of the objects.
This exported information includes all the relevant objects we see in the Appian Designer, with some
rare exceptions such as when an object is not included in the export of the values of a constant
that is marked environment-specific in Appian.

The Appian Designer allows us to get almost all of the data we explore via this package.
However, it is a different interface and exploration model, specifically, not programmatic.
Exploring them in R rather than the Appian Designer helps me to think more clearly, or at least differently.

It is convenient to have the information in R as
+ we can explore the objects programmatically,
+ asking different questions than in the designer, and
+ it is faster as the designer is somewhat slow to respond and also to click through multiple steps
  to get to a specific object and then connect to another object.


We can compare 

+ test and dev versions of the application
+ different snapshots as they evolve over time
+ find all the functions called in the sail code, both Appian functions and application-defined functions/rules,
+ catalog all the expression rules, constants and interfaces we might be able to reuse
+ find the connections between record types for all record types together.


In the future, we might add some tests that we can do here to identify potential issues with what we develop.



# Parsing SAIL Code

How can we programmatically analyze and extract information from SAIL code?

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
+ ...


## How to "parse" SAIL Code

### Regular Expressions

We can use the "low-brow" apprach of regular expressions to capture a lot of information.
See 
+ `findCalls()`
+ `getDomains()`
+ `getUUIDs()`
+ `mkUUIDMap()`


### Transforming to a known syntax

One approach to parsing SAIL code is to transform it to a pseudo R syntax and parse that and
then process the resulting language objects.
This is what we have done via the function `StoR()` (SAIL to R.)

This uses regular expressions to actually transform SAIL code 
into a form that is compatible with R syntax. Then we can use R's `parse()`
function and the meta-programming tools in [CodeAnalysis](https://github.com/duncantl/CodeAnalysis), 
[CodeDepends](https://github.com/duncantl/CodeDepends), and R's own codetools package.

For the current state of the Appian application I am working with, this parses
all SAIL code in the application.

## Parser

The "correct" approach is to have a proper SAIL parser.
We can use lex/yacc, ANTLR, or a hand-written parser to do this.
It would be nice to find the SAIL specification.




# Other Links

+ [Analysis of Appian objects](https://github.com/JFDI-Consulting/JFDIAppianSAILComplexityAnalyser)
