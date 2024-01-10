# A Useful Github Action

Spruce hasn't gotten around to adding any tests to the project yet, which is fine.
He does have a linter in the project that we'll use as part of our Actions / Workflows.

## Expectations Around Linting / Testing / etc.

Devs should be confirming that their work passes test suites and linters before pushing code or creating pull requests.
Nonetheless, I've become "aware" of plenty of errors from CI.
So we'll simulate a branch push / PR linting or testing error so we can add some workflow controls to the PR process.

## Building an Image

This is pretty straightforward.
It does touch on some topics that are worth expanding on, like around credential management.
For this exercise, I'm using secrets from within github itself.

Another issue is "how often" to run, and where?
As in, do we want every branch push to run our github actions?
Maybe, maybe not, depending on developer habits and whatnot.
I've set the actions to run in times that I think would matter - pushes to main and pull requests to main.

## Running The Linter

Actually deploying my tasks... I learned something about nextjs?
The `npm run build` runs the linter as well, which of course failed, which failed the build as well as the linter step.
This is an alias to `next build` - I wonder whether we'd want to suppress linter warnings in the build or whether this is behavior we'd want to keep.
Not sure about best practices here.

I'll leave the linter step in there as a means of demonstrating steps we might use when running tests, and controlling PRs when Actions find issues.

## Passing on Setting Status Checks in Github

Wanted to demonstrate blocking merge and other fun things (resolve conversations) as a PR / merge rule.
Realized I was going down a little bit of a rabbit hole and am leaving it alone.  :P