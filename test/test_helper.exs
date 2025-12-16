Application.ensure_started(:telemetry)
Application.ensure_all_started(:mimic)

Mimic.copy(GenSpring.Handler)
Mimic.copy(GenSpring.Buffer)
Mimic.copy(GenSpring.Protocol.Requests)
Mimic.copy(GenSpring.Communication.Transport)
Mimic.copy(ThousandIsland.Socket)

ExUnit.start()
