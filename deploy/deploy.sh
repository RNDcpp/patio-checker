ECR_PREFIX=`cat .ecr-prefix`
ECR_REGION=`cat .ecr-region`
aws ecr get-login-password --region $ECR_REGION | docker login --username AWS --password-stdin $ECR_PREFIX
docker build -t "$ECR_PREFIX/patio-checker-app:latest" ./app
docker push "$ECR_PREFIX/patio-checker-app:latest" 
docker build -t "$ECR_PREFIX/natto-server:latest" ./mecab-grpc-server
docker push "$ECR_PREFIX/natto-server:latest"  