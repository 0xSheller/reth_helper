#!/bin/bash

# Function to determine the OS
get_os() {
    local os=""
    case "$(uname -s)" in
        Linux*)     os="linux";;
        FreeBSD*)   os="freebsd";;
        OpenBSD*)   os="openbsd";;
        NetBSD*)    os="netbsd";;
        DragonFly*) os="dragonfly";;
        Darwin*)    os="darwin";;
        *)          os="unknown";;
    esac
    echo "$os"
}

# Function to determine the CPU architecture
get_arch() {
    local arch=""
    case "$(uname -m)" in
        x86_64)     arch="amd64";;
        aarch64)    arch="aarch64";;
        arm64*)     arch="arm64";;
        armv5*)     arch="armv5";;
        armv6*)     arch="armv6";;
        armv7*)     arch="armv7";;
        *)          arch="unknown";;
    esac
    echo "$arch"
}

# Function to determine the CPU architecture (again because im lazy)
get_arch_raw() {
    local arch_raw=""
    case "$(uname -m)" in
        x86_64)     arch="x86_64";;
        aarch64)    arch="aarch64";;
        arm64*)     arch="arm64";;
        armv5*)     arch="armv5";;
        armv6*)     arch="armv6";;
        armv7*)     arch="armv7";;
        *)          arch="unknown";;
    esac
    echo "$arch"
}

# Call the functions to get OS and CPU architecture
OS=$(get_os)
ARCH=$(get_arch)
ARCH_RAW=$(get_arch_raw)
