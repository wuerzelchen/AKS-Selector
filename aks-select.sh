#!/bin/sh
export SELECTED_SUBSCRIPTION=""
export SELECTED_AKSCLUSTER=""

export AVAILABLE_AZURE_SUBSCRIPTONS=$(az account list --query '[].{Name:name,SubscriptionId:id}' -o tsv | awk '{ printf ("%s %s %s ",$1,$2,$2) }')
SUBSCRIPTION_COUNT=$("$AVAILABLE_AZURE_SUBSCRIPTONS" | wc -w)

SELECTED_SUBSCRIPTION=$(dialog --radiolist "Select Azure Subscription" 0 0 $SUBSCRIPTION_COUNT $AVAILABLE_AZURE_SUBSCRIPTONS --stdout)
[ -z $SELECTED_SUBSCRIPTION ] && exit 1

az account set -s $SELECTED_SUBSCRIPTION
echo "Selected subscription: " $SELECTED_SUBSCRIPTION

export AVAILABLE_AKS_CLUSTER=$(az aks list --query '[].name' -o tsv | awk '{ printf ("%s %s %s ",$1,"cluster",$1) }')
AKS_CLUSTER_COUNT=$("$AVAILABLE_AKS_CLUSTER" | wc -w)

echo "setting dialog"
export SELECTED_AKS_CLUSTER_NAME=$(dialog --radiolist "Select AKS Cluster" 0 0 $AKS_CLUSTER_COUNT $AVAILABLE_AKS_CLUSTER --stdout)
[ -z $SELECTED_AKS_CLUSTER_NAME ] && exit 1
echo "Selected aks cluster: " $SELECTED_AKS_CLUSTER_NAME

az aks list --query "[?name=='$SELECTED_AKS_CLUSTER_NAME'].{ResourceGroup:resourceGroup}" -o tsv
SELECTED_AKS_CLUSTER_RESOURCE_GROUP=$(az aks list --query "[?name=='$SELECTED_AKS_CLUSTER_NAME'].{ResourceGroup:resourceGroup}" -o tsv)
echo $SELECTED_AKS_CLUSTER_RESOURCE_GROUP

dialog --yesno "Get Admin Credentials?" 0 0
ADMIN=$?
echo $ADMIN
echo "Getting Cluster: " $SELECTED_AKS_CLUSTER_NAME " from RG: " $SELECTED_AKS_CLUSTER_RESOURCE_GROUP
[ $ADMIN -eq 0 ] && az aks get-credentials --admin -n $SELECTED_AKS_CLUSTER_NAME -g $SELECTED_AKS_CLUSTER_RESOURCE_GROUP || az aks get-credentials -n $SELECTED_AKS_CLUSTER_NAME -g $SELECTED_AKS_CLUSTER_RESOURCE_GROUP
