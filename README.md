Alfred-Add-to-Listacular
========================

## About
This workflow add tasks to Todo.txt with Listacular due/remind format.



## Ugase
Alfred text format:
`txt task,date,time`

### task:
All Todo.txt format(priority,context,project) and Listacular format(@due(yyyy-mm-dd hh:mm),@remind(yyyy-mm-dd hh:mm)) are allowed.

### date:
Use `yyyy-mm-dd` or `+n` format. `+0` will be converted to today.
It can be omitted.

### time:
Use `hhmm` format.
It can be omitted.

### Example
If today is 2014-01-01,
`txt some task,+1,2100` -> - some task @remind(2014-01-02 21:00)
`txt some task,,2100` -> - some task @remind(2014-01-01 21:00)
`txt some task,+1` -> - some task @due(2014-01-02 23:59)
`txt some task` -> - some task
`txt some task @due(2014-01-01 21:00)` -> - some task @due(2014-01-01 `21:00)
`txt some notice @n` -> some notice
