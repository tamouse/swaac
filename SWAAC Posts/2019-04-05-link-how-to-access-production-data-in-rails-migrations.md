\#+COMMENT -**- time-stamp-line-limit: 20; time-stamp-count: 2 -**-

**WARNING: This is old and likely obsolete.**

Link: [How to Access Production Data in Rails Migrations](https://www.gregnavis.com/articles/how-to-access-production-data-in-rails-migrations.html) [[rails]{.smallcaps}]{.tag tag-name="rails"} [[migrations]{.smallcaps}]{.tag tag-name="migrations"} [[data]{.smallcaps}]{.tag tag-name="data"} {#link-how-to-access-production-data-in-rails-migrations capture_date="[2019-04-05 Fri 00:35]" last_update="Time-stamp: <2020-03-23 05:10:24 tamara>"}
===================================================================================================================================================================================================================================================================================================

-   last update: Time-stamp: \<2020-03-23 05:10:24 tamara\>
-   keywords: rails, migrations, data
-   capture date: \[2019-04-05 Fri 00:35\]

This article represents standard practice when you have to access actual data in the database (i.e. production) when running a migration. The example they use of adding a slug is pretty straight-forward. Beware, though, when modifying a table that has a huge number of records as this will effectively lock out the table while the migration is running. If you do go this route, better to schedule the down time.

Of particular importance is to create the ActiveRecord models in the migration for the tables being modified. Do **not** use the actual models to avoid callbacks, validations, and the like.
