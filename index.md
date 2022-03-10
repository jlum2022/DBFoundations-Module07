## Welcome to GitHub Pages

You can use the [editor on GitHub](https://github.com/jlum2022/DBFoundations-Module07/edit/gh-pages/index.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [Basic writing and formatting syntax](https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/jlum2022/DBFoundations-Module07/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.

Name:	Jocelyn Lum
Date:		March 1, 2022
Course:	IT FDN 130 A Wi 22: Foundations of Databases & SQL Programming
GitHub URL:	https://github.com/jlum2022/DBFoundations-Module07

Assignment 07 - Functions

Introduction

This module provided practice in using built-in SQL functions and developing SQL user-defined functions.

Explain when you would use a SQL UDF
A SQL UDF (User Defined Function) is a sequence of SQL statements designed to perform a task.   The benefits of creating a UDF include:
•	Reusability and readability – The task can be performed by calling the function as needed vs. replicating the same SQL code. This improves readability if the function names are meaningful.
•	Consistency – The task can be performed with the same SQL code every time.
•	Flexibility – The task can be performed for different types of input parameters and return output in the desired format.
Explain the differences between Scalar, Inline, and Multi-Statement Functions
Scalar functions return a single value.  For example, a function called fGetVacationHours() could return the number of vacation hours that an employee (specified by a function parameter) has available. 
Inline Table-Valued and Multi-Statement Table-Valued functions both return a table of data.   
An Inline Table-Valued function contains only a single SELECT statement that defines the columns and rows of the returned table.  For example, suppose we have a single SELECT statement which retrieves a list of employees and their accrued vacation hours.  We could use it as the body of an inline function fGetEmployeesWithVacationOverMax() which takes an input parameter @MaxVacationLimit; the function could return a result set of employees with accrued vacation over the @MaxVacationLimit.
A Multi-Statement Table-Valued function allows for more complexity and multiple SQL statements in generating the returned table.  The RETURNS clause defines a table variable which will be the returned table.  The SQL statements in the body of the function serve to populate the table variable.  
Summary

Module 07 included great resources for learning about different types of UDFs and the advantages and disadvantages of each.  This overview only scratches the surface of what can be done with SQL functions.  I look forward to applying this knowledge in the final project and in my work applications.

