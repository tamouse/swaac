**WARNING: This is old and likely obsolete.**

TIL: Capybara.has~currentpath~ {#til-capybara.has_current_path keywords="testing, rails, capybara, wait time" published_date="2017-11-20T09:54"}
==============================

-   published~date~: 2017-11-20T09:54
-   keywords: testing, rails, capybara, wait time

I\'m an infrequent user of Capybara, preferring other means to test. But I reach for it when it\'s needed. That being said, I haven\'t been up to speed on all the features of more recent releases.

One thing that I\'d been used to in writing tests is explicitly putting in a `sleep` when the stack is switching pages in the middle of a test, and checking the `current_url` matches a given path.

Instead, as of version 2.5, there\'s a method called [ `has_current_path?` ](http://www.rubydoc.info/github/jnicklas/capybara/Capybara/SessionMatchers#has_current_path%253F-instance_method) (which evolves to `have_current_path` in RSpec matchers) that works with Capybara\'s wait time (i.e., the test waits until the current path satisifies the argument given) which gives a much cleaner test than inserting sleeps.

This:

``` {.ruby}
scenario "item is deleted when clicked" do
  modal.click_on("Delete This Item")
  sleep 2
  expect(page.current_url).to match(%r{/items$})
end
```

becomes:

``` {.ruby}
scenario "item is deleted when clicked" do
  modal.click_on("Delete This Item")
  expect(page).to have_current_path(%r{/items$})
end
```

(Note that `has_current_path?` will take either a string or a regexp.)

I was led to this from <https://stackoverflow.com/questions/33533512/test-page-redirection-with-capybara-rspec/33535004#33535004>
