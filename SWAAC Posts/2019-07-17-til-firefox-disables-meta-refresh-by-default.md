broken-links:nil c:nil creator:nil

**WARNING: This is old and likely obsolete.**

TIL: Firefox disables the meta refresh header by default
--------------------------------------------------------

This came up with a story I was implementing, where we wanted an interstitial page to show up after a new client signs up for our product, basically a \"Thank You\" page, which is needed for tracking stuff in google analytics.

I thought to use the `meta http-equiv=refresh` header, which I\'ve used for a very long time. Come to learn, however, the the Firefox browser disables this header by default.

See <https://stackoverflow.com/questions/29645340/why-does-meta-refresh-not-work-in-firefox>

Because we don\'t want to force users to update their browser configurations before signing up for an account, I used the JavaScript redirect method instead.

I really hope browser writers don\'t decide that method is too risky for browser users; it would mean a lot of client apps might no longer work all of a sudden.

This is why we can\'t have nice things :(
