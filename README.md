# kind-flux-demo

Testrepo for kubernetes related stuff.

generate sops-age secret
<https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age>

## generate new deploy key

create ssh key pair

```shell
ssh-keygen -o -a 100 -t ed25519 -f keygen -C "flux@kind-flux-demo"
```

create sops file and encode data in base64

```yaml
# yamllint disable
apiVersion: v1
kind: Secret
metadata:
    name: github-deploy-key
    namespace: flux-system
data:
  identity: ""
  identity.pub: ""
  known_hosts: ""
```

```shell
sops -e -i kubernetes/flux/config/github-deploy-key.sops.yaml
```

## generate new age key

create new age key

```shell
age-keygen -o age.agekey
```

create sops file and encode data in base64

```yaml
# yamllint disable
apiVersion: v1
kind: Secret
metadata:
    name: age-key
    namespace: flux-system
data:
  age.agekey: ""
```

```shell
sops -e -i kubernetes/flux/config/age-key.sops.yaml
```
