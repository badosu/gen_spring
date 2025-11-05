Application.ensure_started(:telemetry)
Application.ensure_all_started(:mimic)

Mimic.copy(GenSpring.Communication.Buffer)

ExUnit.start()
