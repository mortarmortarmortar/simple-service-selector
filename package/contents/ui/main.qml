import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    // Parsed from the "services" config entry. Each entry:
    // { name, icon, onCommand, offCommand, statusCommand }
    readonly property var services: {
        try {
            const parsed = JSON.parse(Plasmoid.configuration.services)
            return Array.isArray(parsed) ? parsed : []
        } catch (e) {
            console.warn("LocalAIToggle: could not parse services config:", e)
            return []
        }
    }

    // index (as string) -> "running" | "stopped"; absent means unknown
    property var serviceStatus: ({})
    // index (as string) -> true while an on/off command is in flight
    property var serviceBusy: ({})
    // command string -> [{index, kind}] jobs waiting on that command
    property var pending: ({})

    fullRepresentation: FullRepresentation {}
    compactRepresentation: CompactRepresentation {}

    function statusOf(index) {
        return serviceStatus[String(index)] || "unknown"
    }

    function isBusy(index) {
        return serviceBusy[String(index)] === true
    }

    function exec(cmd, index, kind) {
        if (!cmd) {
            return
        }
        const next = Object.assign({}, pending)
        next[cmd] = (next[cmd] || []).concat([{ index: index, kind: kind }])
        pending = next
        executor.connectSource(cmd)
    }

    function toggle(index) {
        const svc = services[index]
        if (!svc || isBusy(index)) {
            return
        }
        const cmd = statusOf(index) === "running" ? svc.offCommand : svc.onCommand
        if (!cmd) {
            return
        }
        serviceBusy = Object.assign({}, serviceBusy, { [String(index)]: true })
        exec(cmd, index, "toggle")
    }

    function pollStatus(index) {
        const svc = services[index]
        if (svc && svc.statusCommand) {
            exec(svc.statusCommand, index, "status")
        }
    }

    function pollAll() {
        for (let i = 0; i < services.length; ++i) {
            pollStatus(i)
        }
    }

    onServicesChanged: {
        serviceStatus = {}
        serviceBusy = {}
        pollAll()
    }

    Component.onCompleted: pollAll()

    // Runs commands through the "executable" data engine (/bin/sh -c).
    // Status convention: exit code 0 = running, anything else = stopped.
    Plasma5Support.DataSource {
        id: executor
        engine: "executable"
        connectedSources: []

        onNewData: function (source, data) {
            disconnectSource(source)
            const exitCode = data["exit code"]

            const jobs = root.pending[source] || []
            const nextPending = Object.assign({}, root.pending)
            delete nextPending[source]
            root.pending = nextPending

            const statusUpdates = {}
            const busyUpdates = {}
            const repoll = []
            for (const job of jobs) {
                const key = String(job.index)
                if (job.kind === "status") {
                    statusUpdates[key] = exitCode === 0 ? "running" : "stopped"
                } else {
                    if (exitCode !== 0) {
                        console.warn("LocalAIToggle: command failed (" + exitCode + "):",
                                     source, data["stderr"])
                    }
                    busyUpdates[key] = false
                    repoll.push(job.index)
                }
            }
            if (Object.keys(statusUpdates).length > 0) {
                root.serviceStatus = Object.assign({}, root.serviceStatus, statusUpdates)
            }
            if (Object.keys(busyUpdates).length > 0) {
                root.serviceBusy = Object.assign({}, root.serviceBusy, busyUpdates)
            }
            for (const i of repoll) {
                root.pollStatus(i)
            }
        }
    }

    Timer {
        interval: Math.max(2, Plasmoid.configuration.pollInterval) * 1000
        running: Plasmoid.configuration.pollInterval > 0 && root.services.length > 0
        repeat: true
        onTriggered: root.pollAll()
    }
}
