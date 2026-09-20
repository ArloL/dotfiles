# The mail filters that ran as Mail.app rules until they moved server-side to
# also apply on iOS. This is a copy of the active Sieve script "notifications"
# on mx2e15.netcup.net; nothing in this repo deploys it, so edits take effect
# only once re-uploaded via netcup's webmail or ManageSieve on port 4190.

require ["fileinto"];

# DMARC
if address :contains "to" "headlines@k5d.de" {
    fileinto "Notifications";
    stop;
}

# Mozilla Add-ons
if anyof (
    address :contains "from" "nobody@mozilla.org",
    address :contains "to" "redpanda@k5d.de",
    header :contains "subject" "Mozilla Add-ons: Configurable Containers Dev [ref:Addon#3045784]"
) {
    fileinto "Notifications";
    stop;
}

# GitHub
if address :contains "from" "notifications@github.com" {
    fileinto "Notifications";
    stop;
}
