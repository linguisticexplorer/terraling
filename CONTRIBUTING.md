# Contributing Guidelines

Welcome to the Terraling Project! We are open and welcome to all external contributions and changes. To begin contributing, you must first understand the branching pattern we adhere to.

# Getting Started

To start contributing, you must have the following already:

* Git
* Github Account
* Fork of the Repository

# Branching Pattern

There are only two branches we use. They are __sprint__ and __dev__. Each branch corresponds to different parts of the development process. The first - __sprint__ - is always deployable, and represents our production code. The second - __dev__ - represents the most bleeding-edge, feature-rich version. Feature pull requests must only be made against __dev__, and only bugfixes and patches may be pull requested against __sprint__.

## Sprint

The sprint branch always remains deployable. Merging changes to the sprint branch will have to go through strict review. Usually, the merges come from the dev branch, but often we will have to make patch changes in novel branches which are then merged into sprint.

## Dev

The dev branch is home of all developmental changes. This branch is the most dynamic, and will experience a large amount of changes as we work our way through chores and user stories. All feature pull requests must be made against this branch.

# Contributing

To contribute, you must first fork the repository. Once you've done that, select the branch you will be making changes on (usually dev). If the change you are making is not listed in our issues page or our project management page, please create one before starting any changes.

## Committing

Your commits should be small and informative. Try not to have commits with large changes across multiple files, but smaller changes with only relevant files. The commit message should be a rationale on the change.

## Tests

All your changes should go under rigorous testing. When you make a change, make sure that the change is tested, or if it was previously tested, make sure that it passes.

## Pull Request (Submitting Changes)

After you've completed your commits, and you have a passing tests, feel free to make a pull request. The pull request message should indicate what changes have taken place and what it is trying to solve and/or fix. The pull request will be subject to review before merging. Once merged, you are free to make more pull requests!