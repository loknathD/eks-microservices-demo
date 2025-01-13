These scripts are used by the Jenkins pipeline to automate the build and deployment process. The build.sh script handles Docker image creation and pushing to the registry, while deploy.sh manages the deployment to your EKS cluster.

to use these scripts from jenkins pipeline

# For building
./jenkins/scripts/build.sh python-service ${BUILD_NUMBER} your-registry

# For deploying
./jenkins/scripts/deploy.sh eks-microservices-demo us-west-2 python-service ${BUILD_NUMBER}