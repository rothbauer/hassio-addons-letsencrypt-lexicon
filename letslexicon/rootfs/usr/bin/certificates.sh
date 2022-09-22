#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Let's Lexicon
#
# Generates certificates for Home Assistant.
# This add-on uses Let's Encrypt to authorise and retrieve certificates.
# ==============================================================================

# ------------------------------------------------------------------------------
# Creates and renews certificates
#
# Arguments:
#   None
# Returns:
#   None
# -----------------------------------------------------------------------------
refresh_certificates() {
    local cert_dir
    local certalias
    local certfile
    local certlist
    local dns_provider
    local domains
    local email
    local email_regex
    local firstcertalias
    local keyfile
    local provider
    local timestamp
    local LEXICON_ALIYUN_KEY_ID
    local LEXICON_ALIYUN_SECRET
    local LEXICON_AURORA_API_KEY
    local LEXICON_AURORA_SECRET_KEY
    local LEXICON_AZURE_CLIENT_ID
    local LEXICON_AZURE_CLIENT_SECRET
    local LEXICON_AZURE_RESOURCE_GROUP
    local LEXICON_AZURE_SUBSCRIPTION_ID
    local LEXICON_AZURE_TENANT_ID
    local LEXICON_CLOUDFLARE_TOKEN
    local LEXICON_CLOUDFLARE_USERNAME
    local LEXICON_CLOUDNS_ID
    local LEXICON_CLOUDNS_PASSWORD
    local LEXICON_CLOUDNS_PORT
    local LEXICON_CLOUDNS_SUBID
    local LEXICON_CLOUDNS_SUBUSER
    local LEXICON_CLOUDNS_WEIGHT
    local LEXICON_CLOUDXNS_TOKEN
    local LEXICON_CLOUDXNS_USERNAME
    local LEXICON_CONOHA_PASSWORD
    local LEXICON_CONOHA_REGION
    local LEXICON_CONOHA_TENANT_ID
    local LEXICON_CONOHA_TOKEN
    local LEXICON_CONOHA_USERNAME
    local LEXICON_CONSTELLIX_TOKEN
    local LEXICON_CONSTELLIX_USERNAME
    local LEXICON_DIGITALOCEAN_TOKEN
    local LEXICON_DINAHOSTING_PASSWORD
    local LEXICON_DINAHOSTING_USERNAME
    local LEXICON_DIRECTADMIN_ENDPOINT
    local LEXICON_DIRECTADMIN_PASSWORD
    local LEXICON_DIRECTADMIN_USERNAME
    local LEXICON_DNSIMPLE_2FA
    local LEXICON_DNSIMPLE_PASSWORD
    local LEXICON_DNSIMPLE_TOKEN
    local LEXICON_DNSIMPLE_USERNAME
    local LEXICON_DNSMADEEASY_TOKEN
    local LEXICON_DNSMADEEASY_USERNAME
    local LEXICON_DNSPARK_TOKEN
    local LEXICON_DNSPARK_USERNAME
    local LEXICON_DNSPOD_TOKEN
    local LEXICON_DNSPOD_USERNAME
    local LEXICON_DREAMHOST_TOKEN
    local LEXICON_EASYDNS_TOKEN
    local LEXICON_EASYDNS_USERNAME
    local LEXICON_EASYNAME_PASSWORD
    local LEXICON_EASYNAME_USERNAME
    local LEXICON_EXOSCALE_KEY
    local LEXICON_EXOSCALE_SECRET
    local LEXICON_GANDI_API_PROTOCOL
    local LEXICON_GANDI_TOKEN
    local LEXICON_GEHIRN_SECRET
    local LEXICON_GEHIRN_TOKEN
    local LEXICON_GLESYS_TOKEN
    local LEXICON_GLESYS_USERNAME
    local LEXICON_GODADDY_KEY
    local LEXICON_GODADDY_SECRET
    local LEXICON_GOOGLECLOUDDNS_SERVICE_ACCOUNT_INFO
    local LEXICON_GRATISDNS_PASSWORD
    local LEXICON_GRATISDNS_USERNAME
    local LEXICON_HENET_PASSWORD
    local LEXICON_HENET_USERNAME
    local LEXICON_HETZNER_ACCOUNT
    local LEXICON_HETZNER_LATENCY
    local LEXICON_HETZNER_PASSWORD
    local LEXICON_HETZNER_USERNAME
    local LEXICON_HOSTINGDE_TOKEN
    local LEXICON_HOVER_PASSWORD
    local LEXICON_HOVER_USERNAME
    local LEXICON_INFOBLOX_IB_HOST
    local LEXICON_INFOBLOX_IB_VIEW
    local LEXICON_INFOBLOX_PSW
    local LEXICON_INFOBLOX_USER
    local LEXICON_INTERNETBS_KEY
    local LEXICON_INTERNETBS_PASSWORD
    local LEXICON_INWX_PASSWORD
    local LEXICON_INWX_USERNAME
    local LEXICON_LINODE_TOKEN
    local LEXICON_LINODE4_TOKEN
    local LEXICON_LOCALZONE_FILENAME
    local LEXICON_LUADNS_TOKEN
    local LEXICON_LUADNS_USERNAME
    local LEXICON_MEMSET_TOKEN
    local LEXICON_NAMECHEAP_CLIENT_IP
    local LEXICON_NAMECHEAP_TOKEN
    local LEXICON_NAMECHEAP_USERNAME
    local LEXICON_NAMESILO_TOKEN
    local LEXICON_NETCUP_API_KEY
    local LEXICON_NETCUP_API_PASSWORD
    local LEXICON_NETCUP_CUSTOMER_ID
    local LEXICON_NFSN_TOKEN
    local LEXICON_NFSN_USERNAME
    local LEXICON_NSONE_TOKEN
    local LEXICON_ONAPP_SERVER
    local LEXICON_ONAPP_TOKEN
    local LEXICON_ONAPP_USERNAME
    local LEXICON_ONLINE_TOKEN
    local LEXICON_OVH_APPLICATION_KEY
    local LEXICON_OVH_APPLICATION_SECRET
    local LEXICON_OVH_CONSUMER_KEY
    local LEXICON_PLESK_PASSWORD
    local LEXICON_PLESK_PLESK_SERVER
    local LEXICON_PLESK_USERNAME
    local LEXICON_POINTHQ_TOKEN
    local LEXICON_POINTHQ_USERNAME
    local LEXICON_POWERDNS_PDNS_DISABLE_NOTIFY
    local LEXICON_POWERDNS_PDNS_SERVER
    local LEXICON_POWERDNS_PDNS_SERVER_ID
    local LEXICON_POWERDNS_TOKEN
    local LEXICON_RACKSPACE_ACCOUNT
    local LEXICON_RACKSPACE_API_KEY
    local LEXICON_RACKSPACE_SLEEP_TIME
    local LEXICON_RACKSPACE_TOKEN
    local LEXICON_RACKSPACE_USERNAME
    local LEXICON_RAGE4_TOKEN
    local LEXICON_RAGE4_USERNAME
    local LEXICON_RCODEZERO_TOKEN
    local LEXICON_ROUTE53_ACCESS_KEY
    local LEXICON_ROUTE53_ACCESS_SECRET
    local LEXICON_ROUTE53_PRIVATE_ZONE
    local LEXICON_ROUTE53_TOKEN
    local LEXICON_ROUTE53_USERNAME
    local LEXICON_SAFEDNS_TOKEN
    local LEXICON_SAKURACLOUD_SECRET
    local LEXICON_SAKURACLOUD_TOKEN
    local LEXICON_SOFTLAYER_API_KEY
    local LEXICON_SOFTLAYER_USERNAME
    local LEXICON_SUBREG_PASSWORD
    local LEXICON_SUBREG_USERNAME
    local LEXICON_TRANSIP_API_KEY
    local LEXICON_TRANSIP_USERNAME
    local LEXICON_VULTR_TOKEN
    local LEXICON_YANDEX_TOKEN
    local LEXICON_ZEIT_TOKEN
    local LEXICON_ZILORE_KEY
    local LEXICON_ZONOMI_TOKEN

    bashio::log.trace "${FUNCNAME[0]}"

    cert_dir=/data/letsencrypt
    email_regex="^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$"

    mkdir -p "$cert_dir"
    mkdir -p "/ssl"

    email=$(bashio::config 'email')
    domains=$(bashio::config 'domains')
    keyfile=$(bashio::config 'keyfile')
    certfile=$(bashio::config 'certfile')
    dns_provider=$(bashio::config 'dns.provider')

    LEXICON_ALIYUN_KEY_ID=$(bashio::config 'dns.aliyun_key_id')
    export LEXICON_ALIYUN_KEY_ID
    LEXICON_ALIYUN_SECRET=$(bashio::config 'dns.aliyun_secret')
    export LEXICON_ALIYUN_SECRET
    LEXICON_AURORA_API_KEY=$(bashio::config 'dns.aurora_api_key')
    export LEXICON_AURORA_API_KEY
    LEXICON_AURORA_SECRET_KEY=$(bashio::config 'dns.aurora_secret_key')
    export LEXICON_AURORA_SECRET_KEY
    LEXICON_AZURE_CLIENT_ID=$(bashio::config 'dns.azure_client_id')
    export LEXICON_AZURE_CLIENT_ID
    LEXICON_AZURE_CLIENT_SECRET=$(bashio::config 'dns.azure_client_secret')
    export LEXICON_AZURE_CLIENT_SECRET
    LEXICON_AZURE_TENANT_ID=$(bashio::config 'dns.azure_tenant_id')
    export LEXICON_AZURE_TENANT_ID
    LEXICON_AZURE_SUBSCRIPTION_ID=$(bashio::config 'dns.azure_subscription_id')
    export LEXICON_AZURE_SUBSCRIPTION_ID
    LEXICON_AZURE_RESOURCE_GROUP=$(bashio::config 'dns.azure_resource_group')
    export LEXICON_AZURE_RESOURCE_GROUP
    LEXICON_CLOUDFLARE_USERNAME=$(bashio::config 'dns.cloudflare_username')
    export LEXICON_CLOUDFLARE_USERNAME
    LEXICON_CLOUDFLARE_TOKEN=$(bashio::config 'dns.cloudflare_token')
    export LEXICON_CLOUDFLARE_TOKEN
    LEXICON_CLOUDNS_ID=$(bashio::config 'dns.cloudns_id')
    export LEXICON_CLOUDNS_ID
    LEXICON_CLOUDNS_SUBID=$(bashio::config 'dns.cloudns_subid')
    export LEXICON_CLOUDNS_SUBID
    LEXICON_CLOUDNS_SUBUSER=$(bashio::config 'dns.cloudns_subuser')
    export LEXICON_CLOUDNS_SUBUSER
    LEXICON_CLOUDNS_PASSWORD=$(bashio::config 'dns.cloudns_password')
    export LEXICON_CLOUDNS_PASSWORD
    LEXICON_CLOUDNS_WEIGHT=$(bashio::config 'dns.cloudns_weight')
    export LEXICON_CLOUDNS_WEIGHT
    LEXICON_CLOUDNS_PORT=$(bashio::config 'dns.cloudns_port')
    export LEXICON_CLOUDNS_PORT
    LEXICON_CLOUDXNS_USERNAME=$(bashio::config 'dns.cloudxns_username')
    export LEXICON_CLOUDXNS_USERNAME
    LEXICON_CLOUDXNS_TOKEN=$(bashio::config 'dns.cloudxns_token')
    export LEXICON_CLOUDXNS_TOKEN
    LEXICON_CONOHA_REGION=$(bashio::config 'dns.conoha_region')
    export LEXICON_CONOHA_REGION
    LEXICON_CONOHA_TOKEN=$(bashio::config 'dns.conoha_token')
    export LEXICON_CONOHA_TOKEN
    LEXICON_CONOHA_USERNAME=$(bashio::config 'dns.conoha_username')
    export LEXICON_CONOHA_USERNAME
    LEXICON_CONOHA_PASSWORD=$(bashio::config 'dns.conoha_password')
    export LEXICON_CONOHA_PASSWORD
    LEXICON_CONOHA_TENANT_ID=$(bashio::config 'dns.conoha_tenant_id')
    export LEXICON_CONOHA_TENANT_ID
    LEXICON_CONSTELLIX_USERNAME=$(bashio::config 'dns.constellix_username')
    export LEXICON_CONSTELLIX_USERNAME
    LEXICON_CONSTELLIX_TOKEN=$(bashio::config 'dns.constellix_token')
    export LEXICON_CONSTELLIX_TOKEN
    LEXICON_DIGITALOCEAN_TOKEN=$(bashio::config 'dns.digitalocean_token')
    export LEXICON_DIGITALOCEAN_TOKEN
    LEXICON_DINAHOSTING_USERNAME=$(bashio::config 'dns.dinahosting_username')
    export LEXICON_DINAHOSTING_USERNAME
    LEXICON_DINAHOSTING_PASSWORD=$(bashio::config 'dns.dinahosting_password')
    export LEXICON_DINAHOSTING_PASSWORD
    LEXICON_DIRECTADMIN_PASSWORD=$(bashio::config 'dns.directadmin_password')
    export LEXICON_DIRECTADMIN_PASSWORD
    LEXICON_DIRECTADMIN_USERNAME=$(bashio::config 'dns.directadmin_username')
    export LEXICON_DIRECTADMIN_USERNAME
    LEXICON_DIRECTADMIN_ENDPOINT=$(bashio::config 'dns.directadmin_endpoint')
    export LEXICON_DIRECTADMIN_ENDPOINT
    LEXICON_DNSIMPLE_TOKEN=$(bashio::config 'dns.dnsimple_token')
    export LEXICON_DNSIMPLE_TOKEN
    LEXICON_DNSIMPLE_USERNAME=$(bashio::config 'dns.dnsimple_username')
    export LEXICON_DNSIMPLE_USERNAME
    LEXICON_DNSIMPLE_PASSWORD=$(bashio::config 'dns.dnsimple_password')
    export LEXICON_DNSIMPLE_PASSWORD
    LEXICON_DNSIMPLE_2FA=$(bashio::config 'dns.dnsimple_2fa')
    export LEXICON_DNSIMPLE_2FA
    LEXICON_DNSMADEEASY_USERNAME=$(bashio::config 'dns.dnsmadeeasy_username')
    export LEXICON_DNSMADEEASY_USERNAME
    LEXICON_DNSMADEEASY_TOKEN=$(bashio::config 'dns.dnsmadeeasy_token')
    export LEXICON_DNSMADEEASY_TOKEN
    LEXICON_DNSPARK_USERNAME=$(bashio::config 'dns.dnspark_username')
    export LEXICON_DNSPARK_USERNAME
    LEXICON_DNSPARK_TOKEN=$(bashio::config 'dns.dnspark_token')
    export LEXICON_DNSPARK_TOKEN
    LEXICON_DNSPOD_USERNAME=$(bashio::config 'dns.dnspod_username')
    export LEXICON_DNSPOD_USERNAME
    LEXICON_DNSPOD_TOKEN=$(bashio::config 'dns.dnspod_token')
    export LEXICON_DNSPOD_TOKEN
    LEXICON_DREAMHOST_TOKEN=$(bashio::config 'dns.dreamhost_token')
    export LEXICON_DREAMHOST_TOKEN
    LEXICON_EASYDNS_USERNAME=$(bashio::config 'dns.easydns_username')
    export LEXICON_EASYDNS_USERNAME
    LEXICON_EASYDNS_TOKEN=$(bashio::config 'dns.easydns_token')
    export LEXICON_EASYDNS_TOKEN
    LEXICON_EASYNAME_USERNAME=$(bashio::config 'dns.easyname_username')
    export LEXICON_EASYNAME_USERNAME
    LEXICON_EASYNAME_PASSWORD=$(bashio::config 'dns.easyname_password')
    export LEXICON_EASYNAME_PASSWORD
    LEXICON_EXOSCALE_KEY=$(bashio::config 'dns.exoscale_key')
    export LEXICON_EXOSCALE_KEY
    LEXICON_EXOSCALE_SECRET=$(bashio::config 'dns.exoscale_secret')
    export LEXICON_EXOSCALE_SECRET
    LEXICON_GANDI_TOKEN=$(bashio::config 'dns.gandi_token')
    export LEXICON_GANDI_TOKEN
    LEXICON_GANDI_API_PROTOCOL=$(bashio::config 'dns.gandi_api_protocol')
    export LEXICON_GANDI_API_PROTOCOL
    LEXICON_GEHIRN_TOKEN=$(bashio::config 'dns.gehirn_token')
    export LEXICON_GEHIRN_TOKEN
    LEXICON_GEHIRN_SECRET=$(bashio::config 'dns.gehirn_secret')
    export LEXICON_GEHIRN_SECRET
    LEXICON_GLESYS_USERNAME=$(bashio::config 'dns.glesys_username')
    export LEXICON_GLESYS_USERNAME
    LEXICON_GLESYS_TOKEN=$(bashio::config 'dns.glesys_token')
    export LEXICON_GLESYS_TOKEN
    LEXICON_GODADDY_KEY=$(bashio::config 'dns.godaddy_key')
    export LEXICON_GODADDY_KEY
    LEXICON_GODADDY_SECRET=$(bashio::config 'dns.godaddy_secret')
    export LEXICON_GODADDY_SECRET
    LEXICON_GOOGLECLOUDDNS_SERVICE_ACCOUNT_INFO=$(bashio::config 'dns.googleclouddns_service_account_info')
    export LEXICON_GOOGLECLOUDDNS_SERVICE_ACCOUNT_INFO
    LEXICON_GRATISDNS_USERNAME=$(bashio::config 'dns.gratisdns_username')
    export LEXICON_GRATISDNS_USERNAME
    LEXICON_GRATISDNS_PASSWORD=$(bashio::config 'dns.gratisdns_password')
    export LEXICON_GRATISDNS_PASSWORD
    LEXICON_HENET_USERNAME=$(bashio::config 'dns.henet_username')
    export LEXICON_HENET_USERNAME
    LEXICON_HENET_PASSWORD=$(bashio::config 'dns.henet_password')
    export LEXICON_HENET_PASSWORD
    LEXICON_HETZNER_ACCOUNT=$(bashio::config 'dns.hetzner_account')
    export LEXICON_HETZNER_ACCOUNT
    LEXICON_HETZNER_USERNAME=$(bashio::config 'dns.hetzner_username')
    export LEXICON_HETZNER_USERNAME
    LEXICON_HETZNER_PASSWORD=$(bashio::config 'dns.hetzner_password')
    export LEXICON_HETZNER_PASSWORD
    LEXICON_HETZNER_LATENCY=$(bashio::config 'dns.hetzner_latency')
    export LEXICON_HETZNER_LATENCY
    LEXICON_HOSTINGDE_TOKEN=$(bashio::config 'dns.hostingde_token')
    export LEXICON_HOSTINGDE_TOKEN
    LEXICON_HOVER_USERNAME=$(bashio::config 'dns.hover_username')
    export LEXICON_HOVER_USERNAME
    LEXICON_HOVER_PASSWORD=$(bashio::config 'dns.hover_password')
    export LEXICON_HOVER_PASSWORD
    LEXICON_INFOBLOX_USER=$(bashio::config 'dns.infoblox_user')
    export LEXICON_INFOBLOX_USER
    LEXICON_INFOBLOX_PSW=$(bashio::config 'dns.infoblox_psw')
    export LEXICON_INFOBLOX_PSW
    LEXICON_INFOBLOX_IB_VIEW=$(bashio::config 'dns.infoblox_ib_view')
    export LEXICON_INFOBLOX_IB_VIEW
    LEXICON_INFOBLOX_IB_HOST=$(bashio::config 'dns.infoblox_ib_host')
    export LEXICON_INFOBLOX_IB_HOST
    LEXICON_INTERNETBS_KEY=$(bashio::config 'dns.internetbs_key')
    export LEXICON_INTERNETBS_KEY
    LEXICON_INTERNETBS_PASSWORD=$(bashio::config 'dns.internetbs_password')
    export LEXICON_INTERNETBS_PASSWORD
    LEXICON_INWX_USERNAME=$(bashio::config 'dns.inwx_username')
    export LEXICON_INWX_USERNAME
    LEXICON_INWX_PASSWORD=$(bashio::config 'dns.inwx_password')
    export LEXICON_INWX_PASSWORD
    LEXICON_LINODE_TOKEN=$(bashio::config 'dns.linode_token')
    export LEXICON_LINODE_TOKEN
    LEXICON_LINODE4_TOKEN=$(bashio::config 'dns.linode4_token')
    export LEXICON_LINODE4_TOKEN
    LEXICON_LOCALZONE_FILENAME=$(bashio::config 'dns.localzone_filename')
    export LEXICON_LOCALZONE_FILENAME
    LEXICON_LUADNS_USERNAME=$(bashio::config 'dns.luadns_username')
    export LEXICON_LUADNS_USERNAME
    LEXICON_LUADNS_TOKEN=$(bashio::config 'dns.luadns_token')
    export LEXICON_LUADNS_TOKEN
    LEXICON_MEMSET_TOKEN=$(bashio::config 'dns.memset_token')
    export LEXICON_MEMSET_TOKEN
    LEXICON_NAMECHEAP_TOKEN=$(bashio::config 'dns.namecheap_token')
    export LEXICON_NAMECHEAP_TOKEN
    LEXICON_NAMECHEAP_USERNAME=$(bashio::config 'dns.namecheap_username')
    export LEXICON_NAMECHEAP_USERNAME
    LEXICON_NAMECHEAP_CLIENT_IP=$(bashio::config 'dns.namecheap_client_ip')
    export LEXICON_NAMECHEAP_CLIENT_IP
    LEXICON_NAMESILO_TOKEN=$(bashio::config 'dns.namesilo_token')
    export LEXICON_NAMESILO_TOKEN
    LEXICON_NETCUP_CUSTOMER_ID=$(bashio::config 'dns.netcup_customer_id')
    export LEXICON_NETCUP_CUSTOMER_ID
    LEXICON_NETCUP_API_KEY=$(bashio::config 'dns.netcup_api_key')
    export LEXICON_NETCUP_API_KEY
    LEXICON_NETCUP_API_PASSWORD=$(bashio::config 'dns.netcup_api_password')
    export LEXICON_NETCUP_API_PASSWORD
    LEXICON_NFSN_USERNAME=$(bashio::config 'dns.nfsn_username')
    export LEXICON_NFSN_USERNAME
    LEXICON_NFSN_TOKEN=$(bashio::config 'dns.nfsn_token')
    export LEXICON_NFSN_TOKEN
    LEXICON_NSONE_TOKEN=$(bashio::config 'dns.nsone_token')
    export LEXICON_NSONE_TOKEN
    LEXICON_ONAPP_USERNAME=$(bashio::config 'dns.onapp_username')
    export LEXICON_ONAPP_USERNAME
    LEXICON_ONAPP_TOKEN=$(bashio::config 'dns.onapp_token')
    export LEXICON_ONAPP_TOKEN
    LEXICON_ONAPP_SERVER=$(bashio::config 'dns.onapp_server')
    export LEXICON_ONAPP_SERVER
    LEXICON_ONLINE_TOKEN=$(bashio::config 'dns.online_token')
    export LEXICON_ONLINE_TOKEN
    LEXICON_OVH_APPLICATION_KEY=$(bashio::config 'dns.ovh_application_key')
    export LEXICON_OVH_APPLICATION_KEY
    LEXICON_OVH_APPLICATION_SECRET=$(bashio::config 'dns.ovh_application_secret')
    export LEXICON_OVH_APPLICATION_SECRET
    LEXICON_OVH_CONSUMER_KEY=$(bashio::config 'dns.ovh_consumer_key')
    export LEXICON_OVH_CONSUMER_KEY
    LEXICON_PLESK_USERNAME=$(bashio::config 'dns.plesk_username')
    export LEXICON_PLESK_USERNAME
    LEXICON_PLESK_PASSWORD=$(bashio::config 'dns.plesk_password')
    export LEXICON_PLESK_PASSWORD
    LEXICON_PLESK_PLESK_SERVER=$(bashio::config 'dns.plesk_plesk_server')
    export LEXICON_PLESK_PLESK_SERVER
    LEXICON_POINTHQ_USERNAME=$(bashio::config 'dns.pointhq_username')
    export LEXICON_POINTHQ_USERNAME
    LEXICON_POINTHQ_TOKEN=$(bashio::config 'dns.pointhq_token')
    export LEXICON_POINTHQ_TOKEN
    LEXICON_POWERDNS_TOKEN=$(bashio::config 'dns.powerdns_token')
    export LEXICON_POWERDNS_TOKEN
    LEXICON_POWERDNS_PDNS_SERVER=$(bashio::config 'dns.powerdns_pdns_server')
    export LEXICON_POWERDNS_PDNS_SERVER
    LEXICON_POWERDNS_PDNS_SERVER_ID=$(bashio::config 'dns.powerdns_pdns_server_id')
    export LEXICON_POWERDNS_PDNS_SERVER_ID
    LEXICON_POWERDNS_PDNS_DISABLE_NOTIFY=$(bashio::config 'dns.powerdns_pdns_disable_notify')
    export LEXICON_POWERDNS_PDNS_DISABLE_NOTIFY
    LEXICON_RACKSPACE_ACCOUNT=$(bashio::config 'dns.rackspace_account')
    export LEXICON_RACKSPACE_ACCOUNT
    LEXICON_RACKSPACE_USERNAME=$(bashio::config 'dns.rackspace_username')
    export LEXICON_RACKSPACE_USERNAME
    LEXICON_RACKSPACE_API_KEY=$(bashio::config 'dns.rackspace_api_key')
    export LEXICON_RACKSPACE_API_KEY
    LEXICON_RACKSPACE_TOKEN=$(bashio::config 'dns.rackspace_token')
    export LEXICON_RACKSPACE_TOKEN
    LEXICON_RACKSPACE_SLEEP_TIME=$(bashio::config 'dns.rackspace_sleep_time')
    export LEXICON_RACKSPACE_SLEEP_TIME
    LEXICON_RAGE4_USERNAME=$(bashio::config 'dns.rage4_username')
    export LEXICON_RAGE4_USERNAME
    LEXICON_RAGE4_TOKEN=$(bashio::config 'dns.rage4_token')
    export LEXICON_RAGE4_TOKEN
    LEXICON_RCODEZERO_TOKEN=$(bashio::config 'dns.rcodezero_token')
    export LEXICON_RCODEZERO_TOKEN
    LEXICON_ROUTE53_ACCESS_KEY=$(bashio::config 'dns.route53_access_key')
    export LEXICON_ROUTE53_ACCESS_KEY
    LEXICON_ROUTE53_ACCESS_SECRET=$(bashio::config 'dns.route53_access_secret')
    export LEXICON_ROUTE53_ACCESS_SECRET
    LEXICON_ROUTE53_PRIVATE_ZONE=$(bashio::config 'dns.route53_private_zone')
    export LEXICON_ROUTE53_PRIVATE_ZONE
    LEXICON_ROUTE53_USERNAME=$(bashio::config 'dns.route53_username')
    export LEXICON_ROUTE53_USERNAME
    LEXICON_ROUTE53_TOKEN=$(bashio::config 'dns.route53_token')
    export LEXICON_ROUTE53_TOKEN
    LEXICON_SAFEDNS_TOKEN=$(bashio::config 'dns.safedns_token')
    export LEXICON_SAFEDNS_TOKEN
    LEXICON_SAKURACLOUD_TOKEN=$(bashio::config 'dns.sakuracloud_token')
    export LEXICON_SAKURACLOUD_TOKEN
    LEXICON_SAKURACLOUD_SECRET=$(bashio::config 'dns.sakuracloud_secret')
    export LEXICON_SAKURACLOUD_SECRET
    LEXICON_SOFTLAYER_USERNAME=$(bashio::config 'dns.softlayer_username')
    export LEXICON_SOFTLAYER_USERNAME
    LEXICON_SOFTLAYER_API_KEY=$(bashio::config 'dns.softlayer_api_key')
    export LEXICON_SOFTLAYER_API_KEY
    LEXICON_SUBREG_USERNAME=$(bashio::config 'dns.subreg_username')
    export LEXICON_SUBREG_USERNAME
    LEXICON_SUBREG_PASSWORD=$(bashio::config 'dns.subreg_password')
    export LEXICON_SUBREG_PASSWORD
    LEXICON_TRANSIP_USERNAME=$(bashio::config 'dns.transip_username')
    export LEXICON_TRANSIP_USERNAME
    LEXICON_TRANSIP_API_KEY=$(bashio::config 'dns.transip_api_key')
    export LEXICON_TRANSIP_API_KEY
    LEXICON_VULTR_TOKEN=$(bashio::config 'dns.vultr_token')
    export LEXICON_VULTR_TOKEN
    LEXICON_YANDEX_TOKEN=$(bashio::config 'dns.yandex_token')
    export LEXICON_YANDEX_TOKEN
    LEXICON_ZEIT_TOKEN=$(bashio::config 'dns.zeit_token')
    export LEXICON_ZEIT_TOKEN
    LEXICON_ZILORE_KEY=$(bashio::config 'dns.zilore_key')
    export LEXICON_ZILORE_KEY
    LEXICON_ZONOMI_TOKEN=$(bashio::config 'dns.zonomi_token')
    export LEXICON_ZONOMI_TOKEN

    #Create a config
    mkdir -p /etc/dehydrated
    sed -i --regexp-extended "s/^#?BASEDIR=.*?$/BASEDIR=\"${cert_dir}\"/" /etc/dehydrated/config

    #Update email
    if [[ $email =~ ${email_regex} ]]; then
        sed -i --regexp-extended "s/^#?CONTACT_EMAIL=.*?$/CONTACT_EMAIL=\"${email}\"/" /etc/dehydrated/config
    else
        sed -i --regexp-extended 's/^#?CONTACT_EMAIL=(.*?)$/#CONTACT_EMAIL=\1/' /etc/dehydrated/config
    fi

    #Ensure we have an ID
    if [ ! -d "$cert_dir/accounts" ]; then
        /opt/dehydrated/dehydrated --register --accept-terms
    fi

    echo "# Home Assistant Domains" > "$cert_dir"/domains.txt

    firstcertalias=""

    while IFS= read -r line
    do
    certlist=( $line )
    certalias="${certlist[0]//[^A-Za-z0-9_-]/_}"
    if [ "$firstcertalias" == "" ]; then
        firstcertalias="${certalias}"
    fi
    bashio::log.info "[${certalias}]:\t$line"
    printf "${line} > ${certalias}\n" >> "$cert_dir"/domains.txt
    done < <(printf '%s\n' "$domains")

    printf "# END Home Assistant Domains\n" >> "$cert_dir"/domains.txt

    bashio::log.info "Requesting domains from LetsEncrypt"
    cat "$cert_dir"/domains.txt

    provider=${dns_provider} /opt/dehydrated/dehydrated --challenge dns-01 --out /ssl --keep-going --cron --hook /opt/dehydrated/dehydrated.default.sh

    bashio::log.info "Copying domains and keys"

    # copy certs to store
    if [ "$keyfile" != "" ]; then
    if [[ -f "/ssl/${firstcertalias}/privkey.pem" ]]; then
        cp -f /ssl/${firstcertalias}/privkey.pem /ssl/"$keyfile"
        else
        bashio::log.error "Failed to get ${keyfile} from ${firstcertalias}"
    fi
    fi
    if [ "$certfile" != "" ]; then
    if [[ -f "/ssl/${firstcertalias}/fullchain.pem" ]]; then
        cp -f /ssl/${firstcertalias}/fullchain.pem /ssl/"$certfile"
        else
        bashio::log.error "Failed to get ${certfile} from ${firstcertalias}"
    fi
    fi

    bashio::log.info "Cleaning Up"
    provider=${dns_provider} /opt/dehydrated/dehydrated --cleanup --out /ssl

    timestamp=$(date +"%T")

    bashio::log.info "Certificates refreshed at @ ${timestamp}"
}

# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
main() {
    local sleep

    bashio::log.trace "${FUNCNAME[0]}"

    # sleep=$(bashio::config 'seconds_between_quotes')
    sleep=86400
    bashio::log.info "Seconds between each refresh is set to: ${sleep}"

    while true; do
        refresh_certificates
        sleep "${sleep}"
    done
}
main "$@"
