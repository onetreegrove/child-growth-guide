#!/usr/bin/env bash
set -euo pipefail

APP_NAME="child-growth-guide"
DOMAIN="child.tuanshuji.cn"
REPO="onetreegrove/child-growth-guide"
APP_ROOT="/wwwroot/${APP_NAME}"
RELEASES_DIR="${APP_ROOT}/releases"
CURRENT_LINK="${APP_ROOT}/current"

usage() {
  cat <<USAGE
Usage:
  ./deploy.sh <version>

Example:
  ./deploy.sh v0.1.0

Environment:
  GITHUB_TOKEN  Optional. Required only if the GitHub release asset is private.
USAGE
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

download_asset() {
  local version="$1"
  local output="$2"
  local asset_name
  local url
  local curl_args=(-fL --retry 3 --retry-delay 2 -o "${output}")
  local asset_names=(
    "${APP_NAME}-${version}.tar.gz"
    "child-growth-h5-${version}.tar.gz"
  )

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_args+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    curl_args+=(-H "X-GitHub-Api-Version: 2022-11-28")
  fi

  for asset_name in "${asset_names[@]}"; do
    url="https://github.com/${REPO}/releases/download/${version}/${asset_name}"
    echo "Downloading ${url}"

    if curl "${curl_args[@]}" "${url}"; then
      return 0
    fi

    echo "Asset not available: ${asset_name}" >&2
  done

  echo "No downloadable release asset found for ${version}." >&2
  exit 1
}

deploy() {
  local version="$1"
  local release_dir="${RELEASES_DIR}/${version}"
  local tmp_archive

  if [[ ! "${version}" =~ ^v[0-9]+(\.[0-9]+){2}([-+][0-9A-Za-z.-]+)?$ ]]; then
    echo "Version must look like v0.1.0, got: ${version}" >&2
    exit 1
  fi

  require_command curl
  require_command tar

  mkdir -p "${RELEASES_DIR}"

  if [[ -e "${release_dir}" ]]; then
    echo "Release directory already exists: ${release_dir}" >&2
    echo "Remove it manually before redeploying the same version." >&2
    exit 1
  fi

  tmp_archive="$(mktemp "/tmp/${APP_NAME}-${version}.XXXXXX.tar.gz")"
  trap 'rm -f "${tmp_archive}"' EXIT

  download_asset "${version}" "${tmp_archive}"

  mkdir -p "${release_dir}"
  tar -xzf "${tmp_archive}" -C "${release_dir}"

  if [[ ! -f "${release_dir}/index.html" ]]; then
    echo "Invalid release asset: index.html not found after extraction." >&2
    exit 1
  fi

  ln -sfn "${release_dir}" "${CURRENT_LINK}"

  echo "Deployed ${APP_NAME} ${version}"
  echo "Domain: ${DOMAIN}"
  echo "Current release: $(readlink -f "${CURRENT_LINK}")"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 1
fi

deploy "$1"
