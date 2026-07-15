# Primeiro, faça login no ECR
aws ecr get-login-password --region sa-east-1 | docker login --username AWS --
password-stdin YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com

# Encontre seu Account ID com:
aws sts get-caller-identity --query Account --output text

# Construa e faça push de cada serviço
cd auth-service
docker build -t auth-service:latest .
docker tag auth-service:latest YOUR_ACCOUNT_ID.dkr.ecr.sa-east1.amazonaws.com/auth-service:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com/auth-service:latest
cd ..
# Repita para os outros 4 serviços (flag-service, targeting-service, evaluationservice, analytics-service)
cd flag-service
docker build -t flag-service:latest .
docker tag flag-service:latest YOUR_ACCOUNT_ID.dkr.ecr.sa-east1.amazonaws.com/flag-service:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com/flag-service:latest
cd ..
# Repita para os outros 4 serviços (flag-service, targeting-service, evaluationservice, analytics-service)
cd targeting-service
docker build -t targeting-service:latest .
docker tag targeting-service:latest YOUR_ACCOUNT_ID.dkr.ecr.sa-east1.amazonaws.com/targeting-service:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com/targeting-service:latest
cd ..
# Repita para os outros 4 serviços (flag-service, targeting-service, evaluationservice, analytics-service)
cd evaluationservice-service
docker build -t evaluationservice-service:latest .
docker tag evaluationservice-service:latest YOUR_ACCOUNT_ID.dkr.ecr.sa-east1.amazonaws.com/evaluationservice-service:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com/evaluationservice-service:latest
cd ..
# Repita para os outros 4 serviços (flag-service, targeting-service, evaluationservice, analytics-service)
cd analytics-service
docker build -t analytics-service:latest .
docker tag analytics-service:latest YOUR_ACCOUNT_ID.dkr.ecr.sa-east1.amazonaws.com/analytics-service:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.sa-east-1.amazonaws.com/analytics-service:latest
cd ..