broken-links:nil c:nil creator:nil

**WARNING: This is old and likely obsolete.**

[Rails Guides: ActiveJob Supported Argument Types](https://edgeguides.rubyonrails.org/active_job_basics.html#supported-types-for-arguments)
===========================================================================================================================================

This came up because of a cascade of things:

1.  Having an exception thrown during an ActiveJob task
2.  The rescue calling ActiveMailer with the rescued exception as an argument, with the `.deliver_later` option
3.  This caused another ActiveJob to be created for the mailer, with an argument that violates the above restriction.

The solution, in this case is pretty easy: call the mailer with `.deliver_now` instead, since it\'s already a background job.
