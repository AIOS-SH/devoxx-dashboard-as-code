local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local singlestat = grafana.singlestat;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local kubeSchema = {
  content: importstr "schema.mermaid",
  legend: {
    avg: true,
    current: true,
    gradient: {
      enabled: false,
      show: true
    },
    max: true,
    min: true,
    show: false,
    total: true
  },
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
