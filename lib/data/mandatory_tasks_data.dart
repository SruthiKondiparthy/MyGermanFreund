import '../models/mandatory_task.dart';

final List<MandatoryTask> mandatoryTasks = [
  MandatoryTask(
    order: 1,
    title: "Register Address (Anmeldung)",
    description: "Register your address at the Bürgeramt to get your Meldebescheinigung.",
    estimatedTime: "1–2 hours (appointment)",
    link: "https://service.berlin.de/dienstleistung/120686/",
  ),
  MandatoryTask(
    order: 2,
    title: "Open a Bank Account",
    description: "You’ll need this for rent, salary, and insurance payments.",
    estimatedTime: "30–60 mins",
    link: "https://n26.com",
  ),
  MandatoryTask(
    order: 3,
    title: "Get Health Insurance",
    description: "Mandatory for all residents; choose public or private.",
    estimatedTime: "1–3 days",
    link: "https://www.tk.de",
  ),
  MandatoryTask(
    order: 4,
    title: "Apply for Tax ID",
    description: "Generated automatically after Anmeldung; mailed to your address.",
    estimatedTime: "2–3 weeks (auto)",
    link: "https://www.bzst.de/EN/Privatpersonen/IdNr/ID_node.html",
  ),
  MandatoryTask(
    order: 5,
    title: "Apply for Residence Permit",
    description: "Apply at your local Ausländerbehörde if staying >3 months.",
    estimatedTime: "2–6 weeks",
    link: "https://www.berlin.de/einwanderung/",
  ),
];
