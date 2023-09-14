From funs.R
```
n = sapply(strsplit(asyms, "/"), length)
```

In EFRM_GRID_COMMON_ActionHistory  (element # 321) 
we have the following reference to a record type
```
#urn:appian:record-field:v1:45f955b0-a7d5-4cd7-8e21-c9e3fd6a30ae/9c79e2a7-7e70-4c4d-8a30-f33f0e29b315/2b8d6fff-b98b-409f-b05c-42940899691a"
```
on line 52.

The elements are 
```
ue = c("45f955b0-a7d5-4cd7-8e21-c9e3fd6a30ae", "9c79e2a7-7e70-4c4d-8a30-f33f0e29b315", 
"2b8d6fff-b98b-409f-b05c-42940899691a")
```

Using the map from `mkSummary()`, we lookup the recordTypeInfo for the first element
```
map$name[[which(ue[1] == map$uuid)]]
a = map$recordType[[which(ue[1] == map$uuid)]]
```
So this is the `EFRM Event Log` record type.

Then we match the second element of the urn to the uuid values of `a`
```
ue[2] == a$uuid
```
However, it does not correspond to any field.

So no we look at the record-relationships in the record type for `EFRM Event Log`, i.e., `ue[1]` our
first component of the URN:
```
rr = recordTypeRelationships(map$file[[ which(ue[1] == map$uuid) ]])
```
Now we compare the 2nd element of the urn to these uuids
```
j = which(ue[2] == rr$uuid)
```
We do get a match, for row 2 of rr.
The full row is
```
rrj = rr[j,]
```
```
                         sourceField
a91c7bb7-40e5-4cd7-ad42-1f11a0c4b209
                         targetField
c74b99c8-cd72-4cc6-8ba2-d854c996be69
                    targetRecordType        type
71f69d76-c0bb-4145-8c8b-0b578629fa5b MANY_TO_ONE
                                uuid
9c79e2a7-7e70-4c4d-8a30-f33f0e29b315
```
and we see the targetRecordType and targetField.

Before we go to the target record and field, 
we use the sourceField to identify the field in `EFRM Event Log`
that is being associated with the target.
```
a[rrj$sourceField == a$uuid, ]
```
```
  fieldName sourceFieldType isRecordId isCustomField                                 uuid
4    noteId         INTEGER      FALSE         FALSE a91c7bb7-40e5-4cd7-ad42-1f11a0c4b209
```


The target record type name is `EFRM Notes`:
```
map$name[[ match(rrj$targetRecordType , map$uuid) ]]
```
We get the record type with
```
b = map$recordType[[ match(rrj$targetRecordType , map$uuid) ]]
```

Next we match the targetField
```
k = match(rrj$targetField, b$uuid)
```
This gives
```
f = b[k,]
```
```
  fieldName sourceFieldType isRecordId isCustomField                                 uuid
1    noteId         INTEGER       TRUE         FALSE c74b99c8-cd72-4cc6-8ba2-d854c996be69
```

So this is `noteId` in `EFRM Notes`.

So the relationship so far (for the two elements is)
`Event Log.noteId` to `Notes.noteId`

What about the third component?

The third UUID in the relationship corresponds to the `note` field in `Notes`
```
which(ue[3] == b$uuid)
```

So the 3-part relationship  appears to connecting
`Event Log` to the `note` field in `Notes` by matching `noteId` in `Event Log` to 
the `noteId` in `Notes` and the corresponding `note` field in that "row"/tuple.




