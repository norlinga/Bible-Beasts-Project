# A Better NextJS App Dockerfile

The Dockerfile is updated in a few ways.
Starting from the top, we use an Alpine image.
I tested Slim - they both with the image sizes as follows:

- Alpine: 671MB
- Slim: 1.27GB
- Full: 1.66GB

```dockerfile
# Start from the official Node.js LTS base image
FROM node:18-alpine as base

# Set the working directory to /app and install dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install
```

Standard Dockerfile stuff that Spruce already gave us follows here.
We then use the `base` image that we created and run the build.
This gives us a `[CACHED]` stage / layer that we won't have to rebuild in the future.
In the Docker output, this is shown in the last three lines of the included output:

```
[+] Building 23.8s (16/16) FINISHED                                    docker:default
 => [internal] load build definition from Dockerfile                             0.0s
 => => transferring dockerfile: 903B                                             0.0s
 => [internal] load .dockerignore                                                0.0s
 => => transferring context: 2B                                                  0.0s
 => [internal] load metadata for docker.io/library/node:18-alpine                0.0s
 => [base 1/4] FROM docker.io/library/node:18-alpine                             0.0s
 => [internal] load build context                                                0.5s
 => => transferring context: 1.63MB                                              0.4s
 => CACHED [base 2/4] WORKDIR /app                                               0.0s
 => CACHED [base 3/4] COPY package*.json ./                                      0.0s
 => CACHED [base 4/4] RUN npm install                                            0.0s
```

Having this cached layer saves build time, bandwidth, etc.

Next, we build the NextJS app in builder layer.
In the final build step, we then select the necessary directories and files from the build `builder` image, moving them into the `release` image.
Being selective about which files to carry over isn's so much about saving space - the excluded files are few and small in size.
We are intentional with our files so that we don't leak file unintentionally in an image.

```dockerfile
# build the app
FROM base AS builder
COPY . .
RUN npm run build

# create the 'release' image
FROM node:18-alpine AS release
WORKDIR /app
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
```

In this final step, I'm purposely leaving in some ideas under comment.
We should consider running apps in production using another user than `root`.
If Alpine is to be used for the container we would want to establish the shell to use and capture that in the `Makefile`.
For example if we want to use Bash scripts in the construction of the image, we'd need to Bash to the Alpine image.

```dockerfile
# node:18 or node:18-slim
# RUN useradd --user-group --create-home --shell /bin/bash app && \
#   chown -R app:app /app
# USER app

RUN addgroup -S app && adduser -S app -G app -h /home/app
RUN chown -R app:app /app
USER app

# Add the time to the build
# RUN date -u +"%Y-%m-%dT%H:%M:%SZ" > build-time.txt

# Expose port 3000 for the Next.js app to be accessible
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
```

I'd want to talk to Spruce to understand why he's capturing the build-time inside the image.
It's not clear to me why he's doing this, so I comment it out for now with the idea that we may uncomment it or we may help Spruce find a different solution to his problem.

The `Makefile` in the app root gives a few convenience scripts to Spruce so that he doesn't need to up-arrow to find previous commands in the CLI.
