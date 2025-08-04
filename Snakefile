import os

from dotenv import load_dotenv

load_dotenv(".env")

bin_dir = os.getenv("BIN_DIR") or "bin"
src_dir = os.getenv("SRC_DIR") or "src"

tools = {
    "bat": {
        "url": "https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz",
        "tar": "bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz",
        "bin": "bat-v0.25.0-x86_64-unknown-linux-gnu/bat"
    },
    "btop": {
        "url": "https://github.com/aristocratos/btop/releases/download/v1.4.4/btop-x86_64-linux-musl.tbz",
        "tar": "btop-x86_64-linux-musl.tbz",
        "bin": "btop/bin/btop"
    },
    "duf": {
        "url": "https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_x86_64.tar.gz",
        "tar": "duf_0.8.1_linux_x86_64.tar.gz",
        "bin": "duf"
    },
    "dust": {
        "url": "https://github.com/bootandy/dust/releases/download/v1.2.2/dust-v1.2.2-x86_64-unknown-linux-gnu.tar.gz",
        "tar": "dust-v1.2.2-x86_64-unknown-linux-gnu.tar.gz",
        "bin": "dust-v1.2.2-x86_64-unknown-linux-gnu/dust"
    },
    "erd": {
        "url": "https://github.com/solidiquis/erdtree/releases/download/v3.1.2/erd-v3.1.2-x86_64-unknown-linux-musl.tar.gz",
        "tar": "erd-v3.1.2-x86_64-unknown-linux-musl.tar.gz",
        "bin": "erd"
    },
    "fd": {
        "url": "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz",
        "tar": "fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz",
        "bin": "fd-v10.2.0-x86_64-unknown-linux-gnu/fd"
    },
    "fzf": {
        "url": "https://github.com/junegunn/fzf/releases/download/v0.65.0/fzf-0.65.0-linux_amd64.tar.gz",
        "tar": "fzf-0.65.0-linux_amd64.tar.gz",
        "bin": "fzf"
    },
    "rg": {
        "url": "https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz",
        "tar": "ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz",
        "bin": "ripgrep-14.1.1-x86_64-unknown-linux-musl/rg"
    },
    "viddy": {
        "url": "https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-x86_64.tar.gz",
        "tar": "viddy-v1.3.0-linux-x86_64.tar.gz",
        "bin": "viddy"
    }
}

rule all:
    input:
        expand(f"{bin_dir}/{{tool}}", tool=tools.keys())

rule install:
    input:
        lambda wildcards: f"{src_dir}/{wildcards.tool}/{tools[wildcards.tool]['bin']}"
    output:
        f"{bin_dir}/{{tool}}"
    shell:
        "cp {input} {output}"

rule extract:
    input:
        lambda wildcards: f"{src_dir}/{wildcards.tool}/{tools[wildcards.tool]['tar']}"
    output:
        f"{src_dir}/{{tool,[^/]+}}/{{path}}"
    shell:
        """
        if [[ "{input}" == *.tar.gz ]]; then
            tar xzvf {input} -C {src_dir}/{wildcards.tool}
        elif [[ "{input}" == *.tbz ]]; then
            tar xjvf {input} -C {src_dir}/{wildcards.tool}
        else
            echo "Unsupported archive format: {input}" >&2
            exit 1
        fi
        """

rule download:
    output:
        f"{src_dir}/{{tool,[^/]+}}/{{tar,.*\\.(tar\\.gz|tbz)}}"
    params:
        url=lambda wildcards: tools[wildcards.tool]['url']
    shell:
        "wget -O {output} {params.url}"
