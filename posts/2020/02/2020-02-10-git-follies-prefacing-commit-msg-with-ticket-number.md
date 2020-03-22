---
title: "How To: Preface your git commit messages with the Jira ticket number"
date: 2020-02-10T08:57:37-0600
categories: ["git"]
tags: [git-follies, commit-message, jira, how-to]
published: true
---

This is something you can build into your project's git hooks, that will preface your commit messages with the Jira ticket number based on the branch name.

[WIP]

We want something that will pull the tracking ticket number from the branch, like so:

| branch name                     | message prefix |
|:-------------------------------:|:--------------:|
| `kick-1234-this-cool-feature`   | `[KICK-1234]`  |
| `bug/KICK-789-woops`            | `[KICK-789]`   |
| `feature/kick_2100_the_precept` | `[KICK-2100]`  |
| `777_sunset_life`               | `[777]`        |
|                                 |                |

Create a hook for `.git/hooks/prepare-commit-msg` with the following script:

``` shell
# Current branch name: "KICK-3586_revert_nullable_custom_field_creation"
$ git rev-parse --abbrev-ref HEAD | ruby -ne 'ticket = %r{^(?<proj>\w+)[-_ ](?<num>\d+)}.match($_).named_captures; puts "[#{ticket["proj"].upcase}-#{ticket["num"]}]" '
# => [KICK-3586]

```

Make sure the hook is executable.


When you make a commit, git will execute `.git/hooks/prepare-commit-msg .git/COMMIT_MESSAGE`

Adding the hook to a code repo.




Inspiration: https://medium.com/better-programming/how-to-automatically-add-the-ticket-number-in-git-commit-message-bda5426ded05
