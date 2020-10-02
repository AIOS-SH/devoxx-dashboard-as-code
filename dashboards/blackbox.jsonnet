local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;
local template = grafana.template;

local promTemplate(name) = template.new(
    name,
    '$datasource',
    'label_values(probe_duration_seconds, ' + name + ')',
    multi=true,
    includeAll=true,
    label=name,
    refresh='time',
);

dashboard.new(
    'Blackbox',
    tags=['blackbox'],
    refresh="1m",
).addTemplate(
    grafana.template.datasource('datasource', 'prometheus', 'default')
).addTemplate(promTemplate('namespace')
).addTemplate(promTemplate('app')
).addRow(
    row.new(
        title="Informations",
        height='100px'
    ).addPanel(
        singlestat.new(
            'avg response time (1h)',
            format='s',
            datasource='$datasource',
            valueName='current',
            colorValue=true,
            thresholds="0.2,0.5",
        ).addTarget(
            prometheus.target("avg(avg_over_time(probe_duration_seconds{namespace=~'$namespace',app=~'$app'}[1h]))")
        ),
        gridPos={x: 0, y: 0, w: 3, h: 3,}
    ).addPanel(
        singlestat.new(
            'availability (1h)',
            format='percentunit',
            datasource='$datasource',
            valueName='current',
            colorValue=true,
            thresholds="0.9,0.99",
            colors=["red", "orange", "green"]
        ).addTarget(
            prometheus.target("avg(avg_over_time(probe_success{namespace=~'$namespace',app=~'$app'}[1h]))")
        ),
        gridPos={x: 3, y: 0, w: 3, h: 3,}
    ).addPanel(
        singlestat.new(
            'cert expiration',
            format='dateTimeFromNow',
            datasource='$datasource',
            valueName='current',
        ).addTarget(
            prometheus.target("min(probe_ssl_earliest_cert_expiry{namespace=~'$namespace',app=~'$app'}) * 1000")
        ),
        gridPos={x: 6, y: 0, w: 3, h: 3,}
    )
).addRow(
    row.new(
        title="Response time",
        height='400px'
    ).addPanel(
        graphPanel.new(
            'avg response time (second)',
            format="s",
            datasource='$datasource',
            span=12,
            legend_values=true,
            legend_min=true,
            legend_max=true,
            legend_current=true,
            legend_total=false,
            legend_avg=true,
            legend_alignAsTable=true
        ).addTarget(
            prometheus.target(
                "avg(probe_duration_seconds{namespace=~'$namespace',app=~'$app'}) by (namespace, app)",
                legendFormat='{{ namespace }} {{ app }}',
            ),
        )
    )
)
