# Tekton Dashboard - Carvel package for Tanzu

This project defines a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging/)
for [Tekton Dashboard](https://tekton.dev/docs/dashboard), a web UI for Tekton.

Please note this package only includes the [Tekton Dashboard](https://github.com/tektoncd/dashboard) module.

**You must install [Tekton Pipelines](https://github.com/tektoncd/pipeline) first before using this package.**

## How to use it?

This package is part of the
[Tanzu Extra package repository](https://github.com/alexandreroman/tanzu-extra-repo).
Please refer to this page for installation instructions.

The dashboard is not publicly available exposed by this package.

Use this command to get access to the dashboard:

```shell
kubectl -n tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
```

Now go to <http://localhost:9097> to use Tekton Dashboard.

You may get better results with `kubectl proxy`,
as I found out that port forwarding would sometimes drop the connection to the dashboard.

Use this command to open a connection to your cluster:

```shell
kubectl proxy
```

Then head over to
<http://localhost:8001/api/v1/namespaces/tekton-pipelines/services/tekton-dashboard:http/proxy/>
in order to access the dashboard.

You may want to use an `Ingress` resource instead to expose the dashboard:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tekton-dashboard
  namespace: tekton-pipelines
  labels:
    app: tekton-dashboard
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/name: dashboard
    app.kubernetes.io/part-of: tekton-dashboard
spec:
  rules:
  - host: dashboard.tekton.corp
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: tekton-dashboard
            port:
              number: 9097
```

## Contribute

Contributions are always welcome!

Feel free to open issues & send PR.

## License

Copyright &copy; 2022 [VMware, Inc. or its affiliates](https://vmware.com).

This project is licensed under the [Apache Software License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
