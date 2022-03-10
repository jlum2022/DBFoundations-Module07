**Name:**	Jocelyn Lum
**Date:**		March 1, 2022
**Course:**	IT FDN 130 A Wi 22: Foundations of Databases & SQL Programming
**GitHub URL:**	https://github.com/jlum2022/DBFoundations-Module07

# Assignment 07 - Functions

## **Introduction**

This module provided practice in using built-in SQL functions and developing SQL user-defined functions.

## **Explain when you would use a SQL UDF**

A SQL UDF (User Defined Function) is a sequence of SQL statements designed to perform a task.   The benefits of creating a UDF include:

- Reusability and readability – The task can be performed by calling the function as needed vs. replicating the same SQL code. This improves readability if the function names are meaningful.
- Consistency – The task can be performed with the same SQL code every time.
- Flexibility – The task can be performed for different types of input parameters and return output in the desired format.

## **Explain the differences between Scalar, Inline, and Multi-Statement Functions**

**Scalar functions** return a single value.  For example, a function called fGetVacationHours() could return the number of vacation hours that an employee (specified by a function parameter) has available. 

**Inline Table-Valued** and **Multi-Statement Table-Valued** functions both return a table of data.   

An **Inline Table-Valued** function contains only a single SELECT statement that defines the columns and rows of the returned table.  For example, suppose we have a single SELECT statement which retrieves a list of employees and their accrued vacation hours.  We could use it as the body of an inline function fGetEmployeesWithVacationOverMax() which takes an input parameter @MaxVacationLimit; the function could return a result set of employees with accrued vacation over the @MaxVacationLimit.

A **Multi-Statement Table-Valued** function allows for more complexity and multiple SQL statements in generating the returned table.  The RETURNS clause defines a table variable which will be the returned table.  The SQL statements in the body of the function serve to populate the table variable.  

## **Summary**

Module 07 included great resources for learning about different types of UDFs and the advantages and disadvantages of each.  This overview only scratches the surface of what can be done with SQL functions.  I look forward to applying this knowledge in the final project and in my work applications.

