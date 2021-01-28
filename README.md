# Blockscout Docker image
## Building

Set the Blockscout version you want in the Dockerfile `ENV VERSION`. The list of versions is available on [Blockscout Github's release page](https://github.com/poanetwork/blockscout/tags)

```console
docker build -t pbesson/blockscout:VERSION .
```

## Usage

Docker image supports the same environment variables as Blockscout app itself. Use [documentation](https://docs.blockscout.com/for-developers/information-and-settings/env-variables) for reference.

```console
docker-compose up -d
```

# Credits

Thanks to Ulamlabs and [Maciej Janiszewski](https://github.com/ksiazkowicz) for the initial version of this Dockerfile.

