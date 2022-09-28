## HashiCorp Vault KeyMgmt Expire date check

### Why

Keys created under keymgmt secret engines on Vault don't have any expire date.
So basically you can't manage lifecycle of these keys, unless you check
manually the data when the key has been created and delete/disable them after
X days.

### Workaround

This script check all keys under a $keymgmt_path and , for every key, print keys that are older than 12 months ago.
At the moment the script doesn't support multiple version of a single key. Work in progress...

### Usage:

```
# ./check_expire_date_vault.sh <token> <vault> <keymgmt_path>

Example:

# ./check_expire_date_vault.sh s.0wtcFizyrlEc https://vault.xxx.xxx.:8200 keymgmt
```

Please note that both `curl` and `jq` needs to be already installed in order to use this script.
