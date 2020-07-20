# AKS-Selector

This project helps to quickly select from multiple subscriptions your cluster and get the login credentials for AKS

## Requirements

The first thing you need, is `dialog`

I assume that you already have azure-cli installed.

### MacOS

```shell
brew install dialog
```

### Linux (Ubuntu)

```shell
sudo apt install dialog
```

## How to run

log in via azure cli

```shell
az login
```

then run 

```shell
./aks-select.sh
```