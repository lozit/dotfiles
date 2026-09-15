// Prochain rendez-vous du Calendrier macOS, formaté pour SketchyBar.
// Sortie : "<label>\t<urgent 0|1>"  — rien si aucun événement.
// Usage   : next_event [heures_a_regarder]   (défaut : 12)
import EventKit
import Foundation

let hours = Double(CommandLine.arguments.dropFirst().first ?? "") ?? 12
let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false

if #available(macOS 14.0, *) {
    store.requestFullAccessToEvents { g, _ in granted = g; sem.signal() }
} else {
    store.requestAccess(to: .event) { g, _ in granted = g; sem.signal() }
}
sem.wait()
guard granted else { print("Calendrier : accès refusé\t0"); exit(2) }

let now = Date()
let end = now.addingTimeInterval(hours * 3600)
let predicate = store.predicateForEvents(withStart: now, end: end, calendars: nil)

let events = store.events(matching: predicate)
    .filter { !$0.isAllDay && $0.startDate > now && $0.status != .canceled }
    .filter { ev in
        let me = ev.attendees?.first(where: { $0.isCurrentUser })
        return me?.participantStatus != .declined
    }
    .sorted { $0.startDate < $1.startDate }

guard let ev = events.first else { exit(0) }

var title = (ev.title ?? "Sans titre").trimmingCharacters(in: .whitespacesAndNewlines)
if title.count > 32 { title = String(title.prefix(31)) + "…" }

let fmt = DateFormatter()
fmt.locale = Locale(identifier: "fr_FR")
fmt.dateFormat = "HH:mm"

let minutes = Int(ceil(ev.startDate.timeIntervalSince(now) / 60))
let urgent = minutes <= 10 ? 1 : 0
let prefix = Calendar.current.isDateInTomorrow(ev.startDate) ? "demain " : ""
print("\(title)  \(prefix)\(fmt.string(from: ev.startDate))\t\(urgent)")
