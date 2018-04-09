# kubekick [![Build Status](https://travis-ci.org/rzane/kubekick.svg?branch=master)](https://travis-ci.org/rzane/kubekick)

A companion tool for doing deployments with Kubernetes.

#### One-off tasks

Applications often have tasks that need to be run before the deployment rolls out. Probably the most common example is running database migrations.

#### Secrets

Secrets are a tricky thing to manage. Kubekick takes away the headache. Just create a `secrets.ejson` file, which is just a JSON file with encrypted values. Kubekick can deploy these encrypted secrets for you.

#### Templating

It would be really nice if this was part of Kubernetes, but it isn't. So, Kubekick can read a template and inject some variables.

## Installation

Kubekick expects you to have `kubectl` installed.

If you're on macOS, you can install `kubekick` with Homebrew:

    $ brew tap rzane/kubekick
    $ brew install kubekick

Alternatively, you can install a pre-built binary from the [releases page](https://github.com/rzane/kubekick/releases).

## Usage

### One-off-tasks

Create a kubernetes pod template with `restartPolicy: Never`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
spec:
  restartPolicy: Never
  activeDeadlineSeconds: 10
  containers:
    - name: example
      image: alpine:3.6
      command: ["sleep", "5"]
```

Now, simply run it:

    $ kubekick run -f path/to/file.yaml

When you run it, `kubekick` will assign a unique name to the pod, so that it won't conflict with others.

Here's the output you'd see:

    pod "example-4e32ae20-7f3e-4b0f-b731-213797d0024d" pending
    pod "example-4e32ae20-7f3e-4b0f-b731-213797d0024d" running
    pod "example-4e32ae20-7f3e-4b0f-b731-213797d0024d" succeeded
    pod "example-4e32ae20-7f3e-4b0f-b731-213797d0024d" deleted

### Secrets

First, you need to generate a keypair. Running this command will store the keypair as a secret in your Kubernetes cluster.

    $ kubekick secrets provision
    secret "ejson-keys" created
    public key:  2fbd6f1978d14fcc9df3a463e0718a22f0023ae8aaaa0be5c28118c99e31ec64
    secret key:  e600285996f56db39a858e3f49a4f785b1c4ad7db455f935f822b02f226574e0

Next, create a file named `secrets.ejson`:

```json
{
  "_public_key": "YOUR_PUBLIC_KEY",
  "kubernetes_secrets": {
    "secrets": {
      "_type": "Opaque",
      "data": {
        "api-token": "blah blah blah"
      }
    }
  }
}
```

Encrypt the values:

    $ kubekick secrets encrypt -f path/to/secrets.ejson

Now you can deploy them:

    $ kubekick secrets deploy -f path/to/secrets.ejson

You can safely commit the `secrets.ejson` file. You might also want to consider backing up your keypair somewhere.

### Templating

There are certainly more powerful templating tools than Kubekick, but it should get the job done for simple cases. Templating is done with [mustache](https://mustache.github.io/).

Given a file:

    This is a template, and this {{ value }} will be replaced.

Now, you can render that template:

    $ kubekick template -f path/to/file.txt value=PARTY

This command will output:

    This is a template, and this PARTY will be replaced.

This feature is particularly useful when combined with other commands:

    $ kubekick template -f path/to/file.yaml image=alpine:3.6 | kubekick run -f -

## Developing

Install requirements:

    $ brew install crystal-lang libsodium

Run tests:

    $ crystal spec

## Contributing

1.  Fork it
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Commit your changes (git commit -am 'Add some feature')
4.  Push to the branch (git push origin my-new-feature)
5.  Create a new Pull Request

## Tribute

Kubekick is pretty much a blatant ripoff of [kubernetes-deploy](https://github.com/Shopify/kubernetes-deploy). If you find yourself needing a more fully featured tool, you should use it.

I built Kubekick because:

1.  I thought it would be nice to have pre-compiled binaries.
2.  I wanted to use Crystal.
3.  I felt that `kubernetes-deploy` was doing more than I needed.
