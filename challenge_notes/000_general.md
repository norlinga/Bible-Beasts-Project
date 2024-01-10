# Getting Started

Props to Spruce, this looks fun.
I wonder if these are DALL-E generated images?
The bear is intense.

After checking out / forking the repo, I looked in a few places to get a lay of the land.
The `Dockerfile`, the `README` of course, the `package.json`, `.gitignore`, etc.
The project is straightforward enough to get running by following the README:

```sh
% npm install
% npm run dev
```

There's no issues from the linter.
Note to self - check to see if the linter is actually linting.

## Dockerfile Plan of Attack

There are a couple obvious things with the Dockerfile that are worth exploring, including the lack of a build stage and the use of a **large** node container.
Adding a build stage (or stages) will help to ensure we only rebuild `package.json` when appropriate.
The `node:18-slim` or `node:18-alpine` containers will help us to get the final built image size under control... to some extent.
The base image sizes differ pretty dramatically:

```
% docker image ls | grep node
node                       18-slim     d3cce7487840   3 weeks ago     196MB
node                       18          638c4f90a264   3 weeks ago     1.09GB
node                       18-alpine   f3776b60850d   4 weeks ago     132MB
```

The base app image, prior to modification, is quite large for what it does:

```
beasty-test                latest      6cbeb34405be   6 seconds ago   1.66GB
```

A JS / node / next observation - some languages, like Ruby or Python can use build stages to discard build artifacts and therefore save on overall image size.
Not being super deep on NextJS image building, I'm thinking the big gains in image size reduction may come from a switch to something like Alpine, which has its own consequences.
Maybe something to explore if I have time later.

There's a number of other issues with the Dockerfile that we ought to also consider, such as provisioning a non-root app user, mindfully copying targeted files and directories into the built image, etc.

Outside of the Dockerfile itself... remembering all the proper CLI options for `docker` can be a hassle.
I'll add a `Makefile` to help guide Spruce and any other devs that join the project along a proper, happy path.

Docker-specific notes will be shared in a dockerfile.md file.

## Github Actions

Even while maintaining careful track of testing and linting in my own projects, CI has exposed issues that were masked by my local environment.
We'll include a linting step as a proxy for all those sorts of similar steps.

CI is also useful as a centralized place to run tasks that might not be well suited to running on individual user machines for whatever reason.

>> Thinking about things like license counts, user credential leakage, particularly expensive processes, as reasons you might not want to run all tasks locally

I will focus my effort here on building images, and provide some controls around the PR workflows.
In order to exercise those controls, I'm adding additional rules to `.eslintrc.json` to force some linting errors.

Github Actions-specific note are in the github_actions.md file.

