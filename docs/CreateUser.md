
+ 10 requests
+ All are POSTS
+ All are JSON (vnd.appian.tv+json)
+ All have 4 elements
   + `#t`
   + updates
   + context
   + uuid
+ The uuid is the same for all requests
+ `#t` is UiConfig for all
+ context is a named (character) vector with elements 
   + `#t` - all Map
   + type   - all stateful
   + value - same value for all 
```
jA0EAwMCQvI3cA3lgVoB0rMBhGDkfzLj5PkUNFqG99Akd074bUw3Yfo1LuRSWFinTlRMFoKn9dA5\r\nGuxeQuxmo3JUe7Tjc/mh/abozkgqKaVna3UGJ7Y8/D+sDb7tMHeQ6VzRtVfd6U7wb/+B088zGF6G\r\nI+4lwxRkBGPktt7bYZnwVCBQ6ndcAolOdoy3fRhy3h2VIzyi/uJZXQpX1YLfIPIpDXhV8X1WzmOU\r\nNNL41JvWlkwW3habDrxmGmUil2usBgiIPw==\r\n`
```
+ updates
   + each has 2 elements 
   + `#t` - all SaveRequest?list
   + `#v` - each has 1 element, a list with 9 elements, one with 10.
     + _cId - first 4 are the same, the others are all different
     + model - 
     + value
     + saveInto
     + saveType
     + isAsyncRequest
     + provideRequestState
     + capabilities
     + scrollContext
     + the last one has an additional label element.

+ The first 4 requests are parts of the login name
   + n, nrd, nrdye, nrdyer
   + should be able to collapse this to 1? or do we need to generate state
+ The 5, 6, 7, 8 and 9th requests are the 
   + First name
   + last name
   + email
   + temporary password
   + temporary password repeated   
+ The final request has a value of ""
+ Seems like the saveInto is the same for the first 4 and then different for each of the others.

h = har("../../create_nrdyer.har")
r = h$log$entries
sapply(r, function(x) x$request$method)
sapply(r, function(x) x$request$postData$mimeType)
rbodies = lapply(r, function(x) if(!is.null(x$request$postData$text)) fromJSON(x$request$postData$text) else "")

sapply(rbodies, names)

sapply(rbodies, function(x) x$uuid)


sapply(rbodies, function(x) x$updates$"#v"[[1]]$value)

