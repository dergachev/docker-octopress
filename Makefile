docker-build:
	docker build -t wujtruj/octopress .

docker-run:
	docker run -name=octopress -d -v `pwd`/posts:/srv/octopress-master/source/_posts -v `pwd`/config:/srv/octopress-master/config -p 4000:4000 wujtruj/octopress

docker-kill:
	docker stop octopress
	docker rm octopress
