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

Then, you can install `kubekick` with Homebrew:

    $ brew tap rzane/kubekick
    $ brew install kubekick

If you're on Linux, you'll have to [build from source](#building-from-source).

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

Install [EJSON](https://github.com/Shopify/ejson), then generate a keypair:

    $ ejson keygen

Create a Kubernetes secret in your target namespace with the new keypair:

    $ kubectl create secret generic ejson-keys --from-literal=YOUR_PUBLIC_KEY=YOUR_PRIVATE_KEY --namespace=TARGET_NAMESPACE

Create a `secrets.ejson` file:

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

    $ ejson encrypt path/to/secrets.ejson

Now you can deploy them:

    $ kubekick secrets -f path/to/secrets.ejson

You can safely commit the `secrets.ejson` file. You might also want to consider saving your keypair somewhere.

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

## Building from source

1. Install [Crystal](https://crystal-lang.org/docs/installation/).
2. Install [libsodium](https://download.libsodium.org/doc/installation/).
3. Run `make`
4. Copy `bin/kubekick` to the install directory for your platform.

## Developing

Install requirements:

    $ brew install crystal-lang libsodium

Run tests:

    $ crystal spec

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Tribute

Kubekick is pretty much a blatant ripoff of [kubernetes-deploy](https://github.com/Shopify/kubernetes-deploy). If you find yourself needing a more fully featured tool, you should use it.

I build Kubekick because:

1. I thought it would be nice to have pre-compiled binaries (coming soon).
2. I wanted to use Crystal.
3. I felt that `kubernetes-deploy` was doing more than I needed.
