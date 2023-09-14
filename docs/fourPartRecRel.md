# Case Study 1
Consider EFRM_SEC_OpenTasks

"#urn:appian:record-field:v1:f46db558-8af9-47a4-88a7-c759a0b3445f/35ef582f-262d-4961-8995-df4bafd6d66d/c72e883a-7d20-40c1-9286-87cf6cc69c72/fa8a4aeb-c944-4754-8dcd-c4b511c01584" 


This occurs in the XML for 
+ EFRM_SEC_OpenTasks 
+ EFRM_isUserValidForTaskReassignment 


e = strsplit(gsub(".*:", "", asyms[1631]), "/")[[1]]
```
[1] "f46db558-8af9-47a4-88a7-c759a0b3445f" "35ef582f-262d-4961-8995-df4bafd6d66d"
[3] "c72e883a-7d20-40c1-9286-87cf6cc69c72" "fa8a4aeb-c944-4754-8dcd-c4b511c01584"
```

The first element identifies the `EFRM Task Log` record type:
```
getName(paste0("recordType/", e[1], ".xml"))
a = recordTypeInfo(paste0("recordType/", e[1], ".xml"))
rr = recordTypeRelationships(paste0("recordType/", e[1], ".xml"))
```

The second element does not identify a field in the `Task Log` record type.
Instead, we look in the the record relationships (`rr`) and that identifies a relationship
```
rf = rr[ rr$uuid == e[2] , ]
```
```
                         sourceField                          targetField
4554903e-3f12-4e36-8dd0-2be23d36d082 b3b96eb8-996b-44bb-b614-34e3dc4badf7
                    targetRecordType        type
5ad7f584-ce54-41f6-a287-5fcf34d87702 MANY_TO_ONE
                                uuid
35ef582f-262d-4961-8995-df4bafd6d66d
```

The targetRecordType corresponds to `EFRM Request Details`
```
file = paste0("recordType/", rf$targetRecordType, ".xml")
getName(file)
b = recordTypeInfo(file)
brr = recordTypeRelationships(file)
f1 = b[b$uuid == rf$targetField, ]
```
```
  fieldName sourceFieldType isRecordId isCustomField                                 uuid
1 requestId         INTEGER       TRUE         FALSE b3b96eb8-996b-44bb-b614-34e3dc4badf7
```


The third element of the urn does not correspond to a field in `Request Details` (b, the record
type).
Again, we look at the record-relationships, i.e., `brr` and 
match 
```
j = which(e[3] == brr$uuid)
brr[j,]
```
```
                         sourceField
b3b96eb8-996b-44bb-b614-34e3dc4badf7
                         targetField
eab2282f-cf58-462c-aea6-6dbe7c445da8
                    targetRecordType        type
f874526a-c78e-4cb5-ac77-23bda1053b1c ONE_TO_MANY
                                uuid
c72e883a-7d20-40c1-9286-87cf6cc69c72
```

We get the record type - either from the file or from `map`
```
file3 = paste0("recordType/", brr[j, "targetRecordType"], ".xml")
getName(file3)
c = recordTypeInfo(file3)
k = which(brr[j, "targetField"] == c$uuid)
c$fieldName[k]
crr = recordTypeRelationships(file3)
```
So the record type is named `EFRM Student Details`
and the field is requestId.
We don't seem to need the record-type relationships here.


So what is the 4th element of the urn?
It is the field named programCode in `Student Details` which has a UUID of 
`f874526a-c78e-4cb5-ac77-23bda1053b1c`.




# Case Study 2

Consider the URN 
```
"#urn:appian:record-field:v1:f46db558-8af9-47a4-88a7-c759a0b3445f/35ef582f-262d-4961-8995-df4bafd6d66d/c72e883a-7d20-40c1-9286-87cf6cc69c72/7cb18828-e22b-4e6c-9a98-2315d1d4a397" 
```
which comes from EFRM_GRID_TasksForLoggedInUser.
We find this in the `map`
```
map[!is.na(map$name) & map$name == "EFRM_GRID_TasksForLoggedInUser", ]
```
```
                           name      type
 EFRM_GRID_TasksForLoggedInUser interface
                                          uuid
 _a-0000ea6a-ed23-8000-9bab-011c48011c48_43207
                                                        file
 ./content/_a-0000ea6a-ed23-8000-9bab-011c48011c48_43207.xml
                                    qname recordType
 interface!EFRM_GRID_TasksForLoggedInUser       NULL
```
(We need the `!is.na(map$name)` since these 3 and 4 part URNs mapped to NA for the `name`)


```
e = strsplit(gsub(".*:", "", asyms[9066]), "/")[[1]]
file1 = sprintf("recordType/%s.xml", e[1])
getName(file1)
rr1 = recordTypeRelationships(file1)
```
"EFRM Task Log"



f = rr1[rr1$uuid == e[2],]

                         sourceField                          targetField
4554903e-3f12-4e36-8dd0-2be23d36d082 b3b96eb8-996b-44bb-b614-34e3dc4badf7
                    targetRecordType        type
5ad7f584-ce54-41f6-a287-5fcf34d87702 MANY_TO_ONE
                                uuid
35ef582f-262d-4961-8995-df4bafd6d66d



w = f$targetRecordType == map$uuid
b = map$recordType[w][[1]]
map$name[w]
b$fieldName[b$uuid == f$targetField]

This tells us the record type is `EFRM Request Details` and the field name is `requestId`.

To resolve e[3], we get the record-type relations corresponding to b.

brr = recordTypeRelationships(map$file[w])
f2 = brr[ e[3] == brr$uuid, ]

f2$targetRecordType corresponds to `EFRM Student Details` and 
the targetField matches field 2 in `EFRM Student Details` and corresponds to requestId.

We now match e[4] to another field in `EFRM Student Details` to get `lastName`.

So the URN 
+ EFRM Task Log
+ EFRM Request Details.requestId
+ EFRM Student Details.requestId
+ EFRM Student Details.lastName



# General

```
+ f46db558-8af9-47a4-88a7-c759a0b3445f - initial recordType
+ 35ef582f-262d-4961-8995-df4bafd6d66d - uuid in a recordTypeRelationship that identifies the
                                       targetRecordType and field
+ c72e883a-7d20-40c1-9286-87cf6cc69c72 - compare uuid to recordTypeRelationships from
           targetRecordType in step 2, and resolve field.  Gives new targetRecordType and targetField
+ 7cb18828-e22b-4e6c-9a98-2315d1d4a397 - 

```
