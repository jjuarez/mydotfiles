set -o pipefail

KUBECTL=$(command -v kubectl 2>/dev/null)
JQ=$(command -v jq 2>/dev/null)

# Who is using this secret
k8s::secrets::who() {
  local -r secret_name="${1}"

  [[ -x "${KUBECTL}" ]] || return 1
  [[ -x "${JQ}" ]] || return 1
  [[ -n "${secret_name}" ]] || return 1

  ${KUBECTL} get deployment.apps,statefulset.apps,daemonset.apps,jobs.batch,cronjobs.batch -o json \
    | ${JQ} -r ".items[]|select(.spec.template.spec.containers[]?.env[]?.valueFrom.secretKeyRef.name==\"${secret_name}\")|.metadata.name"|sort|uniq
}

k8s::es::key() {
  local -r secret_name="${1}"

  [[ -x "${KUBECTL}" ]] || return 1
  [[ -x "${JQ}" ]] || return 1
  [[ -n "${secret_name}" ]] || return 1

  ${KUBECTL} get externalsecret.external-secrets.io ${secret_name} -o json \
    | ${JQ} -r ".spec.data[0].remoteRef.key"
}

k8s::es::annotate() {
  local -r secret_name="${1}"

  [[ -x "${KUBECTL}" ]] || return 1
  [[ -n "${secret_name}" ]] || return 1

  ${KUBECTL} annotate externalsecret.external-secrets.io ${secret_name} force-sync=$(date +%s) --overwrite
}


# autoloads
autoload k8s::secret::who
autoload k8s::es::key

# aliases
