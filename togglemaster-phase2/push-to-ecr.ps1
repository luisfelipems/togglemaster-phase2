# ============================================================
# push-to-ecr.ps1
# Script para build e push de todos os servicos para o ECR
# ============================================================

# 1. Obter o Account ID automaticamente
Write-Host "Obtendo Account ID da AWS..." -ForegroundColor Cyan
$ACCOUNT_ID = aws sts get-caller-identity --query Account --output text
if (-not $ACCOUNT_ID) {
    Write-Host "ERRO: Nao foi possivel obter o Account ID. Verifique suas credenciais AWS." -ForegroundColor Red
    exit 1
}
Write-Host "Account ID: $ACCOUNT_ID" -ForegroundColor Green

# 2. Configuracoes
$REGION = "us-east-1"
$ECR_BASE = "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
$SERVICES = @("auth-service", "flag-service", "targeting-service", "evaluation-service", "analytics-service")

# 3. Login no ECR
Write-Host "`nFazendo login no ECR..." -ForegroundColor Cyan
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_BASE
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha no login do ECR." -ForegroundColor Red
    exit 1
}
Write-Host "Login no ECR realizado com sucesso!" -ForegroundColor Green

# 4. Build e Push de cada servico
foreach ($SERVICE in $SERVICES) {
    Write-Host "`n============================================" -ForegroundColor Yellow
    Write-Host "Processando: $SERVICE" -ForegroundColor Yellow
    Write-Host "============================================" -ForegroundColor Yellow

    # Build da imagem
    Write-Host "  [1/3] Build da imagem $SERVICE..." -ForegroundColor Cyan
    docker build -t "${SERVICE}:latest" "./$SERVICE"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRO: Falha no build de $SERVICE. Abortando." -ForegroundColor Red
        exit 1
    }

    # Tag da imagem
    Write-Host "  [2/3] Tag da imagem $SERVICE..." -ForegroundColor Cyan
    docker tag "${SERVICE}:latest" "$ECR_BASE/${SERVICE}:latest"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRO: Falha no tag de $SERVICE. Abortando." -ForegroundColor Red
        exit 1
    }

    # Push para o ECR
    Write-Host "  [3/3] Push de $SERVICE para o ECR..." -ForegroundColor Cyan
    docker push "$ECR_BASE/${SERVICE}:latest"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRO: Falha no push de $SERVICE." -ForegroundColor Red
        Write-Host "  Verifique se o repositorio '$SERVICE' existe no ECR." -ForegroundColor Red
        exit 1
    }

    Write-Host "  $SERVICE enviado com sucesso!" -ForegroundColor Green
}

# 5. Resumo final
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "Todos os servicos foram enviados ao ECR!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Imagens disponiveis em:" -ForegroundColor Cyan
foreach ($SERVICE in $SERVICES) {
    Write-Host "  $ECR_BASE/${SERVICE}:latest"
}
