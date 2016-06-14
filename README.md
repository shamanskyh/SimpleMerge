SimpleMerge
===========

Super simple mail merging for macOS using CSV and Mac's Mail.app. [Download the binary here.](https://sourceforge.net/projects/simplemerge-mail/files/latest/download)

Start by creating a CSV file with one header row and no header columns. Excel or Numbers are both capable of exporting to CSV.

Load the CSV file in SimpleMerge then fill out the template email. Use the header value enclosed in percent signs wherever you want to use a value from the CSV file.

For example, if your table looks like this...
<pre><code>| firstName      | lastName | emailAddress            | title          |
|----------------|----------|-------------------------|----------------|
| Michael        | Bluth    | michael@bluth.com       | President      |
| George Michael | Bluth    | georgemichael@bluth.com | Mister Manager |
| Ann            | Veal     | ann.veal@gmail.com      | Egg            |
</code></pre>

...then use <code>%emailAddress%</code> in the "To:" Field. Your template message might start with <code>Dear %firstName%</code>.
