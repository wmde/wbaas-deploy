########################################################################################################################
exit
########################################################################################################################
# Things below here still needed in this sort of order for local dev k8s setup..

cd tf/
terraform init
terraform apply
# yes

cd ../helmfile
helmfile --environment local apply

cd ../mediawiki135
helmfile --environment local apply

cd ../platform-nginx
helmfile --environment local apply

cd ../platform-apps-ingress
helmfile apply

## register a user
# kubectl --context minikube-wbaas exec -it sql-mariadb-primary-0 -- /bin/bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD}'
# use apidb;
# update users set verified=true where id = 1;

## connecting to adminer
##
# host: sql-mariadb-secondary.default.svc.cluster.local

# create a wiki
# update the domain in wikis


