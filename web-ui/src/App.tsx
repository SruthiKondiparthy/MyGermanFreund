import { Link, Route, Routes } from 'react-router-dom';
import { DashboardPage } from './pages/DashboardPage';
import { GuidesPage } from './pages/GuidesPage';
import { LandingPage } from './pages/LandingPage';
import { ScannerPage } from './pages/ScannerPage';
import { useLocale } from './lib/useLocale';

export const App = () => {
  const { locale, toggleLocale, t } = useLocale();

  return (
    <div>
      <header className="topbar">
        <h1>MyGermanFreund</h1>
        <nav>
          <Link to="/">{t('nav.landing')}</Link>
          <Link to="/guides">{t('nav.guides')}</Link>
          <Link to="/scanner">{t('nav.scanner')}</Link>
          <Link to="/dashboard">{t('nav.dashboard')}</Link>
        </nav>
        <button onClick={toggleLocale}>{locale.toUpperCase()}</button>
      </header>

      <main className="container">
        <Routes>
          <Route path="/" element={<LandingPage t={t} />} />
          <Route path="/guides" element={<GuidesPage t={t} />} />
          <Route path="/scanner" element={<ScannerPage t={t} />} />
          <Route path="/dashboard" element={<DashboardPage t={t} />} />
        </Routes>
      </main>
    </div>
  );
};
