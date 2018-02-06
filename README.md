# OpenID-Connect-proxy

# Installation

* Customize files in `deploy/*.example`, removing the `.example` suffix when saving.
* The Kubernetes configuration files uses the Namespace "openidc"

```
kubectl create namespace openidc
kubectl -n openidc apply -f deploy/*.yml
```


# Attribution
* https://github.com/zmartzone/mod_auth_openidc
* Thanks to @mward29, this post: http://www.devoperandi.com/kubernetes-authentication-openid-connect/ and the associated project: https://github.com/mward29/openidc, upon which this project is based
