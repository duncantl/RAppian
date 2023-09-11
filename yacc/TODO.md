# Status

+ 7 of 399 don't parse
   + some of the 399 require tryCatch() to 
      + fix adjacent "" ""
	  + fix & starting new  lines
	  
+ Back to having 5 (was 7)
   + 109 136 217 264 380
      + (was 107 109 133 136 217 264 380)
   + 217 264  we haven't fixed.
      + 217 264 have a  `name: = call` in the SAIL code and the = is a problem in the R code
   + 109 haven't fixed
        + X  \\+ in a regular expression in the SAIL code causes problems in R's reading of the string.      
   + 136 380 - new
   + 136 & 180 new 
     + problem is   SAIL code of the `x!abc.[#"...` - note the . and [  
```
local!eligibility.[#"urn:appian:record-field:v1:91dd3ca1-89b3-42d9-b91d-ef023ed52594/5781beb8-4912-417e-82ba-a28f20d296fd"]
```
   
+ Previously 7 that we can't parse
   + √ 2 (99 131) have misplaced ` in the R code
```
   `ri!committeeMemberDetails`[`fv!index]`[`
```
      + With other changes (removing ""), these now work, but problem persists.
```
y = 'a!save(ri!committeeMemberDetails[fv!index][#"urn:appian:record-field:v1:f5e6320d-b81b-4372-b877-392149c7636f/747833ee-ec79-4571-9fba-ed9c9733bed2"],
            null)'
```
   + [broken again] 1  (107) in R code, call tostring(..., )    has no final argument. In SAIL code, it is "".  Removing ""
      + Line 59 of the SAIL code.
	  + Fixed in fixStringConcat() which uses a lookbehind and ahead to 
   + √ 1 (133) has a trailing , at the end of the SAIL code.
       + remove trailing material at start of StoR
       + optional space after misplaced trailing , 

# Issue 


+ `ri!committeeMemberDetails[fv!index][#"ur...."] 
    transformed erroneously to 
	`ri!committeeMemberDetails`[`fv!index]`[`urn:appian:record-field:v1:f5e6320d-b81b-4372-b877-392149c7636f/787584d6-f0aa-4e79-8aa4-791714e4e4ea`]
	+ note the tick in the fv!index doesn't end inside the ] but after it.
    + input[99]

+ 

+ = in the SAIL code `subject: = #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_47165"(` leads to = == `_a...(`.
     + input[ 217 264 ]
     + what is the = in the SAIL code.
	 + why are we putting the == not immediately after =, i.e., getting ==

+ `&` starting a new line - input[349]
  + do we have to remove the new lines at the start? What would that break?

+ √ input[72] - { ., . } should be list( ., .)
   + anything to do with the UUIDs? No

+ input[9]  line 196 mapping `label: "",`   to `label == ,`
  + losing the ""
  + √ should be = not == here.

+ √ Fix the == for x: val becoming x == val
  + moved changeOperators to earlier


+ The 10 inputs containing "Dear".



# Done

+ √ For UUIDs, put the # prefix ?
