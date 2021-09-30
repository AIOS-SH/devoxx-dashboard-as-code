local g = import 'grafonnet/grafana.libsonnet';

local kubeSchema = {
  fieldConfig: {
    defaults: {
      decimals: 0,
      thresholds: {
        steps: [
          { color: "red", value: null },
          { color: "orange", value: 0.8 },
          { color: "green", value: 1.0 },
        ]
      },
      unit: "percentunit"
    },
  },
  options: {
    content: importstr "schema.mermaid",
    legend: {
      gradient: {},
      show: false,
    },
    useBackground: true,
  },
  title: "Kube schema",
  type: "jdbranham-diagram-panel",
  targets: [
    {
      expr: "kube_pod_container_status_running",
      legendFormat: "{{ container }}",
      refId: "A"
    }
  ],
};


g.dashboard.new(
  'Kube architecture',
  tags=['kube', 'schema'],
  editable=true,
  time_from='now-1h',
  refresh='1m',
).addPanel(
    kubeSchema,
    gridPos={h: 20, w: 24, x: 0, y: 0}
)
