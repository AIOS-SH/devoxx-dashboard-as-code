local g = import 'grafonnet/grafana.libsonnet';

g.dashboard.new(
    "Bonjour Devoxx 2021",
    refresh="30s",
    time_from="now-1h"
).addTemplate(
    g.template.new(
        "instance",
        datasource="default",
        query="label_values(probe_success, instance)",
        multi=true,
        includeAll=true,
        refresh="time"
    )
).addRow(
    g.row.new(
        "Basic informations"
    ).addPanel(
        g.singlestat.new(
            "Probe status",
            span=6
        ).addTarget(
            g.prometheus.target("probe_success{instance=~'$instance'}")
        )
    )
).addRow(
    g.row.new(
        "Response time",
        height="400px"
    ).addPanel(
        g.graphPanel.new(
            "Avg response time (s)",
            span=12
        ).addTarget(
            g.prometheus.target("probe_duration_seconds{instance=~'$instance'}")
        )
    )
)