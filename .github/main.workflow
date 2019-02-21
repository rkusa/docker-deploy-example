workflow "Docker" {
  on = "push"
  resolves = ["Docker Deploy"]
}

action "Docker Build" {
  uses = "actions/docker/cli@master"
  args = "build -t docker-deploy-example ."
}

action "Branch: master" {
  uses = "actions/bin/filter@master"
  needs = ["Docker Build"]
  args = "branch master"
}

action "Docker Tag" {
  uses = "actions/docker/tag@master"
  needs = ["Branch: master"]
  args = "docker-deploy-example rkusa/docker-deploy-example"
}

action "Docker Login" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Tag"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Deploy" {
  uses = "actions/docker/cli@master"
  needs = ["Docker Login"]
  args = "deploy rkusa/docker-deploy-example"
}
