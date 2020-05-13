broken-links:nil c:nil creator:nil

**WARNING: This is old and likely obsolete.**

Remember:
---------

![prefer pluck to map](../../../images/prefer-pluck-to-map.jpg)

When extracting specific columns from an ActiveRecord::Collection, prefer `pluck(:field1, :field2, :field3)` to `map{|row| [row[:field], row[:field], row[:field]]}`. This more often comes up when you want just the `:id`, for example:

``` {.ruby}
@work_task_type = @account
        .task_types
        .where(name: "Work")
        .pluck(:id)

# vs

@work_task_type = @account
        .task_types
        .where(name: "Work")
        .map(&:id)

```
