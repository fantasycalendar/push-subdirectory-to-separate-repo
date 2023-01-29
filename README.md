# Push Subdirectories

GitHub Action to push subdirectories to separate repositories.

### Why?
Sometimes it's easier to have a monorepo that splits out into other repos, such as projects that build into webassembly, or multi-part NPM packages.

## Usage

```yml
name: Publish Slack Repo
on: push
jobs:
  master:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: push-subdirectory
        uses: fantasycalendar/push-subdirectory-to-separate-repo@master
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          args: source_directory destination_repo
```

The `GITHUB_TOKEN` will automatically be defined, the `API_TOKEN_GITHUB` needs to be set in the `Secrets` section of your repository options. You can retrieve the `API_TOKEN_GITHUB` [here](https://github.com/settings/tokens) (set the `repo` permission).

The action accepts two arguments:

1. Name of the local subdirectory that you want to push
2. Destination repository path (e.g. `fantasycalendar/some-repo`)
