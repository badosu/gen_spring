Application.ensure_started(:telemetry)
Application.ensure_all_started(:mimic)

Mimic.copy(GenSpring.Buffer)
Mimic.copy(GenSpring.Requests)
Mimic.copy(ThousandIsland.Socket)

ExUnit.start()
