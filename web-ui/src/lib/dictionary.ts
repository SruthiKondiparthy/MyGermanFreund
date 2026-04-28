export type Locale = 'en' | 'de';

export const dictionary = {
  en: {
    'nav.landing': 'Landing',
    'nav.guides': 'Guides',
    'nav.scanner': 'Letter Scanner',
    'nav.dashboard': 'Dashboard',
    'landing.title': 'Your Germany onboarding companion',
    'landing.tabs': 'Feature tabs: Guides, Scanner, Dashboard, Buzz',
    'landing.personas': 'Personas: Student, Family, Professional, Refugee',
    'landing.buzz': 'German Buzz (bottom-left floating action)',
    'guides.title': 'Core Guides',
    'scanner.title': 'Letter Scanner',
    'dashboard.title': 'Personal Dashboard',
  },
  de: {
    'nav.landing': 'Startseite',
    'nav.guides': 'Leitfäden',
    'nav.scanner': 'Briefscanner',
    'nav.dashboard': 'Dashboard',
    'landing.title': 'Dein Begleiter für den Start in Deutschland',
    'landing.tabs': 'Funktionsbereiche: Leitfäden, Scanner, Dashboard, Buzz',
    'landing.personas': 'Personas: Studierende, Familie, Berufstätige, Geflüchtete',
    'landing.buzz': 'German Buzz (schwebendes Symbol unten links)',
    'guides.title': 'Kern-Leitfäden',
    'scanner.title': 'Briefscanner',
    'dashboard.title': 'Persönliches Dashboard',
  },
} as const;
