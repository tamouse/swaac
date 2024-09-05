---
date: 2024-09-05 10:00
categories: ["CLI"]
tags: ["rsync", "exclusions"]
Time-stamp: <2024-09-05 11:54:45 tamouse>



# Writing an exclusions file for rsync

To create an exclusions file for `rsync` that excludes several directories across multiple levels of your directory tree, you'll need to list each pattern you want to exclude in the file. The patterns should match the directories or files you want to exclude, and you can use relative paths or wildcards to specify patterns effectively.

## Steps to Create an Exclusions File

1. **Create the Exclusions File**:

   You can create an exclusions file (e.g., `rsync-exclude.txt`) using a text editor. Each line in this file should represent a pattern or directory to exclude.

   **Example of `rsync-exclude.txt`:**
   ```
   # Exclude directories at any level
   directory1/
   directory2/

   # Exclude specific subdirectories
   subdir1/
   subdir2/

   # Exclude all .log files in any directory
   *.log

   # Exclude all 'temp' directories
   temp/

   # Exclude a directory pattern in any subdirectory
   */cache/
   ```

   - **`directory1/` and `directory2/`**: Exclude directories named `directory1` and `directory2` at any level.
   - **`subdir1/` and `subdir2/`**: Exclude `subdir1` and `subdir2` at any level.
   - **`*.log`**: Exclude all `.log` files in any directory.
   - **`temp/`**: Exclude all directories named `temp`.
   - **`*/cache/`**: Exclude all directories named `cache` in any subdirectory.

2. **Use the Exclusions File with `rsync`**:

   When running the `rsync` command, use the `--exclude-from` option to specify your exclusions file:

   ```bash
   rsync -av --delete --exclude-from='/path/to/rsync-exclude.txt' /source/directory/ /destination/directory/
   ```

   - **`-a`**: Archive mode (preserves symbolic links, permissions, timestamps, etc.).
   - **`-v`**: Verbose mode (provides detailed output of what `rsync` is doing).
   - **`--delete`**: Deletes files in the destination that are not present in the source.
   - **`--exclude-from='/path/to/rsync-exclude.txt'`**: Specifies the file containing patterns to exclude.

## Writing Effective Patterns for `rsync`

- **Trailing Slash**: To exclude directories, include a trailing slash (e.g., `temp/`).
- **Wildcards**: Use `*` as a wildcard for any number of characters, `?` for a single character, and `**` for matching any directory level.
- **Relative Paths**: Patterns are relative to the source directory specified in the `rsync` command. Ensure your patterns match the layout and structure of your source directory.

## Example Exclusions for Specific Directories

If you have a source directory structure like:

```
/source/directory/
|-- dir1/
|   |-- subdirA/
|   `-- subdirB/
|-- dir2/
|   |-- subdirC/
|   `-- subdirD/
`-- logs/
    |-- error.log
    `-- access.log
```

And you want to exclude `subdirB` in any directory, `logs` directory, and all `.log` files, your `rsync-exclude.txt` would look like:

```plaintext
subdirB/
logs/
*.log
```

Using this file with `rsync` will exclude these directories and files from being synced to the destination.

By defining patterns clearly in your exclusions file, you can manage complex directory structures and exclusions efficiently with `rsync`.
