Adding a file display list to a multi-file upload HTML control {#adding-a-file-display-list-to-a-multi-file-upload-html-control-1}
==============================================================

**WARNING: This is old and likely obsolete.**

-   published date: 2013-10-22 11:08
-   keywords: \[\"code\", \"display\", \"file-uploads\", \"javascript\", \"swaac\", \"user-experience\", \"user-feedback\", \"ux\"\]
-   source: <https://www.raymondcamden.com/2013/09/10/Adding-a-file-display-list-to-a-multifile-upload-HTML-control>

TL;DR: when you want to upload multiple files
---------------------------------------------

... add a `multiple` attribute to the `input type="file"` element.

### For example

``` {.web}
<input type="file" name="uploads" id="uploads" multiple />
```

### Funging the display

The post further disusses the usability hit with the lack of indication what files have been selected and how to fix it up with some CSS and JavaScript.
