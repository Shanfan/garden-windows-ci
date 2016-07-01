#!/usr/bin/env bash

bosh_cli() {
  gem install bosh_cli --no-rdoc --no-ri
}

bosh_cert() {
  CA_CERT=""
  if [[ -n "${BOSH_TARGET_CERT}" ]]; then
    echo -n "${BOSH_TARGET_CERT}" > /tmp/cert
    chmod 600 /tmp/cert
    CA_CERT="--ca-cert /tmp/cert"
  fi
}

bosh_release() {
  pushd release
  bosh create release --name ${RELEASE_NAME} --force
  bosh -n ${CA_CERT} target ${BOSH_TARGET_URL}
  printf "${BOSH_USER}\n${BOSH_PASSWORD}" | bosh login
  bosh -t ${BOSH_TARGET_URL} upload release --rebase
  popd
}

main() {
  set -e
  set -o pipefail

  bosh_cli
  bosh_cert
  bosh_release
}

main "$@"