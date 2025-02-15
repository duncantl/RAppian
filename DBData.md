If you want
+ a few records (especially 25 or fewer) from a table  use sql()
+ all or most of a table, use dbTable() and subset in R, if necessary
+ records from multiple (5 or more) tables (not via join), consider dbDump() to get all the tables
   + As the tables get bigger, this will be less efficient.


Getting all or most of a table via sql() invloves a separate HTTP request and parsing of the JSON
results for each set of 25 records in the results. 


+ `system.time({z = sql("SELECT * FROM EFRM_TASK_LOG", dbCookie(inst = "test"), verbose = TRUE)})`
   + 85.4 seconds without using a curl handle connected across the separate requests.
   + 79.4 seconds with a curl handle.
+ `system.time({z2 = dbTable("EFRM_TASK_LOG", inst = "test")})`
   + .987
+ `system.time({z3 = dbDump(inst = "test")})`
   + 4.24
+ `system.time({z5 = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355", dbCookie(inst = "test"))})`
   + .809


