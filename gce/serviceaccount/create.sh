#!/usr/bin/env bash

SERVICE_ACCOUNT_NAME=$1
NAMESPACE=$2

cd serviceaccount || exit 1

mkdir -p output

if [ -z "$NAMESPACE" ]; then
    NAMESPACE=default
fi

if [ -z "$SERVICE_ACCOUNT_NAME" ]; then
    echo "SERVICE_ACCOUNT_NAME is not set!"
    exit 1
fi

PROJECT_ID=$(gcloud config get-value core/project)

if [ -z "$PROJECT_ID" ]; then
    echo "PROJECT_ID is not set!"
    exit 1
fi

SECRET_NAME="secret-$SERVICE_ACCOUNT_NAME"
OUTPUT_KEY_FILE=./output/"$SERVICE_ACCOUNT_NAME"-key.json
OUTPUT_SECRET_FILE=./"$SECRET_NAME".yaml

if [ -f "$OUTPUT_KEY_FILE" ]; then
    echo "Output key file $OUTPUT_KEY_FILE already exists exiting."
    exit 1
fi

if [ -f "$OUTPUT_SECRET_FILE" ]; then
    echo "Output file $OUTPUT_SECRET_FILE already exists exiting."
    exit 1
fi

echo "Creating service account $SERVICE_ACCOUNT_NAME"

## create service account
gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" --display-name="Service Account"

## get a new key to the service account
gcloud iam service-accounts keys create "$OUTPUT_KEY_FILE" --iam-account "$SERVICE_ACCOUNT_NAME"@"$PROJECT_ID".iam.gserviceaccount.com 

## cert-manager for clouddns-dns01-solver-svc-acct
## make the key on disk a k8s secret
kubectl create secret generic "$SECRET_NAME" --namespace="$NAMESPACE" --from-file=key.json="$OUTPUT_KEY_FILE" --dry-run=client --output=yaml > "$OUTPUT_SECRET_FILE"