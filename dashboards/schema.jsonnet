local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local kubeSchema = {
  content: importstr "schema.mermaid",
  "colors": [
    "rgba(245, 54, 54, 0.9)",
    "rgba(50, 172, 45, 0.97)"
  ],
  legend: {
    gradient: { enabled: false, show: true },
    show: false,
  },
  decimals: 0,
  format: "percentunit",
  thresholds: "0,1",
  title: "Kube schema",
  type: "jdbranham-diagram-panel",
  targets: [
    {
      expr: "up",
      legendFormat: "{{ job }}",
      refId: "A"
    },
    {
      expr: "kube_pod_container_status_running",
      legendFormat: "{{ container }}",
      refId: "B"
    }
  ],
};


dashboard.new(
  'Kube architecture',
  tags=['kube', 'schema'],
  editable=true,
  time_from='now-1h',
  refresh='1m',
)
.addTemplate(
  template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    hide='label',
  )
)
.addTemplate(
  template.new(
    'instance',
    '$PROMETHEUS_DS',
    'label_values(prometheus_build_info, instance)',
    label='Instance',
    refresh='time',
  )
)

.addPanels(
  [
    kubeSchema { gridPos: { h: 14, w: 10, x: 0, y: 0 } },
  ]
)
