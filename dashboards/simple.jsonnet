local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local gd = g.dashboard;
local var = gd.variable;
local vq = var.query;
local ds = var.datasource.new('datasource', 'prometheus');

gd.new('Go exporter versions')
+ gd.withVariables([
    ds,
    vq.new('job')
        + vq.withDatasourceFromVariable(ds)
        + vq.queryTypes.withLabelValues('job', 'go_info')
        + vq.withRefresh('time')
        + vq.selectionOptions.withMulti()
        + vq.selectionOptions.withIncludeAll(),
    vq.new('instance')
        + vq.withDatasourceFromVariable(ds)
        + vq.queryTypes.withLabelValues('instance', 'go_info{job=~"$job"}')
        + vq.withRefresh('time')
        + vq.selectionOptions.withMulti()
        + vq.selectionOptions.withIncludeAll(),
])
+ gd.withUid('go-exporter-versions')
+ gd.withDescription('All existing go versions used by Prometheus exporter')
+ gd.graphTooltip.withSharedCrosshair()
+ gd.withPanels([
    g.panel.stat.new('$job version')
    + g.panel.stat.options.withTextMode("name")
    + g.panel.stat.withRepeat("job")
    + g.panel.timeSeries.withTargets([
          g.query.prometheus.new('$datasource', 'max by (instance, job, version) (go_info{job=~"$job"})') +
          g.query.prometheus.withLegendFormat('{{ version }}')
      ])
])
