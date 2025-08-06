terminal
========

A [Snakefile](https://snakemake.readthedocs.io/en/stable/) to download, extract, and install a set of *cool* command line tools from GitHub.


Setup
-----

Snakemake can be installed using `pip`:

```bash
pip install snakemake
```

The run the `Snakefile`:

```
snakemake --cores all
```


Usage
-----

Copy the content of `bin` to a place in you `PATH`.


Homebrew
--------

On a mac, all tools can be installed using [Homebrew](https://brew.sh):


```bash
brew install bat btop duf dust erdtree fd fzf ripgrep viddy
```
