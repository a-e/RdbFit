RdbFit
====

RdbFit is a [RubySlim](https://github.com/unclebob/rubyslim) database testing fixture for [FitNesse](http://fitnesse.org/).  It is written to work along the lines of [DbFit](http://www.fitnesse.info/dbfit), but it is not drop-in compatible, and it supports only queries.

Prerequisites
-------------
RdbFit requires the following:

* FitNesse
* RubySlim
* The Ruby DBI gem
* Ruby DBI drivers for your database of choice

Installation
------------
Place the rdb_fit directory into the FitNesse root directory.  (Not FitNesseRoot, but its parent.  From FitNesseRoot, the file ../rdb_fit/rdbfit.rb should exist.)

Be sure to include the following on a SetUp page above all your tests using RdbFit:

!| import    |
| RdbFit     |

Usage
-----
RdbFit supports the following table types:

* [Query Table](http://fitnesse.org/FitNesse.UserGuide.SliM.QueryTable)
* [Subset Query Table](http://fitnesse.org/FitNesse.UserGuide.SliM.SubsetQueryTable)
* [Ordered Query Table](http://fitnesse.org/FitNesse.UserGuide.SliM.OrderedQueryTable)
* [Decision Table](http://fitnesse.org/FitNesse.UserGuide.SliM.DecisionTable)

There are two ways to initialize a table.  Note the lower-case 'f's.
* | [tabletype:]Rdbfit | [database address][:port] | username | password | database | query [| database_type] |
  The database type is optional if a recognized port is provided.
* | [tabletype:]Rdbfit | database:connection:string | query |
  Where "database:connection:string" is a Ruby DBI connection string minus the DBI: part.

Usage of query tables from this point should be obvious.  Decision Tables act like Ordered Query Tables, except that you have to provide a "?" at the end of every column.  You can also [read symbols](http://fitnesse.org/FitNesse.UserGuide.SliM.SymbolsInTables) from Decision Tables, which you cannot do from query tables.

Copyright
---------

The MIT License

Copyright (c) 2011 Automation Excellence

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

