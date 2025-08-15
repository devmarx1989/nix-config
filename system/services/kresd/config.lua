modules.load('predict')
modules.load('http')

cache.size = 10024 * MB

trust_anchors.remove('.')
net.listen('0.0.0.0', ${kresdProm}, { kind = 'webmgmt' })

http.prometheus.namespace = 'kresd_'
