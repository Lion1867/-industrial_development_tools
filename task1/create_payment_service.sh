#!/usr/bin/env bash
set -euo pipefail

mkdir -p payment-service/{config,data,logs,reports,backup}
printf '%s\n' \
  'SERVICE_NAME=payment-service' 'SERVICE_VERSION=1.0' 'CURRENCY=EUR' \
  'PAYMENT_PROVIDER=TEST' 'MAX_PAYMENT=5000' 'LOG_LEVEL=INFO' \
  > payment-service/config/payment.conf
cp payment-service/config/payment.conf payment-service/backup/payment.conf.bak
touch payment-service/data/transactions.txt payment-service/logs/payment.log
