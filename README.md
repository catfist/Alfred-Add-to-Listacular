Alfred-Add-to-Listacular
========================

![screenshot](http://cl.ly/YEEl/Image%202014-10-26%20at%2010.52.27%20%E5%8D%88%E5%BE%8C.png)

![Input example](http://cl.ly/YDlI/Monosnap_2014-10-26_23-32-31.jpg)

## About
This workflow add tasks to Todo.txt with Listacular due/remind format.

## Ugase
Alfred text format: `lc task,date,time`

Change `todotxt` path in 'Run Script' action to your Listacular syncing file.

### task:
All Todo.txt format (priority, context, project) and Listacular due format (`@due(yyyy-mm-dd hh:mm)`, `@remind(yyyy-mm-dd hh:mm)`) are allowed.

### date:
The following format is available. It can be omitted.

Today is suppose to be a 2014/05/05.

| input      | output     | note                                                                  |
| ---        | ---        | ---                                                                   |
| +0         | 2014-05-05 | `+n` become after n days                                              |
| +1         | 2014-05-06 |                                                                       |
| +365       | 2015-05-05 |                                                                       |
| 7          | 2014-05-07 | Specified date of this month                                          |
| 1          | 2014-06-01 | If complemented date is in the past, I will be in next month          |
| 7-10       | 2014-07-10 | Specified date of this year                                           |
| 1-10       | 2015-01-10 | If complemented date is in the past, I will be in next year           |
| 2014-01-01 | 2014-01-01 | If a complete date is entered,it's not compared with the current date |
| 2014-1-1   | 2014-01-01 |                                                                       |
| (none)     | 2014-05-01 | If 'time' is inputed                                                  |

### time:
The following format is available. It can be omitted.

| input  | output | note                 |
| ---    | ---    | ---                  |
| 910    | 09:10  |                      |
| 2230   | 22:30  |                      |
| 9      | 09:00  |                      |
| 20     | 20:00  |                      |
| (none) | 23:59  | If 'date' is inputed |


### Example
Today is suppose to be a 2014/1/1.

Items beginning from `- ` has a checkbox in Listacular.

If `@n` is inputed, it will be an item without a checkbox.

| input          | output                                |
| ---            | ---                                   |
| some task      | - some task                           |
| some task,+1   | - some task @due(2014-01-02 23:59)    |
| some task,,12  | - some task @remind(2014-01-01 12:00) |
| some task,22,8 | - some task @remind(2014-01-22 08:00) |
| some note @n   | some note                             |
| # header @n    | # header                              |

## Implementation plan
* "alter xx" time format
