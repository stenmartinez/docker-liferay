# Liferay Portal Docker-Based Infrastructure

### Key Assumptions

- Understand Docker and Dockerfiles
- Know your Cloud Environment: Azure, AWS, Openshift
- These images use Debian; Dockerfiles need rewriting for Alpine or Redhat/rpm
- Use specific workspace configs for cloud/local cloud environments; the following config names are a suggestion

### How to use

1. Copy these files into your workspace as needed
1. Update file names, project names, and container repository names as needed
1. If you need to improve these, contribute back to this repository

### Build Elasticsearch docker image (for changes to base image)

```
docker image build --force-rm -t elasticsearch-6 -f elasticsearch-6.Dockerfile .
```
### Tagging images

An ideal pattern is to tag so that you increment build numbers and separate images according to purpose:

```
docker tag liferay-portal {REPOSITORY_URL}/liferay/liferay-portal:{TAG}
```
or
```
docker tag liferay-portal {REPOSITORY_URL}/elasticsearch/elasticsearch-6:{TAG}
```

### Build Liferay Portal image

For local developers:
1. Run ```./build.sh dev```
2. Start Docker services (if needed)
3. Run ```docker-compose up``` in the ```docker``` folder

For code deployment on ECS (note, this requires ECS CLI access):
1. Run ```./build.sh {ENV}``` in the root project, where {ENV} is your build environment (dev,prod,etc)
1. Check the new liferay base image: ``` docker images ```
1. Tag the new image according to the docker registry and build version  ```docker tag liferay-portal {ECS_REPOSITORY_URL}/liferay-portal:{TAG}``` where {ECS_REPOSITORY_URL} is the url to the ECS Container Repo you have configured and {TAG} is the version tag of the build
1. Run the ECS login(Find this in the ECS Repository Push Instructions).  For example, ```aws ecr --profile liferay-portal get-login --no-include-email --region us-west-2```.  What is returned is what you run to login.
1. Push it to ECS Docker Registry: ```docker push {ECS_REPOSITORY_URL}/liferay/liferay-portal:{TAG}```
1. Repeat Steps 3 and 4 for the elasticsearch image, tagging it as ```/base/elasticsearch-6```

To test the image locally, edit the env_variables file that define database and elasticsearch access, then: ```docker run --env-file env_variables liferay-portal```
