Octopress workflow with Docker
==============================

Run [Octopress](https://github.com/imathis/octopress) via Docker.

## Installation

First, fork this repo. It's going to contain your site source code (markdown).
Then clone it (replacing **dergachev** with your github username):

    git clone git@github.com:dergachev/docker-octopress

Now either download the ready-made Docker image:

    docker pull dergachev/octopress

Alternatively, build the image manually from the included Dockerfile:

    make docker-build

Now clone the repository you will deploy the generated HTML to into `./deploy_repo`:

    make deploy_repo

Then maybe edit `./config/_config.yml` unless you want your site called "Alex Dergachev's Blog"

## Usage

Create a new post:

    make new_post

Generate HTML site (from `./posts` into `./public`):

   make generate 

Automatically regenerate site as you edit files in `./posts`, and serve on
[http://localhost:4000](http://localhost:4000):

    make preview

Commit and push the HTML into your github deploy repo:

    make deploy

See a list of available rake tasks defined by Octopress:

    make rake

Run an abritrary rake task:

    make rake-new_page   # runs 'rake new_page' inside docker
    
## Debugging

Something funky? Or want to do something custom that my Makefile doesn't support? 
Start a bash shell within docker:

    make shell

Don't forget that all the directories are mounted, so don't delete anything by
accident. 
