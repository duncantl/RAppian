+ For UUIDs, put the # prefix ?

+ `ri!committeeMemberDetails[fv!index][#"ur...."] 
    transformed erroneously to 
	`ri!committeeMemberDetails`[`fv!index]`[`urn:appian:record-field:v1:f5e6320d-b81b-4372-b877-392149c7636f/787584d6-f0aa-4e79-8aa4-791714e4e4ea`]
	+ note the tick in the fv!index doesn't end inside the ] but after it.
    + input[99]

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
