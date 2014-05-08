Octopress workflow with Docker
==============================

Want to try [Octopress](https://github.com/imathis/octopress) but don't feel like installing
all the dependencies on your machine? This repo provides you with instructions and workflow to
run it under Docker.

## Installation

First, fork this repo, as it's going to contain your site source code
(markdown), and clone it on your docker host:

    git clone git@github.com:USERNAME/docker-octopress
    cd docker-octopress

Now either download the ready-made Docker image (assuming I've pushed it and it's up-to-date):

    docker pull dergachev/octopress

Alternatively, build the image manually from the included Dockerfile:

    make docker-build

This workflow assumes you'll be deploying (pushing) the generated HTML into
`git@github.com:USERNAME`. If you're planning to deploy the generated HTML
into a repository on github, create one now.  Mine is
[http://dergachev.github.io/](http://dergachev.github.io), with the source at
[https://github.com/dergachev/dergachev.github.io](https://github.com/dergachev/dergachev.github.io).

Now clone the repository you will deploy the generated HTML to into
`./deploy_repo`:

    make deploy-repo

Then update the following settings inside `config/_config.yml`:

    url: http://dergachev.github.io
    title: Alex Dergachev's Blog
    subtitle: Buffalo buffalo Buffalo buffalo buffalo buffalo Buffalo buffalo
    author: Alex Dergachev
    simple_search: http://google.com/search
    description: Site description goes here.

Now, you're ready to use Octopress to build and deploy the HTML!

## Usage

First, create a new post inside `./posts`:

    make new_post

That will generate `posts/2014-05-07-your-post-title.markdown` and opens it in
VIM for you to edit.  Populate the markdown file with something like the
following:

    ---
    layout: post
    title: "Hello World!"
    date: 2014-05-07 21:14
    comments: true
    categories: docker
    ---

    Just getting started with Octopress, and of course I couldn't do anything
    without my two favorite files: a Dockerfile and a Makefile.

    ## Heading 2

    Some more text

    * List 1
    * List 2 with a link to [github.com/dergachev/docker-octopress](https://github.com/dergachev/docker-octopress/)

Once the new file is created inside `posts/`, you can generate the HTML website
inside `./public/` as follows:

    make generate 

That was a one-shot conversion. But during development, you'll want to have
Octopress automatically regenerate the HTML, and preview the results locally.
The following command automatically watches for changes to your source files,
re-runs `make generate`, and spins up a local webserver so that you can easily
preview the resulting HTML:

    make preview

While this is running, you can visit [http://localhost:4000](http://localhost:4000) to
see your site. If you're not running docker locally but in a VM, be sure to use your
docker VMs IP address instead of localhost, or setup port forwarding.

## Deploying to GitHub Pages

TODO: make generate

Once you're happy with the generated HTML, the following will commit and push it 
to the github pages repository you cloned in `./deploy_repo`:

    make deploy

Don't forget that if your repository was cloned using `git@github.com:USERNAME/USERNAME.github.io`, 
you'll need SSH agent to be running on your docker host.  Otherwise, you can
interactively type your github credentials each time you deploy, by using the
HTTPS form of the github URL: `https://github.com/USERNAME/USERNAME.github.io`.

Afterwards, your HTML will be hosted via GitHub Pages at
[http://USERNAME.github.io](http://USERNAME.github.io).

Note that GitHub Pages can take up to 10 minutes to start serving the HTML
after the push.

Don't forget that your source markdown still needs to be committed and pushed;
now's a great time to do this to avoid future data loss.

## Running other commands

Would you like to run other Octopress commands? 

See a list of available rake tasks defined by Octopress:

    make rake

Run an abritrary rake task:

    make rake-new_page   # runs 'rake new_page' inside docker

Something funky? Or want to do something custom that my Makefile doesn't support? 
Start a bash shell within the Docker container:

    make shell

Don't forget that a number of directories are shared from your docker host, so
be careful not to delete your uncommitted posts by accident.
