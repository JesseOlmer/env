if (( $+commands[microk8s.kubectl] )); then
    __MICROK8S_KUBECTL_COMPLETION_FILE="${ZSH_CACHE_DIR}/microk8s_kubectl_completion"

    if [[ ! -f $__MICROK8S_KUBECTL_COMPLETION_FILE ]]; then
        microk8s.kubectl completion zsh >! $__MICROK8S_KUBECTL_COMPLETION_FILE
    fi

    if [[ -f $__MICROK8S_KUBECTL_COMPLETION_FILE ]]; then
        sed -i "s/complete -o default -F __start_kubectl kubectl/complete -o default -F __start_kubectl microk8s.kubectl/g" $__MICROK8S_KUBECTL_COMPLETION_FILE
        sed -i "s/complete -o default -o nospace -F __start_kubectl kubectl/complete -o default -o nospace -F __start_kubectl microk8s.kubectl/g" $__MICROK8S_KUBECTL_COMPLETION_FILE

        source $__MICROK8S_KUBECTL_COMPLETION_FILE
    fi

    unset __MICROK8S_KUBECTL_COMPLETION_FILE
fi

# This command is used a LOT both below and in daily life
alias mk=kubectl

# Apply a YML file
alias mkaf='kubectl apply -f'

# Drop into an interactive terminal on a container
alias mketi='kubectl exec -ti'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias mkcuc='kubectl config use-context'
alias mkcsc='kubectl config set-context'
alias mkcdc='kubectl config delete-context'
alias mkccc='kubectl config current-context'

# General aliases
alias mkdel='kubectl delete'
alias mkdelf='kubectl delete -f'

# Pod management.
alias mkgp='kubectl get pods'
alias mkgpw='kgp --watch'
alias mkgpwide='kgp -o wide'
alias mkep='kubectl edit pods'
alias mkdp='kubectl describe pods'
alias mkdelp='kubectl delete pods'

# get pod by label: kgpl "app=myapp" -n myns
alias mkgpl='function _kgpl(){ label=$1; shift; kgp -l $label $*; };_kgpl'

# Service management.
alias mkgs='kubectl get svc'
alias mkgsw='kgs --watch'
alias mkgswide='kgs -o wide'
alias mkes='kubectl edit svc'
alias mkds='kubectl describe svc'
alias mkdels='kubectl delete svc'

# Ingress management
alias mkgi='kubectl get ingress'
alias mkei='kubectl edit ingress'
alias mkdi='kubectl describe ingress'
alias mkdeli='kubectl delete ingress'

# Namespace management
alias mkgns='kubectl get namespaces'
alias mkens='kubectl edit namespace'
alias mkdns='kubectl describe namespace'
alias mkdelns='kubectl delete namespace'

# ConfigMap management
alias mkgcm='kubectl get configmaps'
alias mkecm='kubectl edit configmap'
alias mkdcm='kubectl describe configmap'
alias mkdelcm='kubectl delete configmap'

# Secret management
alias mkgsec='kubectl get secret'
alias mkdsec='kubectl describe secret'
alias mkdelsec='kubectl delete secret'

# Deployment management.
alias mkgd='kubectl get deployment'
alias mkgdw='kgd --watch'
alias mkgdwide='kgd -o wide'
alias mked='kubectl edit deployment'
alias mkdd='kubectl describe deployment'
alias mkdeld='kubectl delete deployment'
alias mksd='kubectl scale deployment'
alias mkrsd='kubectl rollout status deployment'

# Rollout management.
alias mkgrs='kubectl get rs'
alias mkrh='kubectl rollout history'
alias mkru='kubectl rollout undo'

# Port forwarding
alias mkpf="kubectl port-forward"

# Tools for accessing all information
alias mkga='kubectl get all'
alias mkgaa='kubectl get all --all-namespaces'

# Logs
alias mkl='kubectl logs'
alias mklf='kubectl logs -f'

# File copy
alias mkcp='kubectl cp'

# Node Management
alias mkgno='kubectl get nodes'
alias mkeno='kubectl edit node'
alias mkdno='kubectl describe node'
alias mkdelno='kubectl delete node'